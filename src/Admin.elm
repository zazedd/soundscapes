module Admin exposing (..)

import Common exposing (sidebar)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)
import Http exposing (emptyBody, header)
import Types exposing (Model, Msg(..), User, decodeUserList)


getUsers : String -> Cmd.Cmd Msg
getUsers token =
    Http.request
        { url = "http://localhost:3000/admin/users"
        , method = "GET"
        , headers = [ Http.header "auth" token ]
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
        , headers = [ Http.header "auth" token ]
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
        , headers = [ Http.header "auth" token ]
        , body = emptyBody
        , expect = Http.expectWhatever (\a -> DeleteUserSubmit ( id, a ))
        , timeout = Nothing
        , tracker = Nothing
        }


tableUsers : List User -> List (Html.Html Msg)
tableUsers users =
    List.map
        (\user ->
            tr [ class "table-dark" ]
                [ td [ class "table-dark" ] [ text user.id ]
                , td [ class "table-dark" ]
                    [ input
                        [ class "form-control"
                        , value user.username
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
                , td [ class "table-dark" ]
                    [ input
                        [ class "form-control"
                        , value user.email
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
                , th [ class "table-dark" ]
                    [ input
                        [ class "form-control"
                        , value (user.role |> String.fromInt)
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
                , td [ class "table-dark" ] [ button [ class "btn btn-primary", onClick (UpdateUser user.id) ] [ text "Update" ] ]
                , td [ class "table-dark" ] [ button [ class "btn btn-primary", onClick (DeleteUser user.id) ] [ text "Delete" ] ]
                ]
        )
        users


admin : Model -> Html Msg
admin model =
    div [ class "admin-content" ]
        [ sidebar model
        , p [ id "admintitle" ]
            [ text "Admin dashboard" ]
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
                [ p [ style "margin" "0" ] [ text "Admins can change or delete users" ]
                , button [ onClick DownloadPdf, style "margin-left" "10px" ] [ text "export Pdf" ]
                ]
            , table [ class "table" ]
                [ thead [ style "margin-bottom" "100px" ]
                    [ tr []
                        [ th [ class "table-dark" ] [ text "Id" ]
                        , th [ class "table-dark" ] [ text "Username" ]
                        , th [ class "table-dark" ] [ text "Email" ]
                        , th [ class "table-dark" ] [ text "Role" ]
                        , th [ class "table-dark" ] [ text "Update" ]
                        , th [ class "table-dark" ] [ text "Delete" ]
                        ]
                    ]
                , tbody [] (tableUsers model.dashboardUsers)
                ]
            ]
        ]
