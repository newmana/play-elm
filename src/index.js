import {Elm} from './PlayElm/Main.elm'

var app = Elm.PlayElm.Main.init({
  node: document.getElementById('pre')
})

app.ports.getBoundingClientRect.subscribe(function (id) {
  var entity = document.getElementById(id);
  const brOrNull = entity ? entity.getBoundingClientRect() : null;
  app.ports.setBoundingClientRect.send(brOrNull);
});

app.ports.getComputedStyle.subscribe(function (id) {
  var entity = document.getElementById(id);
  var style = window.getComputedStyle(entity);
  const fontFamily = style.getPropertyValue('font-family');
  const fontSize = parseFloat(style.getPropertyValue('font-size'));
  const lineHeight = parseFloat(style.getPropertyValue('line-height'));
  const span = document.createElement('span');
  entity.appendChild(span);
  span.innerHTML = ''.padEnd(50, 'X');
  const cellWidth = span.getBoundingClientRect().width / 50;
  entity.removeChild(span);
  const cr = {fontFamily, fontSize, lineHeight, cellWidth};
  app.ports.setComputedStyle.send(cr);
});