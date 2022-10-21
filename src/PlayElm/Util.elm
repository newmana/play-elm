module PlayElm.Util exposing (addCmd)


addCmd : Cmd msg -> ( model, Cmd msg ) -> ( model, Cmd msg )
addCmd cmd2 =
    Tuple.mapSecond (\cmd1 -> Cmd.batch [ cmd1, cmd2 ])
