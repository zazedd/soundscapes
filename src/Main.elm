port module Main exposing (init, main)

import Admin
import Browser
import Browser.Navigation as Nav
import Html exposing (div, text)
import Login exposing (submitLogin)
import Mood exposing (mood)
import PlaylistApi exposing (..)
import Register exposing (submitRegister)
import Types exposing (..)
import Url exposing (Protocol(..))
import Url.Parser exposing (s, top)


type alias Flags =
    { token : String
    , user : Maybe User
    }


main : Program Flags Model Msg
main =
    Browser.application
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        , onUrlChange = UrlChanged
        , onUrlRequest = LinkCliecked
        }


init :
    Flags
    -> Url.Url
    -> Nav.Key
    -> ( Model, Cmd Msg )
init flags url key =
    let
        route_curr =
            Maybe.withDefault NotFoundRoute (Url.Parser.parse route url)
    in
    ( { counter = 0
      , url = url
      , key = key
      , route =
            route_curr
      , login = initLogin ()
      , register = initRegister ()
      , user = flags.user
      , dashboardUsers = []
      , token = flags.token
      , mood = -1
      , divvis = visibleController ()
      , playlist = Nothing
      }
    , case route_curr of
        DashboardRoute ->
            Cmd.batch [ Admin.getUsers flags.token ]

        _ ->
            Cmd.none
    )


route : Url.Parser.Parser (Route -> a) a
route =
    Url.Parser.oneOf
        [ Url.Parser.map HomeRoute top
        , Url.Parser.map DashboardRoute (s "admin")
        , Url.Parser.map LoginRoute (s "login")
        , Url.Parser.map RegisterRoute (s "register")
        ]


port setStorage : String -> Cmd msg


port getStorage : (String -> msg) -> Sub msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
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
                    case r of
                        DashboardRoute ->
                            ( { model | url = url, route = r }, Cmd.batch [ cmd, Admin.getUsers model.token ] )

                        _ ->
                            ( { model | url = url, route = r }, cmd )

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
                    [ setStorage token, Nav.pushUrl model.key "/" ]
            in
            -- Debug.log
            --     token
            ( { model | login = initLogin (), user = Just user, token = token }, Cmd.batch cmds )

        LoginSubmitHttp (Err _) ->
            ( model, Cmd.none )

        RegisterUpdate r ->
            ( { model | register = r }, Cmd.none )

        RegisterSubmit ->
            ( model, submitRegister model.register )

        RegisterSubmitHttp (Ok _) ->
            let
                cmds =
                    Nav.pushUrl model.key "/login"
            in
            ( model, cmds )

        RegisterSubmitHttp (Err _) ->
            ( model, Cmd.none )

        DashboardUsersList r ->
            case r of
                Ok lu ->
                    ( { model | dashboardUsers = lu }, Cmd.none )

                Err _ ->
                    ( model, Cmd.none )

        UpdateUser id ->
            let
                user =
                    List.filter (\a -> a.id == id) model.dashboardUsers |> List.head
            in
            case user of
                Nothing ->
                    ( model, Cmd.none )

                Just uu ->
                    ( model, Admin.updateUser uu model.token )

        UpdateUserInput users ->
            ( { model | dashboardUsers = users }, Cmd.none )

        UpdateUserSubmit (Ok _) ->
            ( model, Admin.getUsers model.token )

        UpdateUserSubmit (Err _) ->
            ( model, Cmd.none )

        DeleteUser user_id ->
            ( model, Cmd.batch [ Admin.deleteUser user_id model.token ] )

        DeleteUserSubmit ( id, Ok _ ) ->
            ( { model | dashboardUsers = List.filter (\uu -> uu.id /= id) model.dashboardUsers }, Cmd.none )

        DeleteUserSubmit ( _, Err _ ) ->
            ( model, Cmd.none )

        ToggleDiv ->
            ( { model | divvis = { visible1 = not model.divvis.visible1, visible2 = not model.divvis.visible2 } }, Cmd.none )

        MoodUpdate m ->
            ( { model
                | mood = m
              }
            , Cmd.none
            )

        PlaylistSubmit ->
            ( model, playlistRequest model.mood )

        PlaylistRequest (Ok playlist_response) ->
            ( { model | playlist = Just playlist_response }, Cmd.none )

        PlaylistRequest (Err _) ->
            ( model, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


view : Model -> Browser.Document Msg
view model =
    { title = "Soundscapes"
    , body =
        [ case model.route of
            HomeRoute ->
                mood model

            DashboardRoute ->
                let
                    not_found =
                        div [] [ text "Not Found!" ]
                in
                case model.user of
                    Nothing ->
                        not_found

                    Just user ->
                        if user.role == 1 then
                            Admin.admin model

                        else
                            not_found

            LoginRoute ->
                Login.login model

            RegisterRoute ->
                Register.register model

            NotFoundRoute ->
                div [] [ text "Not Found!" ]
        ]
    }
