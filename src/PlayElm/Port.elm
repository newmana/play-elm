port module PlayElm.Port exposing
    ( getBoundingClientRect
    , getComputedStyle
    , setBoundingClientRect
    , setComputedStyle
    )

import PlayElm.Types as Types


port getBoundingClientRect : String -> Cmd msg


port setBoundingClientRect : (Maybe Types.BoundingClientRect -> msg) -> Sub msg


port getComputedStyle : String -> Cmd msg


port setComputedStyle : (Maybe Types.ComputedStyle -> msg) -> Sub msg
