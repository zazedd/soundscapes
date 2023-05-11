module Common exposing (sidebar)

import Html exposing (Html, a, div, hr, img, span, text)
import Html.Attributes exposing (class, href, id, src, style)
import Types exposing (Msg)
import VitePluginHelper


nbsp : String
nbsp =
    Char.fromCode 0xA0 |> String.fromChar


sidebar : Html Msg
sidebar =
    div [ class "dashboard" ]
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
        , div [ class "dashboard-user" ] []
        ]
