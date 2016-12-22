module Common.Calendar.Date exposing (..)

import Char exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Common.Calendar.Model exposing (CalendarDate)
import Time.Date exposing (Date, day)


type alias Model =
    CalendarDate


type Msg
    = OnClick


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


toRadix : Int -> Int -> String
toRadix r n =
    let
        getChr c =
            if c < 10 then
                toString c
            else
                String.fromChar <| Char.fromCode (87 + c)

        getStr b =
            if n < b then
                getChr n
            else
                (toRadix r (n // b)) ++ (getChr (n % b))
    in
        case (r >= 2 && r <= 16) of
            True ->
                getStr r

            False ->
                toString n


getDateBackgroundColor : Int -> String
getDateBackgroundColor dateInt =
    let
        hex =
            (toRadix 16 (255 - dateInt))
    in
        "#" ++ hex ++ hex ++ hex


view : CalendarDate -> Html Msg
view model =
    let
        className =
            getDateDomClassName (model)

        dateNumber =
            day model.date
    in
        div
            [ class className
            , style [ ( "backgroundColor", getDateBackgroundColor dateNumber ) ]
            , onClick
                OnClick
            ]
            [ div [ class "cal-text" ]
                [ text (toString dateNumber) ]
            ]
