module Common exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Json.Encode
import Types exposing (..)
import VitePluginHelper


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


nbsp : String
nbsp =
    Char.fromCode 0xA0 |> String.fromChar


user_login : Model -> Html Msg
user_login model =
    case model.user of
        Just user ->
            let
                uname =
                    user.username
            in
            div []
                [ div [ class "sidebar-user-pic" ]
                    [ img [ src <| VitePluginHelper.asset "/assets/loggedin.png", style "width" "43px", style "height" "43px" ] []
                    , span [ class "sidebar-option-text", style "margin-left" "15px" ] [ text ("Hi " ++ uname ++ "!") ]
                    ]
                , div [ class "sidebar-user", style "left" "30px" ]
                    [ span [ id "sidebar-option-text2" ]
                        [ span [ class "material-symbols-outlined", style "font-size" "17px" ]
                            [ text "arrow_forward_ios" ]
                        ]
                    , a [ href "/logout" ] [ span [ class "sidebar-option-text" ] [ span [ id "sidebar-option-text2" ] [ text (nbsp ++ nbsp ++ nbsp ++ nbsp ++ nbsp ++ nbsp ++ "Log Out") ] ] ]
                    ]
                ]

        _ ->
            div []
                [ img [ class "sidebar-user-pic", src <| VitePluginHelper.asset "/assets/loggedout.png", style "width" "45px", style "height" "45px" ] []
                , div [ class "sidebar-user" ]
                    [ a [ href "/login " ] [ span [ id "sidebar-option-text2" ] [ text "Login" ] ]
                    , span [ class "sidebar-option-text" ] [ text (nbsp ++ nbsp ++ "/" ++ nbsp ++ nbsp) ]
                    , a [ href "/register" ] [ span [ class "sidebar-option-text" ] [ span [ id "sidebar-option-text2" ] [ text "Register" ] ] ]
                    ]
                ]


sidebar : Model -> Html Msg
sidebar model =
    div [ class "sidebar" ]
        [ div [ class "logo" ]
            [ img [ src <| VitePluginHelper.asset "/assets/logo.png", style "width" "54px", style "height" "39.94px" ] []
            , span [ class "sidebar-option-text" ] [ text "soundscapes" ]
            ]
        , hr [ class "divider" ] []
        , div [ class "sidebar-options" ]
            [ a [ href "/", onClick RestorePlaylist ]
                [ span [ class "material-symbols-outlined" ] [ text "emoticon" ]
                , span [ class "sidebar-option-text" ]
                    [ text (nbsp ++ nbsp ++ nbsp)
                    , text "/"
                    , text (nbsp ++ nbsp ++ nbsp)
                    , span [ id "sidebar-option-text2" ] [ text "mood based" ]
                    ]
                ]
            -- , a [ href "#" ]
            --     [ span [ class "material-symbols-outlined" ]
            --         [ text "music_note" ]
            --     , span [ class "sidebar-option-text" ]
            --         [ text (nbsp ++ nbsp ++ nbsp)
            --         , text "/"
            --         , text (nbsp ++ nbsp ++ nbsp)
            --         , span [ id "sidebar-option-text2" ] [ text "song based" ]
            --         ]
            --     ]
            , a [ href "/name", onClick RestorePlaylist ]
                [ span [ class "material-symbols-outlined" ]
                    [ text "search" ]
                , span [ class "sidebar-option-text" ]
                    [ text (nbsp ++ nbsp ++ nbsp)
                    , text "/"
                    , text (nbsp ++ nbsp ++ nbsp)
                    , span [ id "sidebar-option-text2" ] [ text "name based" ]
                    ]
                ]
            , a [ href "/dashboard" ]
                [ span [ class "material-symbols-outlined" ]
                    [ text "dashboard" ]
                , span [ class "sidebar-option-text" ]
                    [ text (nbsp ++ nbsp ++ nbsp)
                    , text "/"
                    , text (nbsp ++ nbsp ++ nbsp)
                    , span [ id "sidebar-option-text2" ] [ text "dashboard" ]
                    ]
                ]
            , case model.user of
                Just user ->
                    if user.role == 1 then
                        a [ href "/admin" ]
                            [ span [ class "material-symbols-outlined" ]
                                [ text "dashboard" ]
                            , span [ class "sidebar-option-text" ]
                                [ text (nbsp ++ nbsp ++ nbsp)
                                , text "/"
                                , text (nbsp ++ nbsp ++ nbsp)
                                , span [ id "sidebar-option-text2" ] [ text "admin dashboard" ]
                                ]
                            ]

                    else
                        div [] []

                Nothing ->
                    div [] []
            ]
        , user_login model
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
                          , div [ class "buttons" ]
                                [ div [ class "button" ] [
                                  case model.user of
                                    Just _ ->
                                             button [ type_ "submit", onClick PlaylistStoreSubmit, class "btn block-cube block-cube-hover", id "b" ]
                                                [ div [ class "bg-top" ]
                                                    [ div [ class "bg-inner" ] [] ]
                                                , div [ class "bg-right" ]
                                                    [ div [ class "bg-inner" ] [] ]
                                                , div [ class "bg" ]
                                                    [ div [ class "bg-inner" ] [] ]
                                                , div [ class "text" ] [ text "Save Playlist" ]
                                                ]

                                    Nothing ->
                                         div [] [] 
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
