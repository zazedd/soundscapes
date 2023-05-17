module Admin exposing (..)

import Html exposing (Html, button, div, input, p, table, text, th, tr)
import Html.Attributes exposing (type_, value)
import Html.Events exposing (onClick, onInput)
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


tableUsers : List User -> List (Html.Html Msg)
tableUsers users =
    List.map
        (\user ->
            tr []
                [ th [] [ text user.id ]
                , th []
                    [ input
                        [ value user.username
                        , type_ "text"
                        , onInput
                            (\username ->
                                UpdateUserInput
                                    (List.map
                                        (\u ->
                                            if u.id == user.id then
                                                { u | username = username }

                                            else
                                                u
                                        )
                                        users
                                    )
                            )
                        ]
                        []
                    ]
                , th []
                    [ input
                        [ value user.email
                        , type_ "email"
                        , onInput
                            (\email ->
                                UpdateUserInput
                                    (List.map
                                        (\u ->
                                            if u.id == user.id then
                                                { u | email = email }

                                            else
                                                u
                                        )
                                        users
                                    )
                            )
                        ]
                        []
                    ]
                , th []
                    [ input
                        [ value (user.role |> String.fromInt)
                        , type_ "number"
                        , onInput
                            (\role ->
                                UpdateUserInput
                                    (List.map
                                        (\u ->
                                            if u.id == user.id then
                                                { u | role = Maybe.withDefault 2 (String.toInt role) }

                                            else
                                                u
                                        )
                                        users
                                    )
                            )
                        ]
                        []
                    ]
                , th [] [ button [ onClick (UpdateUser user.id) ] [ text "Update" ] ]
                , th [] [ button [ onClick (DeleteUser user.id) ] [ text "Delete" ] ]
                ]
        )
        users


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
                    :: tableUsers model.dashboardUsers
                )
            ]
        ]
