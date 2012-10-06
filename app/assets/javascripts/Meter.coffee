class @Meter
  startPos: false
  startTime: null
  milliseconds: 0
  kilometers: 0
  timer: false
  watcher: null
  activity: 'Ride'

  constructor: ->
    @log = new Log()
    @initActivityTabs()

  toggle: (event)=>
    event.preventDefault()
    if !@timer
      @start()
      $('#start').innerHTML = 'Pause'
    else
      @stop()
      $('#start').innerHTML = 'Continue'

  start: ->
    @startTime = new Date().getTime()
    @watcher = navigator.geolocation.watchPosition @displayDistance, (error) ->
      alert "Sheeyat!"
    , { enableHighAccuracy: true, maximumAge: 30000, timeout: 27000 }
    @displayTime()
    
    $body.classList.add 'running'
    $body.classList.remove 'complete'

  stop: ->
    clearTimeout @timer
    @timer = false
    @milliseconds += new Date().getTime() - @startTime;
    navigator.geolocation.clearWatch @watcher
    
    $body.classList.remove 'running'
    $body.classList.add 'complete'

  save: (event) =>
    event.preventDefault()
    trip = new Trip
      activity: @activity
      milliseconds: @milliseconds
      kilometers: @kilometers
    @log.saveTrip trip
    
    window.location = '/'

  initActivityTabs: ->
    for tab in ['ride', 'run', 'walk']
      $('#' + tab + ' a').on 'click', @changeActivity

  changeActivity: (event)=>
    event.preventDefault()
    a = event.target
    li = a.parentNode
    ul = li.parentNode
    lis = ul.getElementsByTagName 'li'
    for el in lis
      el.classList.remove 'active'
    li.classList.add 'active'
    @activity = a.innerHTML

  displayTime: ->
    ms = @milliseconds + new Date().getTime() - @startTime
    x = ms / 1000
    seconds = x % 60
    x /= 60
    minutes = x % 60
    x /= 60
    hours = x % 24
    seconds = Math.floor(seconds)
    minutes = Math.floor(minutes)
    seconds = if seconds < 10 then "0"+ seconds else seconds
    $('#time').innerHTML = "#{minutes}:#{seconds}"
    @timer = setTimeout =>
      @displayTime()
    , 10
    
    true

  displayDistance: (pos)=>
    newPos = pos.coords
    if newPos.accuracy < 100
      if !@startPos
        @startPos = newPos
      else
        @kilometers = @calculateDistance @startPos.latitude, @startPos.longitude, newPos.latitude, newPos.longitude
        $('#distance').innerHTML = @kilometers.toFixed 2

  calculateDistance: (lat1, lon1, lat2, lon2)->
    R = 6371; # km
    dLat = (lat2-lat1).toRad()
    dLon = (lon2-lon1).toRad()
    a = Math.sin(dLat/2) * Math.sin(dLat/2) +
            Math.cos(lat1.toRad()) * Math.cos(lat2.toRad()) *
            Math.sin(dLon/2) * Math.sin(dLon/2)
    c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a))
    R * c