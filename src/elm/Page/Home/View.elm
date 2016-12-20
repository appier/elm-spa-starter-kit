module Page.Home.View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Common.Calendar.Month exposing (..)
import Common.Calendar.Model exposing (Month)


type alias Model =
    Month


model : Month
model =
    Common.Calendar.Month.model


type Msg
    = ClickDateMsg Common.Calendar.Month.Msg


update : Msg -> Model -> Model
update message model =
    case message of
        ClickDateMsg subMsg ->
            Common.Calendar.Month.update subMsg model


view : Model -> Html Msg
view model =
    div
        [ class "page", id "home" ]
        [ h1 [] [ text "home" ]
        , div []
            [ Html.map ClickDateMsg (Common.Calendar.Month.view model)
            ]
        ]
