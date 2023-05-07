port module Main exposing (init, main)

import Browser
import Browser.Navigation as Nav
import Html exposing (div, text)
import Login exposing (submitLogin)
import Mood exposing (mood)
import Types exposing (..)
import Url exposing (Protocol(..))
import Url.Parser exposing (s, top)


main : Program String Model Msg
main =
    Browser.application
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        , onUrlChange = UrlChanged
        , onUrlRequest = LinkCliecked
        }


init : String -> Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init flags url key =
    ( { counter = 0
      , url = url
      , key = key
      , route =
            Maybe.withDefault NotFoundRoute (Url.Parser.parse route url)
      , login = { email = "", password = "" }
      , user = Nothing
      , token = flags
      }
    , Cmd.none
    )


route : Url.Parser.Parser (Route -> a) a
route =
    Url.Parser.oneOf
        [ Url.Parser.map HomeRoute top
        , Url.Parser.map LoginRoute (s "login")
        , Url.Parser.map RegisterRoute (s "register")
        ]


port setStorage : String -> Cmd msg


port getStorage : (String -> msg) -> Sub msg


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
            let
                cmd =
                    Cmd.map (always msg) Cmd.none
            in
            case nextRoute of
                Just r ->
                    ( { model | url = url, route = r }
                    , cmd
                    )

                Nothing ->
                    ( { model | url = url, route = NotFoundRoute }
                    , cmd
                    )

        LoginUpdate l ->
            ( { model
                | login = l
              }
            , Cmd.none
            )

        LoginSubmit ->
            let
                s =
                    submitLogin model.login
            in
            ( model, s )

        LoginSubmitHttp (Ok ( user, token )) ->
            let
                cmds =
                    [ setStorage (Debug.log token token), Nav.pushUrl model.key "/" ]
            in
            -- Debug.log
            --     token
            ( { model | login = initLogin (), user = Just user }, Cmd.batch cmds )

        LoginSubmitHttp (Err _) ->
            ( model, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    case model.route of
        HomeRoute ->
            Sub.none

        RegisterRoute ->
            Sub.none

        LoginRoute ->
            Sub.none

        NotFoundRoute ->
            Sub.none


view : Model -> Browser.Document Msg
view model =
    { title = "Soundscapes"
    , body =
        [ case model.route of
            HomeRoute ->
                div []
                    [ mood model ]

            LoginRoute ->
                Login.login model

            RegisterRoute ->
                div [] [ text "register" ]

            NotFoundRoute ->
                div [] [ text "Not Found!" ]
        ]
    }
