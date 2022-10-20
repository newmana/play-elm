module PlayElm.Modules.Vec2 exposing (..)


add : ( Float, Float ) -> ( Float, Float ) -> ( Float, Float )
add ( aX, aY ) ( bX, bY ) =
    ( aX + bX, aY + bY )


sub : ( Float, Float ) -> ( Float, Float ) -> ( Float, Float )
sub ( aX, aY ) ( bX, bY ) =
    ( aX - bX, aY - bY )


mul : ( Float, Float ) -> ( Float, Float ) -> ( Float, Float )
mul ( aX, aY ) ( bX, bY ) =
    ( aX * bX, aY * bY )


div : ( Float, Float ) -> ( Float, Float ) -> ( Float, Float )
div ( aX, aY ) ( bX, bY ) =
    ( aX / bX, aY / bY )


addN : ( Float, Float ) -> Float -> ( Float, Float )
addN ( aX, aY ) k =
    ( aX + k, aY + k )


subN : ( Float, Float ) -> Float -> ( Float, Float )
subN ( aX, aY ) k =
    ( aX - k, aY - k )


mulN : ( Float, Float ) -> Float -> ( Float, Float )
mulN ( aX, aY ) k =
    ( aX * k, aY * k )


divN : ( Float, Float ) -> Float -> ( Float, Float )
divN ( aX, aY ) k =
    ( aX / k, aY / k )


dot : ( Float, Float ) -> ( Float, Float ) -> Float
dot ( aX, aY ) ( bX, bY ) =
    aX * bX + aY * bY


length : ( Float, Float ) -> Float
length ( x, y ) =
    sqrt ((x * x) + (y * y))
