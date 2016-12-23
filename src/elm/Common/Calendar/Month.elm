module Common.Calendar.Month exposing (..)

import Task
import Html exposing (..)
import Svg exposing (svg, g, polygon)
import Svg.Attributes exposing (viewBox, x, y, width, height, points)
import Html.Attributes exposing (class, style)
import Html.Events exposing (onClick)
import Common.Calendar.Date exposing (..)
import Common.Calendar.Model exposing (Month, Week, CalendarDate, dayFromSunDay, getWeekDayStr, getMonthNumber, getMonthStr, weekDays)
import Time.Date exposing (Date, Weekday, date, addMonths, addDays, weekday, daysInMonth)
import Time exposing (Time)
import Date exposing (fromTime)
import Debug exposing (..)


compareDateWithMaybeDate : Maybe Date -> Date -> Bool
compareDateWithMaybeDate maybeDate testDate =
    case maybeDate of
        Just hasDate ->
            Time.Date.year hasDate
                == Time.Date.year testDate
                && Time.Date.month hasDate
                == Time.Date.month testDate
                && Time.Date.day hasDate
                == Time.Date.day testDate

        Nothing ->
            False


createCalendarDateByDate : Maybe Date -> Maybe Date -> Date -> CalendarDate
createCalendarDateByDate today selectedDate date =
    let
        isSelected =
            compareDateWithMaybeDate selectedDate date

        isToday =
            compareDateWithMaybeDate today date

        isHoliday =
            case weekday date of
                Time.Date.Sat ->
                    True

                Time.Date.Sun ->
                    True

                _ ->
                    False
    in
        { date = date
        , isHoliday = isHoliday
        , isAvailable = True
        , isSelected = isSelected
        , isToday = isToday
        , isInMonthRange = True
        }


generateWeekListByDate : Maybe Date -> Maybe Date -> Date -> Week
generateWeekListByDate today selectedDate date =
    List.map
        (\x ->
            x
                |> flip addDays date
                |> createCalendarDateByDate today selectedDate
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


getMonthModelByYearAndMonth : Model -> Month
getMonthModelByYearAndMonth model =
    let
        firstDateOfMonth : Date
        firstDateOfMonth =
            date model.year model.month 1

        firstDate =
            getFirstDateOfWeek firstDateOfMonth

        weekNum =
            getWeekNumByByYearAndMonth model.year model.month

        weeks =
            List.map
                (\x ->
                    generateWeekListByDate model.today model.selectedDate (addDays ((x - 1) * 7) firstDate)
                )
                (List.range 1 weekNum)
    in
        weeks


type alias Model =
    { selectedDate : Maybe Date
    , today : Maybe Date
    , year : Int
    , month : Int
    }


init : ( Model, Cmd Msg )
init =
    ( model, Task.perform NewTime Time.now )


model : Model
model =
    { selectedDate = Nothing
    , today = Nothing
    , year = 2016
    , month = 12
    }


type Msg
    = ClickDateMsg CalendarDate Common.Calendar.Date.Msg
    | PrevMonth
    | NextMonth
    | GetTimeAndThen
    | NewTime Time


update : Msg -> Model -> ( Model, Cmd Msg )
update message model =
    case message of
        ClickDateMsg calendarDate subMsg ->
            ( { model | selectedDate = Just calendarDate.date }, Cmd.none )

        PrevMonth ->
            let
                month =
                    if model.month == 1 then
                        12
                    else
                        model.month - 1

                year =
                    if model.month == 1 then
                        model.year - 1
                    else
                        model.year
            in
                ( { model | month = month, year = year }, Cmd.none )

        NextMonth ->
            let
                month =
                    if model.month == 12 then
                        1
                    else
                        model.month + 1

                year =
                    if model.month == 12 then
                        model.year + 1
                    else
                        model.year
            in
                ( { model | month = month, year = year }, Cmd.none )

        GetTimeAndThen ->
            ( model, Task.perform NewTime Time.now )

        NewTime time ->
            let
                dateByNow : Date.Date
                dateByNow =
                    (fromTime time)

                today : Date
                today =
                    date (Date.year dateByNow) (getMonthNumber (Date.month dateByNow)) (Date.day dateByNow)
            in
                log (toString dateByNow)
                    ( { model | today = Just today }, Cmd.none )


view : Model -> Html Msg
view model =
    let
        dates : Month
        dates =
            getMonthModelByYearAndMonth model

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
        div [ class "mf-cal", style [ ( "width", "400px" ) ] ]
            [ renderHead ((getMonthStr model.month ++ " " ++ toString model.year))
            , div
                [ class "cal-month", onClick GetTimeAndThen ]
                [ div [ class "cal-month-head" ]
                    [ div
                        [ class "cal-week" ]
                        (List.map
                            getDayStr
                            weekDays
                        )
                    ]
                , div [ class "cal-month-body" ] (List.map generateWeekDom dates)
                ]
            ]


renderHead : String -> Html Msg
renderHead monStr =
    div
        [ class "cal-header" ]
        [ div
            [ class "nav-btn prev"
            , onClick
                PrevMonth
            ]
            [ svg
                [ x "0"
                , y "0"
                , width "14"
                , height "14"
                , viewBox "0 0 199.404 199.404"
                ]
                [ g []
                    [ polygon [ points "135.412,0 35.709,99.702 135.412,199.404 163.695,171.119 92.277,99.702 163.695,28.285" ] []
                    ]
                ]
            ]
        , div [ class "date" ]
            [ text monStr ]
        , div
            [ class "nav-btn next"
            , onClick
                NextMonth
            ]
            [ svg
                [ x "0"
                , y "0"
                , width "14"
                , height "14"
                , viewBox "0 0 199.404 199.404"
                ]
                [ g []
                    [ polygon [ points "63.993,199.404 163.695,99.702 63.993,0 35.709,28.285 107.127,99.702 35.709,171.119" ] []
                    ]
                ]
            ]
        ]
