port module PlayElm.Port exposing (getBoundingClientRect, setBoundingClientRect)

import PlayElm.Types as Types


port getBoundingClientRect : String -> Cmd msg


port setBoundingClientRect : (Maybe Types.BoundingClientRect -> msg) -> Sub msg
