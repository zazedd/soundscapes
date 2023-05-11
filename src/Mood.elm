module Mood exposing (mood)

import Html exposing (Html, a, button, div, h1, hr, img, input, label, option, p, select, source, span, text, video)
import Html.Attributes exposing (autoplay, class, classList, disabled, for, href, id, loop, selected, src, step, style, type_, value)
import Html.Attributes.Aria exposing (ariaLabel)
import Html.Events exposing (onClick)
import Types exposing (Model, Msg)
import VitePluginHelper


nbsp : String
nbsp =
    Char.fromCode 0xA0 |> String.fromChar


mood : Model -> Html Msg
mood model =
    div []
        [ video [ autoplay True, loop True, id "bg-video" ] [ source [ src "/assets/waves.mp4", type_ "video/mp4" ] [] ]
        , div [ class "dashboard" ]
            [ div [ class "logo" ]
                [ img [ src <| VitePluginHelper.asset "/assets/logo.png", style "width" "54px", style "height" "39.94px" ] []
                , span [ class "dashboard-option-text" ] [ text "soundscapes" ]
                ]
            , hr [ class "divider" ] []
            , div [ class "dashboard-options" ]
                [ a [ href "#" ]
                    [ span [ class "material-symbols-outlined" ] [ text "emoticon" ]
                    , span [ class "dashboard-option-text" ]
                        [ text (nbsp ++ nbsp ++ nbsp)
                        , text "/"
                        , text (nbsp ++ nbsp ++ nbsp)
                        , span [ id "dashboard-option-text2" ] [ text "mood based" ]
                        ]
                    ]
                , a [ href "#" ]
                    [ span [ class "material-symbols-outlined" ]
                        [ text "music_note" ]
                    , span [ class "dashboard-option-text" ]
                        [ text (nbsp ++ nbsp ++ nbsp)
                        , text "/"
                        , text (nbsp ++ nbsp ++ nbsp)
                        , span [ id "dashboard-option-text2" ] [ text "song based" ]
                        ]
                    ]
                , a [ href "#" ]
                    [ span [ class "material-symbols-outlined" ]
                        [ text "calendar_month" ]
                    , span [ class "dashboard-option-text" ]
                        [ text (nbsp ++ nbsp ++ nbsp)
                        , text "/"
                        , text (nbsp ++ nbsp ++ nbsp)
                        , span [ id "dashboard-option-text2" ] [ text "year based" ]
                        ]
                    ]
                , a [ href "#" ]
                    [ span [ class "material-symbols-outlined" ]
                        [ text "dashboard" ]
                    , span [ class "dashboard-option-text" ]
                        [ text (nbsp ++ nbsp ++ nbsp)
                        , text "/"
                        , text (nbsp ++ nbsp ++ nbsp)
                        , span [ id "dashboard-option-text2" ] [ text "dashboard" ]
                        ]
                    ]
                ]
            ]
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
                    , div [ class "range" ]
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
            , div [ class "buttons" ]
                [ if model.divvis.visible1 then
                    div [ class "button" ]
                        [ button [ class "btn btn-primary", id "b", onClick Types.ToggleDiv ] [ text "Next" ]
                        ]

                  else
                    div [ class "button" ]
                        [ button [ type_ "submit", class "btn btn-primary", id "b" ] [ text "Submit" ]
                        ]
                ]
            ]
        ]
