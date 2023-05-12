module Mood exposing (mood)

import Common exposing (sidebar)
import Html exposing (Html, button, div, form, h1, input, label, option, p, select, source, span, text, video)
import Html.Attributes exposing (autoplay, class, classList, disabled, for, id, loop, selected, src, step, style, type_, value)
import Html.Attributes.Aria exposing (ariaLabel)
import Html.Events exposing (onClick)
import Types exposing (Model, Msg)


mood : Model -> Html Msg
mood model =
    div []
        [ video [ autoplay True, loop True, id "bg-video" ] [ source [ src "/assets/waves.mp4", type_ "video/mp4" ] [] ]
        , sidebar model
        , div [ class "main-content" ]
            [ h1 [ id "title" ] [ text "soundscapes" ]
            , div [ class "center-content" ]
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
                            , Html.Attributes.min "0"
                            , Html.Attributes.max "5"
                            , step "0.5"
                            , id "emotionalRange"
                            , disabled (not model.divvis.visible1)
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
                            ]
                            [ option [ selected True ] [ text "Rock" ]
                            , option [ value "1" ] [ text "Electronic" ]
                            , option [ value "2" ] [ text "Jazz" ]
                            , option [ value "3" ] [ text "Pop" ]
                            , option [ value "4" ] [ text "Hip-hop" ]
                            , option [ value "5" ] [ text "Metal" ]
                            , option [ value "5" ] [ text "Indie" ]
                            ]
                        ]
                    ]
                ]
            , div [ class "form", style "margin-top" "-550px", style "margin-bottom" "auto", style "width" "150px" ]
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
                        [ button [ type_ "submit", class "btn block-cube block-cube-hover", id "b" ]
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
        ]
