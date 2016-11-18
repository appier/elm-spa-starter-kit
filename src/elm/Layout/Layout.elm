module Layout.Layout exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)


layout : Html msg -> Html msg
layout children =
    div
        [ class "app-container" ]
        [ div
            [ class "navbar" ]
            [ text "Elm SPA Starter Kit" ]
        , div [ class "app-body" ]
            [ div [ class "side-bar" ]
                [ a [ class "link", href ("#/home") ] [ text "Home" ]
                , a [ class "link", href ("#/about") ] [ text "About" ]
                ]
            , children
            ]
        ]
