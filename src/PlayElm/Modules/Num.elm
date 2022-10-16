module PlayElm.Modules.Num exposing (map, mix, tau)


tau : Float
tau =
    pi * 2


map : Float -> Float -> Float -> Float -> Float -> Float
map v inA inB outA outB =
    outA + (outB - outA) * ((v - inA) / (inB - inA))


mix : Float -> Float -> Float -> Float
mix v1 v2 a =
    v1 * (1 - a) + v2 * a
