module PlayElm.Modules.Num exposing
    ( map
    , mix
    , smoothstep
    )


map : Float -> Float -> Float -> Float -> Float -> Float
map v inA inB outA outB =
    outA + (outB - outA) * ((v - inA) / (inB - inA))


mix : Float -> Float -> Float -> Float
mix v1 v2 a =
    v1 * (1 - a) + v2 * a


smoothstep : Float -> Float -> Float -> Float
smoothstep edge0 edge1 t =
    let
        x =
            clamp 0 1 ((t - edge0) / (edge1 - edge0))
    in
    x * x * (3 - (2 * x))
