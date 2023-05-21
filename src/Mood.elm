module Mood exposing (mood)

import Common exposing (..)
import Html exposing (Html, button, div, h1, img, input, label, option, p, select, source, span, text, video)
import Html.Attributes exposing (autoplay, class, classList, disabled, for, height, href, id, loop, src, step, style, type_, value, width)
import Html.Attributes.Aria exposing (ariaLabel)
import Html.Events exposing (onClick, onInput)
import Http
import Json.Encode
import Types exposing (Model, Msg(..))



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
