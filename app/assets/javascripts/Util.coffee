window.$ = (selector)->
  $el = document.querySelector selector
  if $el
    $el.on = (event, callback) ->
      $el.addEventListener event, callback, false
    $el
  else
    false

Number.prototype.toRad = ()->
  return this * Math.PI / 180;
