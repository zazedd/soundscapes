module Common exposing (..)

import Html exposing (Html, a, div, hr, img, span, text)
import Html.Attributes exposing (class, href, id, src, style)
import Types exposing (Model, Msg)
import VitePluginHelper


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
            [ a [ href "#" ]
                [ span [ class "material-symbols-outlined" ] [ text "emoticon" ]
                , span [ class "sidebar-option-text" ]
                    [ text (nbsp ++ nbsp ++ nbsp)
                    , text "/"
                    , text (nbsp ++ nbsp ++ nbsp)
                    , span [ id "sidebar-option-text2" ] [ text "mood based" ]
                    ]
                ]
            , a [ href "#" ]
                [ span [ class "material-symbols-outlined" ]
                    [ text "music_note" ]
                , span [ class "sidebar-option-text" ]
                    [ text (nbsp ++ nbsp ++ nbsp)
                    , text "/"
                    , text (nbsp ++ nbsp ++ nbsp)
                    , span [ id "sidebar-option-text2" ] [ text "song based" ]
                    ]
                ]
            , a [ href "#" ]
                [ span [ class "material-symbols-outlined" ]
                    [ text "calendar_month" ]
                , span [ class "sidebar-option-text" ]
                    [ text (nbsp ++ nbsp ++ nbsp)
                    , text "/"
                    , text (nbsp ++ nbsp ++ nbsp)
                    , span [ id "sidebar-option-text2" ] [ text "year based" ]
                    ]
                ]
            , a [ href "#" ]
                [ span [ class "material-symbols-outlined" ]
                    [ text "dashboard" ]
                , span [ class "sidebar-option-text" ]
                    [ text (nbsp ++ nbsp ++ nbsp)
                    , text "/"
                    , text (nbsp ++ nbsp ++ nbsp)
                    , span [ id "sidebar-option-text2" ] [ text "dashboard" ]
                    ]
                ]
            ]
        , user_login model
        ]
