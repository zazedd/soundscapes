module PlaylistApi exposing (..)

import Html exposing (..)
import Http
import Json.Decode as Json
import Types exposing (..)


playlistRequest : String -> Int -> Cmd Msg
playlistRequest access_token mood =
    Http.request
        { method = "GET"
        , headers =
            [ Http.header "Authorization"
                ("Bearer "
                    ++ access_token
                )
            ]
        , url = "https://api.spotify.com/v1/search?q=" ++ (mood |> String.fromInt) ++ "&type=playlist&market=PT&limit=30"
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
            (Json.at [ "images", "0" ] (Json.field "url" Json.string))
            (Json.at [ "tracks" ] (Json.field "href" Json.string))
            (Json.at [ "tracks" ] (Json.field "total" Json.int))
        )


tracksRequest : String -> String -> Cmd Msg
tracksRequest access_token href =
    Http.request
        { method = "GET"
        , headers =
            [ Http.header "Authorization"
                ("Bearer "
                    ++ access_token
                )
            ]
        , url = href
        , body = Http.emptyBody
        , expect = Http.expectJson TracksRequest decodeTracks
        , timeout = Nothing
        , tracker = Nothing
        }


refreshTokenRequest : SpotifyRequest -> String -> String -> Cmd Msg
refreshTokenRequest spoty client_id client_secret =
    Http.request
        { method = "POST"
        , headers =
            []
        , url = "https://accounts.spotify.com/api/token"
        , body = Http.stringBody "application/x-www-form-urlencoded" ("grant_type=client_credentials&client_id=" ++ client_id ++ "&client_secret=" ++ client_secret)
        , expect = Http.expectJson (\a -> RefreshTokenRequest ( spoty, a )) decodeSpotifyAuth
        , timeout = Nothing
        , tracker = Nothing
        }