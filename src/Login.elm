module Login exposing (..)

import Html exposing (Html, div, text)
import Types exposing (Model, Msg)


login : Model -> Html Msg
login model =
    div [] [ text "Hello Login!" ]
