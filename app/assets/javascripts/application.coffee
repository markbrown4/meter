#= require vendor/ios-orientationchange-fix
#= require vendor/templ
#= require Util

startPos = null
startTime = null
activeExercise = 'Bike'
totalTime = 0
totalDistance = 0
timer = null
$time = $("#time")
$distance = $("#distance")
$body = document.body
if !localStorage['trips']
  localStorage['trips'] = JSON.stringify([])
trips = JSON.parse(localStorage['trips']) || []
months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct','Nov', 'Dec']

switchTab = (event)->
  event.preventDefault()
  li = this.parentNode;
  ul = li.parentNode;
  lis = ul.getElementsByTagName('li')
  for el in lis
    el.classList.remove('active');
  li.classList.add('active');
  activeExercise = li.innerHTML;

for tab in ['ride', 'run', 'walk']
  $el = $('#' + tab + ' a')
  $el.on 'click', switchTab

window.onload = ->
  if navigator.geolocation
    navigator.geolocation.getCurrentPosition (position)->
      if $start
        $start.classList.remove 'inactive'
    , (error) ->
      alert "Yeah, it ain't gonna work without geolocation :("
    , { enableHighAccuracy: true }

displayTime = ->
  ms = totalTime + new Date().getTime() - startTime
  x = ms / 1000
  seconds = x % 60
  x /= 60
  minutes = x % 60
  x /= 60
  hours = x % 24
  seconds = Math.floor(seconds)
  minutes = Math.floor(minutes)
  seconds = if seconds < 10 then "0"+ seconds else seconds
  $time.innerHTML = "#{minutes}:#{seconds}"
  timer = setTimeout displayTime, 10
  
displayDistance = (pos)->
  if totalTime < 2000
    startPos = pos.coords
  else
    newPos = pos.coords
    totalDistance = calculateDistance startPos.latitude, startPos.longitude, newPos.latitude, newPos.longitude
    $distance.innerHTML = totalDistance

calculateDistance = (lat1, lon1, lat2, lon2)->
  R = 6371; # km
  dLat = (lat2-lat1).toRad();
  dLon = (lon2-lon1).toRad();
  a = Math.sin(dLat/2) * Math.sin(dLat/2) +
          Math.cos(lat1.toRad()) * Math.cos(lat2.toRad()) *
          Math.sin(dLon/2) * Math.sin(dLon/2);
  c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a));
  distance = R * c;

  distance.toFixed(2)

$start = $('#start')
if $start
  $start.on 'click', (event)->
    event.preventDefault()
    $start.innerHTML = if $start.innerHTML == 'Start' then 'Pause' else 'Start'
  
    if timer
      clearTimeout timer
      totalTime += new Date().getTime() - startTime;
      timer = null
      $body.classList.remove 'running'
      $body.classList.add 'complete'
    else
      startTime = new Date().getTime()
      displayTime()
      navigator.geolocation.watchPosition displayDistance
      $body.classList.add 'running'
      $body.classList.remove 'complete'

$save = $('#save')
if $save
  $save.on 'click', (event)->
    event.preventDefault()
    trip =
      excercise: activeExercise,
      time: totalTime
      distance: totalDistance
      date: new Date()
  
    trips.push trip
    localStorage['trips'] = JSON.stringify(trips)
  
    window.location = '/'
  
$logs = $('#logs')
if $logs
  trips = JSON.parse(localStorage['trips'])
  logs = []
  for trip in trips
    seconds = trip.time / 1000
    minutes = seconds / 60
    hours = minutes / 60
    timeString = '';
    timeString += Math.floor(hours) + 'h ' if hours > 1
    timeString += Math.floor(minutes) + 'm ' if minutes > 1
    timeString += Math.floor(seconds) + 's' if minutes < 1
    date = new Date(trip.date)
    logs.push({
      date: date.getDate() + ' ' + months[date.getMonth()]
      time: timeString
      distance: trip.distance + 'km'
    })
  $logs.innerHTML = tmpl "logs_tmpl", { logs: logs }


$clear = $('#clear')
if $clear
  $clear.on 'click', (event)->
    event.preventDefault();
    localStorage['trips'] = JSON.stringify([])
    window.location = '/'

