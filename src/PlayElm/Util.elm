module PlayElm.Util exposing (addCmd, updateWith)


addCmd : Cmd msg -> ( model, Cmd msg ) -> ( model, Cmd msg )
addCmd cmd2 =
    Tuple.mapSecond (\cmd1 -> Cmd.batch [ cmd1, cmd2 ])


updateWith : (subModel -> model) -> (subMsg -> msg) -> ( subModel, Cmd subMsg ) -> ( model, Cmd msg )
updateWith toModel toMsg ( subModel, subCmd ) =
    ( toModel subModel, Cmd.map toMsg subCmd )
