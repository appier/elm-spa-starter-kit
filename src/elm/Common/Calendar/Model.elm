module Common.Calendar.Model exposing (..)

import Time.Date exposing (Date)


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
