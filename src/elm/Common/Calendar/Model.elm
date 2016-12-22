module Common.Calendar.Model exposing (..)

import Time.Date exposing (Date, Weekday)


type alias Week =
    List CalendarDate


type alias Month =
    List Week


type alias CalendarDate =
    { date : Date
    , isHoliday : Bool
    , isAvailable : Bool
    , isSelected : Bool
    , isToday : Bool
    , isInMonthRange : Bool
    }


getWeekDayStr : Weekday -> String
getWeekDayStr weekDay =
    case weekDay of
        Time.Date.Mon ->
            "Mon"

        Time.Date.Tue ->
            "Tue"

        Time.Date.Wed ->
            "Wed"

        Time.Date.Thu ->
            "Thu"

        Time.Date.Fri ->
            "Fri"

        Time.Date.Sat ->
            "Sat"

        Time.Date.Sun ->
            "Sun"


dayFromSunDay : Weekday -> Int
dayFromSunDay weekDay =
    case weekDay of
        Time.Date.Mon ->
            1

        Time.Date.Tue ->
            2

        Time.Date.Wed ->
            3

        Time.Date.Thu ->
            4

        Time.Date.Fri ->
            5

        Time.Date.Sat ->
            6

        Time.Date.Sun ->
            0


getMonthStr : Int -> String
getMonthStr month =
    case month of
        1 ->
            "Jan"

        2 ->
            "Feb"

        3 ->
            "Mar"

        4 ->
            "Apr"

        5 ->
            "May"

        6 ->
            "Jun"

        7 ->
            "Jul"

        8 ->
            "Aug"

        9 ->
            "Sep"

        10 ->
            "Oct"

        11 ->
            "Nov"

        12 ->
            "Dec"

        _ ->
            "Not Legal Month"


weekDays : List Weekday
weekDays =
    [ Time.Date.Sun
    , Time.Date.Mon
    , Time.Date.Tue
    , Time.Date.Wed
    , Time.Date.Thu
    , Time.Date.Fri
    , Time.Date.Sat
    ]
