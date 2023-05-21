module Mood exposing (mood, storePlaylist)

import Common exposing (nbsp, sidebar)
import Html exposing (Html, button, div, h1, img, input, label, option, p, select, source, span, text, video)
import Html.Attributes exposing (autoplay, class, classList, disabled, for, height, href, id, loop, src, step, style, type_, value, width)
import Html.Attributes.Aria exposing (ariaLabel)
import Html.Events exposing (onClick, onInput)
import Http
import Json.Encode
import Types exposing (Model, Msg(..))


storePlaylist : String -> String -> String -> Cmd Msg
storePlaylist name url token =
    Http.request
        { method = "POST"
        , url = "http://localhost:3000/playlists"
        , headers = [ Http.header "auth" token ]
        , body =
            Http.jsonBody
                (Json.Encode.object
                    [ ( "name", Json.Encode.string name )
                    , ( "url", Json.Encode.string url )
                    ]
                )
        , expect = Http.expectWhatever PlaylistStoreRequest
        , timeout = Nothing
        , tracker = Nothing
        }


moodSelector : Model -> List (Html Msg)
moodSelector model =
    [ div [ classList [ ( "range-div", True ), ( "visible", model.divvis.visible1 ) ] ]
        [ p [] [ text "How are you feeling?" ]
        , div [ class "range" ]
            [ div [ class "label-left" ]
                [ label [ for "emotionalRange", class "form-label" ]
                    [ span [ class "material-symbols-outlined" ] [ text "sentiment_dissatisfied" ]
                    ]
                ]
            , input
                [ type_ "range"
                , class "form-range"
                , Html.Attributes.min "1"
                , Html.Attributes.max "5"
                , step "1"
                , id "emotionalRange"
                , disabled (not model.divvis.visible1)
                , onInput
                    (\v ->
                        MoodUpdate
                            (let
                                val =
                                    Maybe.withDefault -1 (String.toInt v)
                             in
                             val
                            )
                    )
                ]
                []
            , div [ class "label-right" ]
                [ label [ for "emotionalRange", class "form-label" ]
                    [ span [ class "material-symbols-outlined" ] [ text "sentiment_excited" ]
                    ]
                ]
            ]
        ]
    , div [ classList [ ( "select-div", True ), ( "visible", not model.divvis.visible1 ) ] ]
        [ p [] [ text "What genre are you in the mood for?" ]
        , div [ class "range control block-cube block-input" ]
            [ select
                [ class "form-select"
                , ariaLabel "Pick your genre"
                , id "genreInput"
                , disabled model.divvis.visible1
                , onInput
                    (\v ->
                        GenreUpdate v
                    )
                ]
                [ option [ value "Rock" ] [ text "Rock" ]
                , option [ value "Electronic" ] [ text "Electronic" ]
                , option [ value "Jazz" ] [ text "Jazz" ]
                , option [ value "Pop" ] [ text "Pop" ]
                , option [ value "Hip-hop" ] [ text "Hip-hop" ]
                , option [ value "Metal" ] [ text "Metal" ]
                , option [ value "Indie" ] [ text "Indie" ]
                ]
            ]
        ]
    , div [ class "form", style "margin-top" "-50px", style "margin-bottom" "auto", style "width" "150px" ]
        [ if model.divvis.visible1 then
            div [ class "button" ]
                [ button [ class "btn block-cube block-cube-hover", id "b", onClick Types.ToggleDiv ]
                    [ div [ class "bg-top" ]
                        [ div [ class "bg-inner" ] [] ]
                    , div [ class "bg-right" ]
                        [ div [ class "bg-inner" ] [] ]
                    , div [ class "bg" ]
                        [ div [ class "bg-inner" ] [] ]
                    , div [ class "text" ] [ text "Next" ]
                    ]
                ]

          else
            div [ class "button" ]
                [ button [ onClick PlaylistSubmit, type_ "submit", class "btn block-cube block-cube-hover", id "b" ]
                    [ div [ class "bg-top" ]
                        [ div [ class "bg-inner" ] [] ]
                    , div [ class "bg-right" ]
                        [ div [ class "bg-inner" ] [] ]
                    , div [ class "bg" ]
                        [ div [ class "bg-inner" ] [] ]
                    , div [ class "text" ] [ text "Submit" ]
                    ]
                ]
        ]
    ]


limitText : Int -> String -> String
limitText limit str =
    if String.length str <= limit then
        str

    else
        String.left limit str ++ "..."


playlistShow : Model -> List (Html Msg)
playlistShow model =
    case model.tracks of
        Nothing ->
            [ div [ style "padding" "30px" ]
                [ text "Loading!"
                ]
            ]

        Just tracks ->
            [ div [ class "playlist-background" ] []
            , case model.playlist of
                Just pl ->
                    div [ id "playlist-header" ]
                        [ Html.a [ id "playlist-name", href ("https://open.spotify.com/playlist/" ++ pl.id) ] [ text (limitText 60 pl.name) ]
                        , div [ class "buttons" ] [
                           div [ class "button" ]
                              [ button [ type_ "submit", onClick PlaylistStoreSubmit, class "btn block-cube block-cube-hover", id "b" ]
                                  [ div [ class "bg-top" ]
                                      [ div [ class "bg-inner" ] [] ]
                                  , div [ class "bg-right" ]
                                      [ div [ class "bg-inner" ] [] ]
                                  , div [ class "bg" ]
                                      [ div [ class "bg-inner" ] [] ]
                                  , div [ class "text" ] [ text "Save Playlist" ]
                                  ]
                              ]
                          , div [ class "button" ]
                              [ button [ type_ "submit", onClick RestorePlaylist, class "btn block-cube block-cube-hover", id "b" ]
                                  [ div [ class "bg-top" ]
                                      [ div [ class "bg-inner" ] [] ]
                                  , div [ class "bg-right" ]
                                      [ div [ class "bg-inner" ] [] ]
                                  , div [ class "bg" ]
                                      [ div [ class "bg-inner" ] [] ]
                                  , div [ class "text" ] [ text "Go Back" ]
                                  ]
                              ]
                        ]
                     ]

                Nothing ->
                    div []
                        [ text "No playlist name"
                        ]
            , Html.hr [] []
            , div [ class "playlist-scroll" ]
                (List.indexedMap
                    (\index track ->
                        Maybe.withDefault (div [] [])
                            (Maybe.map
                                (\imag ->
                                    div []
                                        [ div [ style "display" "flex", style "align-items" "center", style "margin" "20px" ]
                                            [ div [ style "text-align" "right", style "margin-right" "10px" ]
                                                [ text (String.fromInt (index + 1) ++ nbsp ++ nbsp ++ nbsp)
                                                ]
                                            , img [ src imag, height 65, width 65, style "border-radius" "10px" ] []
                                            , div [ class "track-space" ]
                                                [ Html.a [ id "track-name", href ("https://open.spotify.com/track/" ++ track.id) ] [ text track.musicName ]
                                                , span [ id "artist-name" ]
                                                    [ text ("-" ++ nbsp)
                                                    , text track.artistName
                                                    ]
                                                ]
                                            ]
                                        , Html.hr [ class "divider" ] []
                                        ]
                                )
                                track.image
                            )
                    )
                    tracks
                )
            ]


mood : Model -> Html Msg
mood model =
    div []
        [ video [ autoplay True, loop True, id "bg-video" ] [ source [ src "/assets/waves.mp4", type_ "video/mp4" ] [] ]
        , sidebar model
        , div [ class "main-content" ]
            [ h1 [ id "title" ]
                [ text "soundscapes" ]
            , if model.divvis.visible1 || model.divvis.visible2 then
                div [ class "center-content" ] (moodSelector model)

              else
                div [ class "playlist" ] (playlistShow model)
            ]
        ]
