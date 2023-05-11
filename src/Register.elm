module Register exposing (..)

import Html exposing (Html, div, form, input)
import Html.Attributes exposing (action, autocomplete, placeholder, type_)
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
    div []
        [ form [ action "javascript:void(0);", onSubmit RegisterSubmit ]
            [ input
                [ type_ "email"
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
            , input
                [ type_ "text"
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
            , input
                [ type_ "password"
                , autocomplete True
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
            , input [ type_ "submit" ] []
            ]
        ]
