module Types exposing (..)

import Browser
import Browser.Navigation as Nav
import Url


type Route
    = Home
    | Login
    | Register
    | NotFound


type alias Model =
    { counter : Int
    , route : Route
    , key : Nav.Key
    , url : Url.Url
    }


type Msg
    = Increment
    | Decrement
    | LinkCliecked Browser.UrlRequest
    | UrlChanged Url.Url
