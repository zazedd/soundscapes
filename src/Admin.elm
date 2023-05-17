module Admin exposing (admin, getUsers)

import Html exposing (Html, div, p, table, text, th, tr)
import Http exposing (header)
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


tableUsers : List User -> List (Html.Html Msg)
tableUsers =
    List.map
        (\user ->
            tr []
                [ th [] [ text user.id ]
                , th [] [ text user.username ]
                , th [] [ text user.email ]
                , th [] [ text (user.role |> String.fromInt) ]
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
                    ]
                    :: tableUsers model.dashboardUsers
                )
            ]
        ]
