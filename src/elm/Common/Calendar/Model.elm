module Common.Calendar.Model exposing (..)

import Date exposing (..)


type alias CalendarDate =
    { date : Date.Date
    , isHoliday : Bool
    , isAvailable : Bool
    , isSelected : Bool
    , isToday : Bool
    , isInMonthRange : Bool
    }
