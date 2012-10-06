#= require vendor/ios-orientationchange-fix
#= require vendor/templ
#= require Util
#= require Meter
#= require Log
#= require Trip

window.$body = document.body

window.onload = ->
  switch document.body.className

    when "index"
      log = new Log()
      log.render()
      $('#reset').on 'click', log.reset

    when "new"
      meter = new Meter()
      $('#start').on 'click', meter.toggle
      $('#save').on 'click', meter.save

