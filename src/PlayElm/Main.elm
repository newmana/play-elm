module PlayElm.Main exposing (main)

import Browser as Browser
import Browser.Navigation as BrowserNavigation
import Html.Events.Extra.Mouse as MouseEvent
import Json.Decode as JsonDecode
import PlayElm.Model as Model
import PlayElm.Msg as Msg
import PlayElm.Port as Port
import PlayElm.Update as Update
import PlayElm.Util as Util
import PlayElm.View as View
import Task as Task
import Time as Time
import Url as Url


init : flags -> Url.Url -> BrowserNavigation.Key -> ( Model.Model, Cmd Msg.Msg )
init flags url nav =
    Update.update Msg.Nothing (Model.Booting Model.defaultModel)
        |> Util.addCmd (Port.getBoundingClientRect Model.elementId)
        |> Util.addCmd (Port.getComputedStyle Model.elementId)


subscriptions : Model.Model -> Sub Msg.Msg
subscriptions model =
    Sub.batch
        [ Time.every 5 Msg.Tick
        , Port.setBoundingClientRect Msg.SetBoundingClientRect
        , Port.setComputedStyle Msg.SetComputedStyle
        ]


view : Model.Model -> Browser.Document Msg.Msg
view model =
    { title = "play-elm"
    , body = View.view model
    }


main : Program JsonDecode.Value Model.Model Msg.Msg
main =
    Browser.application
        { init = init
        , onUrlChange = always Msg.Nothing
        , onUrlRequest = always Msg.Nothing
        , subscriptions = subscriptions
        , update = Update.update
        , view = view
        }
