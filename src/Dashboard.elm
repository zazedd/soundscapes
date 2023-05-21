module Dashboard exposing (..)

import Common exposing (sidebar)
import Html exposing (Html, a, button, div, p, table, tbody, td, text, th, thead, tr)
import Html.Attributes exposing (class, href, id, style)
import Html.Events exposing (onClick)
import Http
import Types exposing (Model, Msg(..), PlaylistStored, decodePlaylistsStoredList)


get_playlists : String -> Cmd Msg
get_playlists token =
    Http.request
        { url = "http://localhost:3000/playlists"
        , method = "GET"
        , headers = [ Http.header "auth" token ]
        , body = Http.emptyBody
        , expect = Http.expectJson PlaylistStoredRequest decodePlaylistsStoredList
        , timeout = Nothing
        , tracker = Nothing
        }


delete_playlist : String -> String -> Cmd Msg
delete_playlist id token =
    Http.request
        { url = "http://localhost:3000/playlists/" ++ id
        , method = "DELETE"
        , headers = [ Http.header "auth" token ]
        , body = Http.emptyBody
        , expect = Http.expectWhatever (\a -> PlaylistStoredRequestDelete ( id, a ))
        , timeout = Nothing
        , tracker = Nothing
        }


playlists : List PlaylistStored -> List (Html Msg)
playlists =
    List.map
        (\playlist ->
            tr [ class "table-dark" ]
                [ -- td [ class "table-dark" ] [ text playlist.id ]
                  td [ class "table-dark" ]
                    [ text playlist.name ]
                , td [ class "table-dark" ]
                    [ a [ href ("https://open.spotify.com/playlist/" ++ playlist.id) ] [ text "Link" ]
                    ]

                -- , th [ class "table-dark" ]
                --     [ text playlist.user_id ]
                -- , td [ class "table-dark" ] [ button [ class "btn btn-primary", onClick (UpdateUser user.id) ] [ text "Update" ] ]
                , td [ class "table-dark" ] [ button [ class "btn btn-primary", onClick (DeletePlaylist playlist.id) ] [ text "Delete" ] ]
                ]
        )


dashboard : Model -> Html Msg
dashboard model =
    div []
        [ sidebar model
        , div [ class "dashboard-content" ]
            (case model.user of
                Nothing ->
                    [ div [ class "center-content" ] [ text "Please login first!" ]
                    ]

                Just _ ->
                    [ p [ id "admintitle" ]
                        [ text "Dashboard" ]
                    , div
                        [ class "admin-content" ]
                        [ div
                            [ style "display" "flex"
                            , style "justify-content" "center"
                            , style "align-items"
                                "center"
                            , style
                                "width"
                                "100%"
                            , style "margin" "15px"
                            ]
                            [ p [ style "margin" "0" ] [ text "These are your playlists" ]
                            ]
                        , table [ class "table" ]
                            [ thead [ style "margin-bottom" "100px" ]
                                [ tr []
                                    [ -- th [ class "table-dark" ] [ text "Id" ]
                                      th [ class "table-dark" ] [ text "Name" ]
                                    , th [ class "table-dark" ] [ text "Url" ]

                                    -- , th [ class "table-dark" ] [ text "User Id" ]
                                    , th [ class "table-dark" ] [ text "Delete" ]
                                    ]
                                ]
                            , tbody [] (playlists model.playlistsStored)
                            ]
                        ]
                    ]
            )
        ]
