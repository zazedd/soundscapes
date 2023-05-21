module PlaylistApi exposing (..)

import Html exposing (..)
import Http
import Json.Decode as Json
import Random
import Types exposing (..)


moodSwitch : Int -> String
moodSwitch mood =
    case mood of
        1 ->
            "Very+Sad"

        2 ->
            "Sad"

        3 ->
            ""

        4 ->
            "Happy"

        5 ->
            "Very+Happy"

        _ ->
            ""


playlistRequest : Model -> String -> Int -> String -> Cmd Msg
playlistRequest model access_token mood genre =
    Http.request
        { method = "GET"
        , headers =
            [ Http.header "Authorization"
                ("Bearer "
                    ++ access_token
                )
            ]
        , url = "https://api.spotify.com/v1/search?q=" ++ (mood |> moodSwitch) ++ ("+" ++ genre) ++ "&type=playlist&market=PT&limit=30"
        , body = Http.emptyBody
        , expect = Http.expectJson PlaylistRequest (playlistDecoder model)
        , timeout = Nothing
        , tracker = Nothing
        }


playlistDecoder : Model -> Json.Decoder Playlist
playlistDecoder model =
    Json.at [ "playlists", "items", model.randomInt |> String.fromInt ]
        (Json.map5 Playlist
            (Json.field "name" Json.string)
            (Json.field "id" Json.string)
            (Json.maybe (Json.at [ "images", "0" ] (Json.field "url" Json.string)))
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


playlistRequestName : Model -> String -> String -> Cmd Msg
playlistRequestName model access_token name =
    Http.request
        { method = "GET"
        , headers =
            [ Http.header "Authorization"
                ("Bearer "
                    ++ access_token
                )
            ]
        , url = "https://api.spotify.com/v1/search?q=" ++ name ++ "&type=playlist&market=PT&limit=30"
        , body = Http.emptyBody
        , expect = Http.expectJson PlaylistRequest (playlistDecoder model)
        , timeout = Nothing
        , tracker = Nothing
        }
