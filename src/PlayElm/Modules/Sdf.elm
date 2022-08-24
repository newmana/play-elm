module PlayElm.Modules.Sdf exposing (opSmoothUnion, sdCircle)

import PlayElm.Modules.Num as Num
import PlayElm.Modules.Vec2 as Vec2


sdCircle : ( Float, Float ) -> Float -> Float
sdCircle p radius =
    Vec2.length p - radius


sdBox : ( Float, Float ) -> ( Float, Float ) -> Float
sdBox ( pX, pY ) ( centerX, centerY ) =
    let
        ( dX, dY ) =
            ( abs pX - centerX |> max 0, abs pY - centerY |> max 0 )
    in
    Vec2.length ( dX, dY ) + (max dX dY |> min 0.0)


opSmoothUnion : Float -> Float -> Float -> Float
opSmoothUnion d1 d2 k =
    let
        h =
            clamp 0.0 1.0 (0.5 + 0.5 * ((d2 - d1) / k))
    in
    Num.mix d2 d1 h - (k * h * (1.0 - h))
