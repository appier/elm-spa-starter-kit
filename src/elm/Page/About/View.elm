module Page.About.View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)


type Model
    = None


type Msg
    = NoOp


view : Model -> Html Msg
view model =
    div
        [ class "page", id "about" ]
        [ h1 [] [ text "about" ]
        ]
