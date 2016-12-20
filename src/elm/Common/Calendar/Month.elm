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


generateWeekListByDate : Date -> Week
generateWeekListByDate date =
    let
        addNDayToDate number =
            Date.fromTime (Date.toTime date + number * 86400 * 1000)
    in
        List.map
            (\x ->
                x
                    |> toFloat
                    |> addNDayToDate
                    |> createCalendarDateByDate
            )
            (List.range 0 7)


getDateByYearAndMonth : Int -> Int -> Month
getDateByYearAndMonth year month =
    let
        week =
            Date.fromString ("2016/" ++ (toString year) ++ "/" ++ (toString month))
                |> Result.withDefault (Date.fromTime 0)
                |> generateWeekListByDate
    in
        [ week ]


model : Model
model =
    getDateByYearAndMonth 2016 11


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
