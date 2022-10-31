module PlayElm.Update exposing (update)

import Array
import Dict
import PlayElm.Model as Model
import PlayElm.Msg as Msg
import PlayElm.Port as Port
import PlayElm.Programs.Api as ProgramsApi
import PlayElm.Programs.Balls as Balls
import PlayElm.Programs.Generator as Generator
import PlayElm.Programs.Update as Update
import PlayElm.Types as Types
import Tuple


update : Msg.Msg -> Model.Model -> ( Model.Model, Cmd Msg.Msg )
update msg model =
    case ( msg, model ) of
        ( Msg.Tick newTime, Model.Booting bmm ) ->
            ( Types.tick newTime bmm, Port.getBoundingClientRect Types.elementId ) |> Tuple.mapFirst Model.Booting

        ( Msg.Tick newTime, Model.Fetch rmm ) ->
            if rmm.context.running then
                rmm.config.fetch newTime rmm.context |> toModel rmm Model.Executing

            else
                ( Types.tick newTime rmm.context, Port.getBoundingClientRect Types.elementId ) |> toModel rmm Model.Executing

        ( Msg.Tick newTime, Model.Executing emm ) ->
            if emm.context.running then
                emm.config.execute emm.runner emm.context |> toModel emm Model.Fetch

            else
                ( Types.tick newTime emm.context, Port.getBoundingClientRect Types.elementId ) |> toModel emm Model.Fetch

        ( Msg.RandomString str, Model.Executing emm ) ->
            if emm.context.running then
                let
                    getContext =
                        emm.context

                    getDoers =
                        getContext.effects

                    newDoers =
                        { getDoers | generatedString = str }

                    newContext =
                        { getContext | effects = newDoers }
                in
                emm.config.execute emm.runner newContext |> toModel emm Model.Fetch

            else
                ( model, Port.getBoundingClientRect Types.elementId )

        ( Msg.RandomInts ints, Model.Executing emm ) ->
            if emm.context.running then
                let
                    getContext =
                        emm.context

                    getDoers =
                        getContext.effects

                    newDoers =
                        { getDoers | generatedInts = ints }

                    newContext =
                        { getContext | effects = newDoers }
                in
                emm.config.execute emm.runner newContext |> toModel emm Model.Fetch

            else
                ( model, Port.getBoundingClientRect Types.elementId )

        ( Msg.RandomFloats floats, Model.Executing emm ) ->
            if emm.context.running then
                let
                    getContext =
                        emm.context

                    getDoers =
                        getContext.effects

                    newDoers =
                        { getDoers | generatedFloats = floats }

                    newContext =
                        { getContext | effects = newDoers }
                in
                emm.config.execute emm.runner newContext |> toModel emm Model.Fetch

            else
                ( model, Port.getBoundingClientRect Types.elementId )

        ( Msg.MouseMove e, Model.Booting bm ) ->
            mouseMove e.pagePos bm |> Tuple.mapFirst Model.Booting

        ( Msg.MouseDown, Model.Booting bm ) ->
            mousePressed True bm |> Tuple.mapFirst Model.Booting

        ( Msg.MouseUp, Model.Booting bm ) ->
            mousePressed False bm |> Tuple.mapFirst Model.Booting

        ( Msg.MouseMove e, Model.Fetch rm ) ->
            mouseMove e.pagePos rm.context |> toModel rm Model.Fetch

        ( Msg.MouseDown, Model.Fetch rm ) ->
            mousePressed True rm.context |> toModel rm Model.Fetch

        ( Msg.MouseUp, Model.Fetch rm ) ->
            mousePressed False rm.context |> toModel rm Model.Fetch

        ( Msg.RunProgram programName, Model.Fetch rm ) ->
            ( runNewProgram programName rm |> Model.Fetch, Port.getBoundingClientRect Types.elementId )

        ( Msg.RunProgram programName, Model.Executing em ) ->
            ( runNewProgram programName em |> Model.Fetch, Port.getBoundingClientRect Types.elementId )

        ( Msg.SetBoundingClientRect r, Model.Booting bm ) ->
            let
                newModel =
                    { bm | clientRect = r }
            in
            ( boot newModel, Cmd.none )

        ( Msg.SetBoundingClientRect r, Model.Fetch rm ) ->
            let
                getContext =
                    rm.context

                newContext =
                    case r of
                        Just newR ->
                            let
                                ( cols, rows ) =
                                    computeScreenContext getContext.computedStyle newR
                            in
                            { getContext | clientRect = newR, cols = cols, rows = rows }

                        Nothing ->
                            getContext

                newModel =
                    { rm | context = newContext }
            in
            ( Model.Fetch newModel, Cmd.none )

        ( Msg.SetComputedStyle s, Model.Booting bm ) ->
            let
                newModel =
                    { bm | computedStyle = s }
            in
            ( boot newModel, Cmd.none )

        _ ->
            ( model, Cmd.none )


mouseMove : ( Float, Float ) -> Types.CommonProperties a -> ( Types.CommonProperties a, Cmd msg )
mouseMove pos m =
    ( { m | pointer = pos }, Cmd.none )


mousePressed : Bool -> Types.CommonProperties a -> ( Types.CommonProperties a, Cmd msg )
mousePressed pressed m =
    ( { m | pressed = pressed }, Cmd.none )


boot : Model.BootingModel -> Model.Model
boot m =
    case ( m.clientRect, m.computedStyle ) of
        ( Just cr, Just cs ) ->
            let
                ( cols, rows ) =
                    computeScreenContext cs cr

                context =
                    { pointer = m.pointer
                    , pressed = m.pressed
                    , time = m.time
                    , clientRect = cr
                    , computedStyle = cs
                    , aspect = cs.cellWidth / cs.lineHeight
                    , rows = rows
                    , cols = cols
                    , screen = Array.empty
                    , running = True
                    , effects =
                        (ProgramsApi.defaultProgram Balls.run).effects
                    }

                config =
                    { execute = Update.execute
                    , fetch = Update.fetch
                    }
            in
            Model.Fetch
                { context = context
                , runner = Balls.run
                , config = config
                , programs = ProgramsApi.programs
                , programName = "Balls"
                }

        _ ->
            Model.Booting m


computeScreenContext : Types.ComputedStyle -> Types.BoundingClientRect -> ( Int, Int )
computeScreenContext cs cr =
    let
        cols =
            floor (cr.width / cs.cellWidth)

        rows =
            floor (cr.height / cs.lineHeight)
    in
    ( cols, rows )


toModel : Model.RunningModel -> (Model.RunningModel -> Model.Model) -> (( Types.Context, b ) -> ( Model.Model, b ))
toModel emm m =
    Tuple.mapFirst (\x -> { emm | context = x } |> m)


runNewProgram : String -> Model.RunningModel -> Model.RunningModel
runNewProgram programName rm =
    let
        newPrograms =
            Dict.get programName rm.programs
    in
    case newPrograms of
        Just p ->
            Model.changeProgram rm p programName

        Nothing ->
            rm
