module Types exposing (..)

import Browser
import Browser.Navigation as Nav
import Bytes exposing (Bytes)
import Http
import Json.Decode
import Json.Encode
import Url


type Route
    = HomeRoute
    | DashboardRoute
    | LoginRoute
    | RegisterRoute
    | NotFoundRoute


type alias Login =
    { email : String
    , password : String
    }


initLogin : () -> Login
initLogin () =
    { email = "", password = "" }


encodeLogin : Login -> Http.Body
encodeLogin l =
    Http.jsonBody <|
        Json.Encode.object
            [ ( "email", Json.Encode.string l.email )
            , ( "password", Json.Encode.string l.password )
            ]


type alias Register =
    { email : String
    , username : String
    , password : String
    }


initRegister : () -> Register
initRegister () =
    { email = "", password = "", username = "" }


encodeRegister : Register -> Http.Body
encodeRegister l =
    Http.jsonBody <|
        Json.Encode.object
            [ ( "email", Json.Encode.string l.email )
            , ( "username", Json.Encode.string l.username )
            , ( "password", Json.Encode.string l.password )
            ]


type alias User =
    { id : String
    , email : String
    , role : Int
    , username : String
    }


initUser : () -> Maybe User
initUser () =
    Nothing


encodeUser : User -> Http.Body
encodeUser l =
    Http.jsonBody <|
        Json.Encode.object
            [ ( "email", Json.Encode.string l.email )
            , ( "username", Json.Encode.string l.username )
            , ( "id", Json.Encode.string l.id )
            , ( "role", Json.Encode.int l.role )
            ]


decodeUser : Json.Decode.Decoder User
decodeUser =
    Json.Decode.map4 User
        (Json.Decode.field "id" Json.Decode.string)
        (Json.Decode.field "email" Json.Decode.string)
        (Json.Decode.field "role" Json.Decode.int)
        (Json.Decode.field "username" Json.Decode.string)


decodeUserList : Json.Decode.Decoder (List User)
decodeUserList =
    Json.Decode.list
        (Json.Decode.map4 User
            (Json.Decode.field "id" Json.Decode.string)
            (Json.Decode.field "email" Json.Decode.string)
            (Json.Decode.field "role" Json.Decode.int)
            (Json.Decode.field "username" Json.Decode.string)
        )


type alias DivVisibility =
    { visible1 : Bool
    , visible2 : Bool
    }


visibleController : () -> DivVisibility
visibleController () =
    { visible1 = True, visible2 = False }


type alias Playlist =
    { name : String
    , href : String
    , image : String
    , tracksHref : String
    , songCount : Int
    }


type alias SpotifyAuth =
    { access_token : String
    , token_type : String
    , expires_in : Int
    }


decodeSpotifyAuth : Json.Decode.Decoder SpotifyAuth
decodeSpotifyAuth =
    Json.Decode.map3 SpotifyAuth
        (Json.Decode.field "access_token" Json.Decode.string)
        (Json.Decode.field "token_type" Json.Decode.string)
        (Json.Decode.field "expires_in" Json.Decode.int)


type alias Tracks =
    { id : String
    , musicName : String
    , albumName : String
    , image : String
    , artistName : String
    }


decodeTracks : Json.Decode.Decoder (List Tracks)
decodeTracks =
    Json.Decode.at [ "items" ]
        (Json.Decode.list
            (Json.Decode.map5 Tracks
                (Json.Decode.at [ "track" ] (Json.Decode.field "href" Json.Decode.string))
                (Json.Decode.at [ "track" ] (Json.Decode.field "name" Json.Decode.string))
                (Json.Decode.at [ "track", "album" ] (Json.Decode.field "name" Json.Decode.string))
                (Json.Decode.at [ "track", "album", "images", "0" ] (Json.Decode.field "url" Json.Decode.string))
                (Json.Decode.at [ "track", "artists", "0" ] (Json.Decode.field "name" Json.Decode.string))
            )
        )



-- TODO put everything needed for playlist thats in the model inside a struct
-- TODO submit button actually requests api and shows the playlist in the middle of the screen
-- TODO dont let anyone submit anything if they dont have logged in
-- TODO start working on the other api requests and saving the links to the playlists created on the databas


type alias Model =
    { counter : Int
    , route : Route
    , key : Nav.Key
    , url : Url.Url
    , login : Login
    , register : Register
    , user : Maybe User
    , dashboardUsers : List User
    , token : String
    , mood : Int
    , divvis : DivVisibility
    , playlist : Maybe Playlist
    , tracks : Maybe (List Tracks)
    , access_token : String
    , client_id : String
    , client_secret : String
    , pdfBytes : Maybe Bytes
    }


type SpotifyRequest
    = PlayListSpotifyRequest
    | TracksSpotifyRequest


type Msg
    = LinkCliecked Browser.UrlRequest
    | UrlChanged Url.Url
    | LoginSubmit
    | LoginSubmitHttp (Result Http.Error ( User, String ))
    | LoginUpdate Login
    | RegisterUpdate Register
    | RegisterSubmit
    | RegisterSubmitHttp (Result Http.Error Json.Decode.Value)
    | DashboardUsersList (Result Http.Error (List User))
    | UpdateUser String
    | UpdateUserInput (List User)
    | UpdateUserSubmit (Result Http.Error ())
    | DeleteUser String
    | DeleteUserSubmit ( String, Result Http.Error () )
    | ToggleDiv
    | MoodUpdate Int
    | PlaylistSubmit
    | PlaylistRequest (Result Http.Error Playlist)
    | RefreshTokenRequest ( SpotifyRequest, Result Http.Error SpotifyAuth )
    | TracksRequest (Result Http.Error (List Tracks))
    | DownloadPdf
