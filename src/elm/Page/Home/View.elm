module Page.Home.View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Common.Calendar.Week exposing (..)
import Common.Calendar.Model exposing (CalendarDate)


type alias Model =
    List CalendarDate


model : List CalendarDate
model =
    Common.Calendar.Week.model


type Msg
    = ClickDateMsg Common.Calendar.Week.Msg


update : Msg -> Model -> Model
update message model =
    case message of
        ClickDateMsg subMsg ->
            Common.Calendar.Week.update subMsg model


view : Model -> Html Msg
view model =
    div
        [ class "page", id "home" ]
        [ h1 [] [ text "home" ]
        , div []
            [ Html.map ClickDateMsg (Common.Calendar.Week.view model)
            ]
        ]
