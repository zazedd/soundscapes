module Login exposing (..)

import Dict
import Html exposing (Html, button, div, form, h1, input, source, text, video)
import Html.Attributes exposing (action, autocomplete, autoplay, class, id, loop, name, placeholder, src, style, type_)
import Html.Events exposing (onInput, onSubmit)
import Http exposing (Error, Response(..))
import Json.Decode
import Types exposing (Login, Model, Msg(..), User, decodeUser, encodeLogin)
import Url exposing (Protocol(..))


readBodyToken : Http.Response String -> Result Error ( User, String )
readBodyToken resp =
    case resp of
        GoodStatus_ r body ->
            let
                token =
                    Maybe.withDefault
                        ""
                    <|
                        Dict.get "auth" r.headers
            in
            if String.length token == 0 then
                Err (Http.BadStatus 0)

            else
                let
                    u =
                        Json.Decode.decodeString decodeUser body
                in
                case u of
                    Ok user ->
                        Ok ( user, token )

                    Err _ ->
                        Err Http.NetworkError

        _ ->
            Err Http.NetworkError


submitLogin : Login -> Cmd.Cmd Msg
submitLogin l =
    Http.post
        { url = "http://localhost:3000/login"
        , body = encodeLogin l
        , expect = Http.expectStringResponse LoginSubmitHttp readBodyToken
        }


login : Model -> Html Msg
login model =
    div [ class "login" ]
        [ video [ autoplay True, loop True, id "bg-video" ] [ source [ src "/assets/waves.mp4", type_ "video/mp4" ] [] ]
        , form [ class "form", action "javascript:void(0);", onSubmit LoginSubmit, autocomplete False ]
            [ div [ class "control" ]
                [ h1 [] [ text "Login" ]
                ]
            , if model.errMsg /= "" then
                div [ style "margin-bottom" "25px", style "color" "red" ]
                    [ text model.errMsg
                    ]

              else
                div [] []
            , div [ class "control block-cube block-input" ]
                [ input
                    [ name "email"
                    , type_ "text"
                    , placeholder "Email"
                    , onInput
                        (\v ->
                            LoginUpdate
                                (let
                                    l =
                                        model.login
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
                    [ name "password"
                    , type_ "password"
                    , placeholder "Password"
                    , onInput
                        (\v ->
                            LoginUpdate
                                (let
                                    l =
                                        model.login
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



-- Http.request
-- { method = "POST"
-- , url = "http://localhost:3000/login"
-- , headers = []
-- , body = encodeLogin l
-- , expect =
--     Http.expectStringResponse
--         (\r ->
--             case r of
--                 Ok res ->
--                     let
--                         ll =
--                             String.split "|" res
--                     in
--                     case ll of
--                         t1 :: t2 :: _ ->
--                             let
--                                 body =
--                                     Json.Decode.decodeString decodeUser t1
--                             in
--                             case body of
--                                 Ok b ->
--                                     LoginSubmitHttp (Ok ( b, Debug.log t2 t2 ))
--
--                                 Err _ ->
--                                     LoginSubmitHttp (Err Http.NetworkError)
--
--                         t1 :: _ ->
--                             let
--                                 body =
--                                     Json.Decode.decodeString decodeUser t1
--                             in
--                             case body of
--                                 Ok b ->
--                                     LoginSubmitHttp (Ok ( b, "" ))
--
--                                 Err _ ->
--                                     LoginSubmitHttp (Err Http.NetworkError)
--
--                         _ ->
--                             LoginSubmitHttp (Err Http.NetworkError)
--
--                 Err e ->
--                     LoginSubmitHttp (Err e)
--         )
--         readBodyToken
-- , timeout = Nothing
-- , tracker = Nothing
-- }
--
-- (Http.post "http://localhost:3000/login" (encodeLogin l) decodeUser)
-- [ form [ action "javascript:void(0);", onSubmit LoginSubmit ]
--     [ input
--         [ type_ "email"
--         , onInput
--             (\v ->
--                 LoginUpdate
--                     (let
--                         l =
--                             model.login
--                      in
--                      { l | email = v }
--                     )
--             )
--         ]
--         []
--     , input
--         [ type_ "password"
--         , autocomplete True
--         , onInput
--             (\v ->
--                 LoginUpdate
--                     (let
--                         l =
--                             model.login
--                      in
--                      { l | password = v }
--                     )
--             )
--         ]
--         []
--     , input [ type_ "submit" ] []
--     ]
-- ]
