module PlayElm.Msg exposing (Msg(..))

import Html.Events.Extra.Mouse as MouseEvent
import PlayElm.Types as Types
import Time as Time


type Msg
    = MouseMove MouseEvent.Event
    | MouseDown MouseEvent.Event
    | MouseUp MouseEvent.Event
    | Tick Float
    | RunProgram String
    | RandomString String
    | SetBoundingClientRect (Maybe Types.BoundingClientRect)
    | SetComputedStyle (Maybe Types.ComputedStyle)
    | Nothing
