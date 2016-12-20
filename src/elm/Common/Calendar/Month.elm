module Common.Calendar.Month exposing (..)

import Date exposing (Date)
import Html exposing (..)
import Html.Attributes exposing (..)
import Common.Calendar.Date exposing (..)
import Common.Calendar.Model exposing (Month, Week, CalendarDate)


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


addNDayToDate : Float -> Date -> Date
addNDayToDate number date =
    Date.fromTime (Date.toTime date + number * 86400 * 1000)


generateWeekListByDate : Date -> Week
generateWeekListByDate date =
    List.map
        (\x ->
            x
                |> toFloat
                |> flip addNDayToDate date
                |> createCalendarDateByDate
        )
        (List.range 0 6)


getNumOfDayByYearAndMonth : Int -> Int -> Int
getNumOfDayByYearAndMonth year month =
    -- TODO
    1


getWeekNumByByYearAndMonth : Int -> Int -> Int
getWeekNumByByYearAndMonth year month =
    -- TODO
    20


getMonthModelByYearAndMonth : Int -> Int -> Month
getMonthModelByYearAndMonth year month =
    let
        firstDateOfMonth : Date
        firstDateOfMonth =
            Date.fromString ("2016/" ++ (toString year) ++ "/" ++ (toString month))
                |> Result.withDefault (Date.fromTime 0)

        weekNum =
            getWeekNumByByYearAndMonth year month

        weeks =
            List.map
                (\x ->
                    generateWeekListByDate (addNDayToDate (toFloat (x - 1) * 7) firstDateOfMonth)
                )
                (List.range 1 weekNum)
    in
        weeks


model : Model
model =
    getMonthModelByYearAndMonth 2016 11


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
