module PlayElm.Modules.Sdf exposing
    ( opSmoothUnion
    , sdCircle
    , sdSegment
    )

import PlayElm.Modules.Num as Num
import PlayElm.Modules.Vec2 as Vec2


sdCircle : ( Float, Float ) -> Float -> Float
sdCircle p radius =
    Vec2.length p - radius


sdSegment : ( Float, Float ) -> ( Float, Float ) -> ( Float, Float ) -> Float -> Float
sdSegment p a b thickness =
    let
        pa =
            Vec2.sub p a

        ba =
            Vec2.sub b a

        h =
            clamp 0.0 1.0 (Vec2.dot pa ba / Vec2.dot ba ba)
    in
    Vec2.length (Vec2.sub pa (Vec2.mulN ba h)) - thickness


opSmoothUnion : Float -> Float -> Float -> Float
opSmoothUnion d1 d2 k =
    let
        h =
            clamp 0.0 1.0 (0.5 + 0.5 * ((d2 - d1) / k))
    in
    Num.mix d2 d1 h - (k * h * (1.0 - h))
