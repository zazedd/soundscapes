module HelloWorld exposing (helloWorld)

import Html exposing (Html, a, button, code, div, h1, p, text)
import Html.Attributes exposing (href)
import Html.Events exposing (onClick)
import Types exposing (..)


helloWorld : Model -> Html Msg
helloWorld model =
    div []
        [ h1 [] [ text "Soundscapes" ]
        , p []
            [ a [ href "https://vitejs.dev/guide/features.html" ] [ text "Vite Documentation" ]
            , text " | "
            , a [ href "/" ] [ text "Home" ]
            , text " | "
            , a [ href "https://guide.elm-lang.org/" ] [ text "Elm Documentation" ]
            , text " | "
            , a [ href "/login" ] [ text "Login!!" ]
            ]
        , button [ onClick Increment ] [ text "+" ]
        , text <| "Count is: " ++ String.fromInt model.counter
        , button [ onClick Decrement ] [ text "-" ]
        , p []
            [ text "Edit "
            , code [] [ text "src/Main.elm" ]
            , text " to test auto refresh"
            ]
        ]
