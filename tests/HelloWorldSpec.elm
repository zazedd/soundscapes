module HelloWorldSpec exposing (suite)

import Mood exposing (mood)
import Test exposing (Test)
import Test.Html.Event as Event
import Test.Html.Query as Query
import Test.Html.Selector as Html
import Types exposing (..)


suite : Test
suite =
    Test.describe "HelloWorld"
        [ Test.test "renders and runs helloWorld" <|
            \_ ->
                mood
                    |> Query.fromHtml
                    |> Query.has [ Html.text "Hello, Vite + Elm!" ]
        , Test.test "Displays the current count" <|
            \_ ->
                mood
                    |> Query.fromHtml
                    |> Query.has [ Html.text "Count is: 5" ]
        , Test.test "clicking on the + button sends an increment message" <|
            \_ ->
                mood
                    |> Query.fromHtml
                    |> Query.find [ Html.tag "button", Html.containing [ Html.text "+" ] ]
                    |> Event.simulate Event.click
                    |> Event.expect Increment
        , Test.test "clicking on the - button sends a decrement message" <|
            \_ ->
                mood
                    |> Query.fromHtml
                    |> Query.find [ Html.tag "button", Html.containing [ Html.text "-" ] ]
                    |> Event.simulate Event.click
                    |> Event.expect Decrement
        ]
