module PlayElm.Msg exposing (Msg(..))

import Html.Events.Extra.Mouse as MouseEvent
import PlayElm.Types as Types
import Time as Time


type Msg
    = MouseMove MouseEvent.Event
    | Tick Float
    | RandomString String
    | SetBoundingClientRect (Maybe Types.BoundingClientRect)
    | SetComputedStyle (Maybe Types.ComputedStyle)
    | Nothing
