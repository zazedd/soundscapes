module PlaylistApi exposing (..)

import Html exposing (..)
import Http
import Json.Decode as Json
import Types exposing (..)


playlistRequest : String -> Cmd Msg
playlistRequest mood =
    Http.request
        { method = "GET"
        , headers = []
        , url = "https://api.spotify.com/v1/search?q=" ++ mood ++ "&type=playlist&market=PT"
        , body = Http.emptyBody
        , expect = Http.expectJson PlaylistRequest playlistDecoder
        , timeout = Nothing
        , tracker = Nothing
        }


playlistDecoder : Json.Decoder Playlist
playlistDecoder =
    Json.at [ "playlists", "items", "0" ]
        (Json.map5 Playlist
            (Json.field "name" Json.string)
            (Json.field "href" Json.string)
            (Json.at [ "images" ] (Json.field "href" Json.string))
            (Json.at [ "tracks" ] (Json.field "href" Json.string))
            (Json.at [ "tracks" ] (Json.field "total" Json.int))
        )
