module Common.Calendar.Month exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Common.Calendar.Date exposing (..)
import Common.Calendar.Model exposing (Month, Week, CalendarDate)
import Time.Date exposing (Date, date, addMonths, addDays, weekday)


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
            case weekDay of
                Time.Date.Mon ->
                    -1

                Time.Date.Tue ->
                    -2

                Time.Date.Wed ->
                    -3

                Time.Date.Thu ->
                    -4

                Time.Date.Fri ->
                    -5

                Time.Date.Sat ->
                    -6

                Time.Date.Sun ->
                    0
    in
        addDays adjustDay date


getWeekNumByByYearAndMonth : Date -> Int
getWeekNumByByYearAndMonth date =
    -- TODO..
    10


getMonthModelByYearAndMonth : Int -> Int -> Month
getMonthModelByYearAndMonth year month =
    let
        firstDateOfMonth : Date
        firstDateOfMonth =
            date year month 1

        firstDate =
            getFirstDateOfWeek firstDateOfMonth

        weekNum =
            getWeekNumByByYearAndMonth firstDateOfMonth

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
    in
        div
            [ class "cal-month" ]
            (List.map generateWeekDom model)
