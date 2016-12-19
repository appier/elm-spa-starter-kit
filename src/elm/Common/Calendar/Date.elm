module Common.Calendar.Date exposing (..)

import Date exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Common.Calendar.Model exposing (CalendarDate)


type Model
    = CalendarDate


type Msg
    = OnClick



-- onClick OnClick model.date


update : Msg -> CalendarDate -> CalendarDate
update message model =
    case message of
        OnClick ->
            if model.isAvailable then
                { model | isSelected = True }
            else
                model


getDateDomClassName : CalendarDate -> String
getDateDomClassName model =
    let
        selectedClassName =
            if model.isSelected then
                " selected"
            else
                ""

        availableClassName =
            if model.isAvailable then
                " available"
            else
                ""

        inMonthClassName =
            if model.isInMonthRange then
                " in-month"
            else
                ""
    in
        "cal-date" ++ selectedClassName ++ availableClassName ++ inMonthClassName


view : CalendarDate -> Html Msg
view model =
    let
        className =
            getDateDomClassName (model)
    in
        div
            [ class className, onClick OnClick ]
            [ text (toString (Date.day (model.date))), text (toString model.isSelected) ]
