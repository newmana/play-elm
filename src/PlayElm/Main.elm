module PlayElm.Main exposing (main)

import Browser
import Browser.Events as BrowserEvents
import Browser.Navigation as BrowserNavigation
import Json.Decode as JsonDecode
import PlayElm.Model as Model
import PlayElm.Msg as Msg
import PlayElm.Port as Port
import PlayElm.Types as Types
import PlayElm.Update as Update
import PlayElm.Util as Util
import PlayElm.View as View
import Url


init : flags -> Url.Url -> BrowserNavigation.Key -> ( Model.Model, Cmd Msg.Msg )
init _ _ _ =
    Update.update Msg.Nothing (Model.Booting Model.defaultModel)
        |> Util.addCmd (Port.getBoundingClientRect Types.elementId)
        |> Util.addCmd (Port.getComputedStyle Types.elementId)


subscriptions : Model.Model -> Sub Msg.Msg
subscriptions _ =
    Sub.batch
        [ Port.setBoundingClientRect Msg.SetBoundingClientRect
        , Port.setComputedStyle Msg.SetComputedStyle
        , BrowserEvents.onAnimationFrameDelta Msg.Tick
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
