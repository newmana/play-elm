module PlayElm.Msg exposing (Msg(..))

import Html.Events.Extra.Mouse as MouseEvent
import PlayElm.Types as Types


type Msg
    = MouseMove MouseEvent.Event
    | MouseDown
    | MouseUp
    | Tick Float
    | RunProgram String
    | RandomString String
    | SetBoundingClientRect (Maybe Types.BoundingClientRect)
    | SetComputedStyle (Maybe Types.ComputedStyle)
    | Nothing
