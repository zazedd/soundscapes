module Name exposing (name)

import Common exposing (..)
import Html exposing (Html, button, div, h1, input, p, source, text, video)
import Html.Attributes exposing (autoplay, class, classList, disabled, id, loop, src, style, type_)
import Html.Attributes.Aria exposing (ariaLabel)
import Html.Events exposing (onClick, onInput)
import Types exposing (Model, Msg(..))



nameSelector : Model -> List (Html Msg)
nameSelector model =
    [ div [ classList [ ( "select-div", True ), ( "visible", model.divvis.visible1 ) ] ]
        [ p [ style "margin-bottom" "55px"] [ text "What name would you like to search for?" ]
        , div [ class "mb-3" ]
            [ input
                [ class "form-control"
                , ariaLabel "Input the name"
                , id "genreInput"
                , disabled (not model.divvis.visible1)
                , onInput
                    (\v ->
                        NameUpdate v
                    )
                ] []
            ]
        ]
    , div [ class "form", style "margin-top" "-30px", style "margin-bottom" "auto", style "width" "150px" ]
         [ div [ class "button" ]
                [ button [ onClick PlaylistSubmitName, type_ "submit", class "btn block-cube block-cube-hover", id "b" ]
                    [ div [ class "bg-top" ]
                        [ div [ class "bg-inner" ] [] ]
                    , div [ class "bg-right" ]
                        [ div [ class "bg-inner" ] [] ]
                    , div [ class "bg" ]
                        [ div [ class "bg-inner" ] [] ]
                    , div [ class "text" ] [ text "Submit" ]
                    ]
                ]
        ]
    ]


name : Model -> Html Msg
name model =
    div []
        [ video [ autoplay True, loop True, id "bg-video" ] [ source [ src "/assets/waves.mp4", type_ "video/mp4" ] [] ]
        , sidebar model
        , div [ class "main-content" ]
            [ h1 [ id "title" ]
                [ text "soundscapes" ]
            , if model.divvis.visible1 || model.divvis.visible2 then
                div [ class "center-content" ] (nameSelector model)

              else
                div [ class "playlist" ] (playlistShow model)
            ]
        ]
