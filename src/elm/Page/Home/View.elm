module Page.Home.View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Common.Calendar.Month exposing (..)


type alias Model =
    Common.Calendar.Month.Model


model : Model
model =
    Common.Calendar.Month.model


type Msg
    = ClickDateMsg Common.Calendar.Month.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update message model =
    case message of
        ClickDateMsg subMsg ->
            let
                ( newModel, newMsg ) =
                    Common.Calendar.Month.update subMsg model
            in
                ( newModel, Cmd.map ClickDateMsg newMsg )


view : Model -> Html Msg
view model =
    div
        [ class "page", id "home" ]
        [ h1 [] [ text "home" ]
        , div []
            [ Html.map ClickDateMsg (Common.Calendar.Month.view model)
            ]
        ]
