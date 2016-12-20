module Common.Calendar.Month exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Common.Calendar.Date exposing (..)
import Common.Calendar.Model exposing (Month, Week, CalendarDate, dayFromSunDay, getWeekDayStr, weekDays)
import Time.Date exposing (Date, Weekday, date, addMonths, addDays, weekday, daysInMonth)


type alias Model =
    Month


createCalendarDateByDate : Date -> CalendarDate
createCalendarDateByDate date =
    { date = date
    , isHoliday = False
    , isAvailable = True
    , isSelected = False
    , isToday = False
    , isInMonthRange = True
    }


generateWeekListByDate : Date -> Week
generateWeekListByDate date =
    List.map
        (\x ->
            x
                |> flip addDays date
                |> createCalendarDateByDate
        )
        (List.range 0 6)


getFirstDateOfWeek : Date -> Date
getFirstDateOfWeek date =
    let
        weekDay =
            weekday date

        adjustDay =
            -1 * dayFromSunDay weekDay
    in
        addDays adjustDay date


getWeekNumByByYearAndMonth : Int -> Int -> Int
getWeekNumByByYearAndMonth year month =
    let
        firstDateOfMonth =
            date year month 1

        days =
            daysInMonth year month
    in
        case days of
            Just num ->
                ceiling (toFloat (num + (dayFromSunDay (weekday firstDateOfMonth))) / 7)

            Nothing ->
                6


getMonthModelByYearAndMonth : Int -> Int -> Month
getMonthModelByYearAndMonth year month =
    let
        firstDateOfMonth : Date
        firstDateOfMonth =
            date year month 1

        firstDate =
            getFirstDateOfWeek firstDateOfMonth

        weekNum =
            getWeekNumByByYearAndMonth year month

        weeks =
            List.map
                (\x ->
                    generateWeekListByDate (addDays ((x - 1) * 7) firstDate)
                )
                (List.range 1 weekNum)
    in
        weeks


model : Model
model =
    getMonthModelByYearAndMonth 2016 12


type Msg
    = ClickDateMsg CalendarDate Common.Calendar.Date.Msg


update : Msg -> Model -> Model
update message model =
    case message of
        ClickDateMsg calendarDate subMsg ->
            let
                dateUpdater date =
                    if date == calendarDate then
                        Common.Calendar.Date.update subMsg date
                    else
                        { date | isSelected = False }

                weekUpdater =
                    List.map dateUpdater
            in
                List.map
                    weekUpdater
                    model


view : Model -> Html Msg
view model =
    let
        generateWeekDom week =
            div [ class "cal-week" ]
                (List.map
                    (\x -> (Html.map (ClickDateMsg x) (Common.Calendar.Date.view x)))
                    week
                )

        getDayStr : Weekday -> Html msg
        getDayStr day =
            div [ class "cal-date" ]
                [ div [ class "cal-text" ]
                    [ text (getWeekDayStr day) ]
                ]
    in
        div
            [ class "cal-month" ]
            [ div [ class "cal-month-head" ]
                [ div
                    [ class "cal-week" ]
                    (List.map
                        getDayStr
                        weekDays
                    )
                ]
            , div [ class "cal-month-body" ] (List.map generateWeekDom model)
            ]
