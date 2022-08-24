module PlayElm.Modules.Vec2 exposing (length)


length : ( Float, Float ) -> Float
length ( x, y ) =
    sqrt ((x * x) + (y * y))
