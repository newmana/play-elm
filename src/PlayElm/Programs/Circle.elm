module PlayElm.Programs.Circle exposing (run)

import Array
import PlayElm.Modules.Sdf as Sdf
import PlayElm.Types as Types


chars : String
chars =
    "/\\MXYZabc!?=-. "


run : Types.Runnable
run context =
    let
        row rowNum =
            List.foldl (\colNum str -> str ++ runLine context colNum rowNum) "" (List.range 0 (context.cols - 1))

        newScreen =
            List.foldl (\rowNum -> Array.push (row rowNum)) Array.empty (List.range 0 (context.rows - 1))
    in
    { context | screen = newScreen }


runLine : Types.CommonContext {} -> Int -> Int -> String
runLine context x y =
    if x /= 0 && modBy 2 x == 1 then
        let
            t =
                context.time * 0.002

            radius =
                cos t * 0.4 + 0.5

            m =
                min context.cols context.rows |> toFloat

            stY =
                2.0 * (toFloat y - toFloat context.rows / 2.0) / m

            a =
                context.aspect

            stX =
                2.0 * (toFloat x - toFloat context.cols / 2.0) / m * a

            d =
                Sdf.sdCircle ( stX, stY ) radius

            c =
                1.0 - (e ^ (-5 * abs d))

            charsIndex =
                floor (c * (String.length chars |> toFloat))
        in
        String.slice charsIndex (charsIndex + 1) chars

    else
        "|"
