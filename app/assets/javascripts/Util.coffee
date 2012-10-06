window.$ = (selector)->
  $el = document.querySelector selector
  if $el
    $el.on = (event, callback) ->
      $el.addEventListener event, callback, false
    return $el
  
  false

window.emptyFn = ->
window.months = 'Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec'.split ' '
  
Number::toRad = ->
  this * Math.PI / 180
