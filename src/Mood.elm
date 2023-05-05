module Mood exposing (mood)

import Exts.Html exposing (nbsp)
import Html exposing (Html, a, div, h1, hr, img, input, label, p, source, span, text, video)
import Html.Attributes exposing (autoplay, class, for, href, id, loop, src, step, style, type_)
import Html.Events exposing (onClick)
import Msg exposing (Msg(..))
import VitePluginHelper


mood : Int -> Html Msg
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
                        , span [ id "dashboard-option-text2" ] [ text "dashboard based" ]
                        ]
                    ]
                ]
            ]
        , div [ class "main-content" ]
            [ h1 [ id "title" ] [ text "soundscapes" ]
            , div [ class "center-content" ]
                [ p [] [ text "How are you feeling?" ]
                , div [ class "range" ]
                    [ div [ class "label-left" ]
                        [ label [ for "emotionalRange", class "form-label" ]
                            [ span [ class "material-symbols-outlined" ] [ text "sentiment_dissatisfied" ]
                            ]
                        ]
                    , input [ type_ "range", class "form-group", Html.Attributes.min "0", Html.Attributes.max "5", step "0.5", id "emotionalRange" ] []
                    , div [ class "label-right" ]
                        [ label [ for "emotionalRange", class "form-label" ]
                            [ span [ class "material-symbols-outlined" ] [ text "sentiment_excited" ]
                            ]
                        ]
                    ]
                ]
            ]
        ]
