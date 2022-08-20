import {Elm} from './PlayElm/Main.elm'

var app = Elm.PlayElm.Main.init({
  node: document.getElementById('pre')
})

app.ports.getBoundingClientRect.subscribe(function (id) {
  var entity = document.getElementById(id);
  const brOrNull = entity ? entity.getBoundingClientRect() : null;
  console.log("Got " + JSON.stringify(brOrNull));
  app.ports.setBoundingClientRect.send(brOrNull);
});