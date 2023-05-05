module Main exposing (init, main)

import Browser
import Browser.Navigation as Nav
import Html exposing (div, img, text)
import Html.Attributes exposing (src, style)
import Login
import Mood exposing (mood)
import Types exposing (..)
import Url
import Url.Parser exposing (s, top)


main : Program () Model Msg
main =
    Browser.application
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        , onUrlChange = UrlChanged
        , onUrlRequest = LinkCliecked
        }


init : () -> Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init _ url key =
    ( { counter = 0, url = url, key = key, route = Home }, Cmd.none )


route : Url.Parser.Parser (Route -> a) a
route =
    Url.Parser.oneOf
        [ Url.Parser.map Home top
        , Url.Parser.map Login (s "login")
        , Url.Parser.map Register (s "register")
        ]


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Increment ->
            ( { model | counter = model.counter + 1 }, Cmd.none )

        Decrement ->
            ( { model | counter = model.counter - 1 }, Cmd.none )

        LinkCliecked urlRequest ->
            case urlRequest of
                Browser.Internal url ->
                    ( model, Nav.pushUrl model.key (Url.toString url) )

                Browser.External href ->
                    ( model, Nav.load href )

        UrlChanged url ->
            let
                nextRoute =
                    Url.Parser.parse route url
            in
            case nextRoute of
                Just r ->
                    ( { model | url = url, route = r }
                    , Cmd.none
                    )

                Nothing ->
                    ( { model | url = url, route = NotFound }
                    , Cmd.none
                    )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


view : Model -> Browser.Document Msg
view model =
    { title = "Soundscapes"
    , body =
        [ case model.route of
            Home ->
                div []
                    [ mood model ]

            Login ->
                Login.login model

            Register ->
                Login.login model

            NotFound ->
                div [] [ text "Not Found!" ]
        ]
    }
