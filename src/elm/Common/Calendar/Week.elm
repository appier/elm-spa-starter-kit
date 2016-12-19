module Common.Calendar.Week exposing (..)

import Date exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Common.Calendar.Date exposing (..)
import Common.Calendar.Model exposing (CalendarDate)


type alias Model =
    List CalendarDate



-- assignedDate : Date.Date
-- assignedDate =
--     Date.fromString "2016/12/11" |> Result.withDefault (Date.fromTime 0)


getDateByMonthAndDay : Int -> Int -> Date.Date
getDateByMonthAndDay year month =
    Date.fromString ("2016/" ++ (toString year) ++ "/" ++ (toString month)) |> Result.withDefault (Date.fromTime 0)


model : Model
model =
    let
        getInitCalendarDate month dateInt =
            let
                date =
                    (getDateByMonthAndDay month dateInt)
            in
                { date = date
                , isHoliday = False
                , isAvailable = True
                , isSelected = False
                , isToday = False
                , isInMonthRange = True
                }
    in
        List.map (\n -> (getInitCalendarDate 12 n)) (List.range 1 7)


type Msg
    = ClickDateMsg CalendarDate Common.Calendar.Date.Msg


update : Msg -> Model -> Model
update message model =
    case message of
        ClickDateMsg calendarDate subMsg ->
            let
                updater d =
                    if d == calendarDate then
                        Common.Calendar.Date.update subMsg d
                    else
                        { d | isSelected = False }
            in
                List.map
                    updater
                    model


view : Model -> Html Msg
view model =
    let
        dates =
            List.map (\x -> (Html.map (ClickDateMsg x) (Common.Calendar.Date.view x))) model
    in
        div
            [ class "cal-week" ]
            dates
