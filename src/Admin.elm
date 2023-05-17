module Admin exposing (..)

import Html exposing (Html, button, div, p, table, text, th, tr)
import Html.Events exposing (onClick)
import Http exposing (emptyBody, header)
import Types exposing (Model, Msg(..), User, decodeUserList)


getUsers : String -> Cmd.Cmd Msg
getUsers token =
    Http.request
        { url = "http://localhost:3000/admin/users"
        , method = "GET"
        , headers = [ header "auth" token ]
        , body = Http.emptyBody
        , expect = Http.expectJson DashboardUsersList decodeUserList
        , timeout = Nothing
        , tracker = Nothing
        }


updateUser : User -> String -> Cmd.Cmd Msg
updateUser user token =
    Http.request
        { url = "http://localhost:3000/admin/users/" ++ user.id
        , method = "PUT"
        , headers = [ header "auth" token ]
        , body = Types.encodeUser user
        , expect = Http.expectWhatever UpdateUserSubmit
        , timeout = Nothing
        , tracker = Nothing
        }


deleteUser : String -> String -> Cmd.Cmd Msg
deleteUser id token =
    Http.request
        { url = "http://localhost:3000/admin/users/" ++ id
        , method = "DELETE"
        , headers = [ header "auth" token ]
        , body = emptyBody
        , expect = Http.expectWhatever (\a -> DeleteUserSubmit ( id, a ))
        , timeout = Nothing
        , tracker = Nothing
        }


tableUsers : String -> List User -> List (Html.Html Msg)
tableUsers token =
    List.map
        (\user ->
            tr []
                [ th [] [ text user.id ]
                , th [] [ text user.username ]
                , th [] [ text user.email ]
                , th [] [ text (user.role |> String.fromInt) ]
                , th [] [ button [ onClick (DeleteUser ( user.id, token )) ] [ text ("Delete " ++ user.username) ] ]
                ]
        )


admin : Model -> Html Msg
admin model =
    div []
        [ p []
            [ text "Admin dashboard" ]
        , div
            []
            [ table []
                (tr []
                    [ th [] [ text "Id" ]
                    , th [] [ text "Username" ]
                    , th [] [ text "Email" ]
                    , th [] [ text "Role" ]
                    , th [] [ text "Delete" ]
                    ]
                    :: tableUsers model.token model.dashboardUsers
                )
            ]
        ]
