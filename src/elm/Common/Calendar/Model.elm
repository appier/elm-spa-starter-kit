module Common.Calendar.Model exposing (..)

import Date exposing (..)


type alias Week =
    List CalendarDate


type alias Month =
    List Week


type alias CalendarDate =
    { date : Date.Date
    , isHoliday : Bool
    , isAvailable : Bool
    , isSelected : Bool
    , isToday : Bool
    , isInMonthRange : Bool
    }
