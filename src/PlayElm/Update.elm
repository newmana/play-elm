module PlayElm.Update exposing (update)

import PlayElm.Model as Model
import PlayElm.Msg as Msg
import PlayElm.Port as Port
import PlayElm.Programs.Balls as Balls
import PlayElm.Types as Types
import PlayElm.Util as Util
import Time as Time


update : Msg.Msg -> Model.Model -> ( Model.Model, Cmd Msg.Msg )
update msg model =
    case ( msg, model ) of
        ( Msg.Tick newTime, Model.Booting bm ) ->
            let
                _ =
                    Debug.log "Now" "Booting"
            in
            tick newTime bm |> Tuple.mapFirst Model.Booting

        ( Msg.Tick newTime, Model.Running rm ) ->
            let
                context =
                    { time = rm.time
                    , cols = rm.cols
                    , rows = rm.rows
                    , width = rm.clientRect.width
                    , height = rm.clientRect.height
                    , aspect = rm.aspect
                    }

                _ =
                    Debug.log "Now" "Running"

                _ =
                    Debug.log "Now" (Balls.run 1 1 context)
            in
            tick newTime rm |> Tuple.mapFirst Model.Running

        ( Msg.MouseMove e, Model.Booting bm ) ->
            mouseMove e.pagePos bm |> Tuple.mapFirst Model.Booting

        ( Msg.MouseMove e, Model.Running rm ) ->
            mouseMove e.pagePos rm |> Tuple.mapFirst Model.Running

        ( Msg.SetBoundingClientRect r, Model.Booting bm ) ->
            ( boot r bm.computedStyle bm, Cmd.none )

        ( Msg.SetComputedStyle s, Model.Booting bm ) ->
            ( boot bm.clientRect s bm, Cmd.none )

        _ ->
            ( model, Cmd.none )


tick : Time.Posix -> Model.CommonProperties a -> ( Model.CommonProperties a, Cmd msg )
tick newTime m =
    ( { m | time = newTime }, Port.getBoundingClientRect Model.elementId )


mouseMove : ( Float, Float ) -> Model.CommonProperties a -> ( Model.CommonProperties a, Cmd msg )
mouseMove pos m =
    ( { m | pointer = pos }, Cmd.none )


boot : Maybe Types.BoundingClientRect -> Maybe Types.ComputedStyle -> Model.BootingModel -> Model.Model
boot maybeCr maybeCs m =
    case ( maybeCr, maybeCs ) of
        ( Just cr, Just cs ) ->
            let
                rows =
                    floor (cr.width / cs.cellWidth)

                cols =
                    floor (cr.height / cs.lineHeight)
            in
            Model.Running
                { pointer = m.pointer
                , time = m.time
                , clientRect = cr
                , computedStyle = cs
                , aspect = cs.cellWidth / cs.lineHeight
                , rows = rows
                , cols = cols
                }

        ( Just cr, Nothing ) ->
            Model.Booting { m | clientRect = Just cr }

        ( Nothing, Just cs ) ->
            Model.Booting { m | computedStyle = Just cs }

        ( Nothing, Nothing ) ->
            Model.Booting m
