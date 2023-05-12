module Register exposing (..)

import Html exposing (Html, button, div, form, h1, input, source, text, video)
import Html.Attributes exposing (action, autocomplete, autoplay, class, id, loop, name, placeholder, src, type_)
import Html.Events exposing (onInput, onSubmit)
import Http
import Json.Decode
import Types exposing (Model, Msg(..), Register, encodeRegister)


submitRegister : Register -> Cmd.Cmd Msg
submitRegister r =
    Http.post
        { url = "http://localhost:3000/register"
        , body = encodeRegister r
        , expect = Http.expectJson RegisterSubmitHttp Json.Decode.value
        }


register : Model -> Html Msg
register model =
    div [ class "login" ]
        [ video [ autoplay True, loop True, id "bg-video" ] [ source [ src "/assets/waves.mp4", type_ "video/mp4" ] [] ]
        , form [ class "form", action "javascript:void(0);", onSubmit LoginSubmit, autocomplete False ]
            [ div [ class "control" ]
                [ h1 [] [ text "Register" ]
                ]
            , div [ class "control block-cube block-input" ]
                [ input
                    [ name "email"
                    , type_ "text"
                    , placeholder "Email"
                    , onInput
                        (\v ->
                            RegisterUpdate
                                (let
                                    l =
                                        model.register
                                 in
                                 { l | email = v }
                                )
                        )
                    ]
                    []
                , div [ class "bg-top" ]
                    [ div [ class "bg-inner" ] [] ]
                , div [ class "bg-right" ]
                    [ div [ class "bg-inner" ] [] ]
                , div [ class "bg" ]
                    [ div [ class "bg-inner" ] [] ]
                ]
            , div [ class "control block-cube block-input" ]
                [ input
                    [ name "username"
                    , type_ "username"
                    , placeholder "Username"
                    , onInput
                        (\v ->
                            RegisterUpdate
                                (let
                                    l =
                                        model.register
                                 in
                                 { l | username = v }
                                )
                        )
                    ]
                    []
                , div [ class "bg-top" ]
                    [ div [ class "bg-inner" ] [] ]
                , div [ class "bg-right" ]
                    [ div [ class "bg-inner" ] [] ]
                , div [ class "bg" ]
                    [ div [ class "bg-inner" ] [] ]
                ]
            , div [ class "control block-cube block-input" ]
                [ input
                    [ name "password"
                    , type_ "password"
                    , placeholder "Password"
                    , onInput
                        (\v ->
                            RegisterUpdate
                                (let
                                    l =
                                        model.register
                                 in
                                 { l | password = v }
                                )
                        )
                    ]
                    []
                , div [ class "bg-top" ]
                    [ div [ class "bg-inner" ] [] ]
                , div [ class "bg-right" ]
                    [ div [ class "bg-inner" ] [] ]
                , div [ class "bg" ]
                    [ div [ class "bg-inner" ] [] ]
                ]
            , button [ class "btn block-cube block-cube-hover", type_ "submit" ]
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



-- div []
--     [ form [ action "javascript:void(0);", onSubmit RegisterSubmit ]
--         [ input
--             [ type_ "email"
--             , placeholder "Email"
--             , onInput
--                 (\v ->
--                     RegisterUpdate
--                         (let
--                             l =
--                                 model.register
--                          in
--                          { l | email = v }
--                         )
--                 )
--             ]
--             []
--         , input
--             [ type_ "text"
--             , placeholder "Username"
--             , onInput
--                 (\v ->
--                     RegisterUpdate
--                         (let
--                             l =
--                                 model.register
--                          in
--                          { l | username = v }
--                         )
--                 )
--             ]
--             []
--         , input
--             [ type_ "password"
--             , autocomplete True
--             , placeholder "Password"
--             , onInput
--                 (\v ->
--                     RegisterUpdate
--                         (let
--                             l =
--                                 model.register
--                          in
--                          { l | password = v }
--                         )
--                 )
--             ]
--             []
--         , input [ type_ "submit" ] []
--         ]
--     ]
