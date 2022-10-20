module PlayElm.Modules.Sdf exposing
    ( opSmoothUnion
    , sdBox
    , sdCircle
    , sdSegment
    )

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


sdSegment : ( Float, Float ) -> ( Float, Float ) -> ( Float, Float ) -> Float -> Float
sdSegment p a b thickness =
    let
        pa =
            Vec2.sub p a

        ba =
            Vec2.sub b a

        h =
            clamp (Vec2.dot pa ba / Vec2.dot ba ba) 0.0 1.0
    in
    Vec2.length (Vec2.sub pa (Vec2.mulN ba h)) - thickness


opSmoothUnion : Float -> Float -> Float -> Float
opSmoothUnion d1 d2 k =
    let
        h =
            clamp 0.0 1.0 (0.5 + 0.5 * ((d2 - d1) / k))
    in
    Num.mix d2 d1 h - (k * h * (1.0 - h))
