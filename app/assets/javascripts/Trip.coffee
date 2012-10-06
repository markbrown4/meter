activities =
  'Ride': 'Rode'
  'Run' : 'Ran'
  'Walk': 'Walked'

class @Trip

  constructor: (options)->
    @activity = options.activity
    @milliseconds = options.milliseconds
    @kilometers = options.kilometers
    @datetime = new Date()

  toString: ->
    activities[@activity] + ' ' + @distance() + ' in ' + @time()

  time: ->
    seconds = @milliseconds / 1000
    minutes = seconds / 60
    hours = minutes / 60
    timeString = '';
    timeString += Math.floor(hours) + 'h ' if hours > 1
    timeString += Math.floor(minutes) + 'm ' if minutes > 1
    timeString += Math.floor(seconds) + 's' if minutes < 1
    
    timeString

  distance: ->
    kms = @kilometers.toFixed(2)
    return "<u>nowhere</u>" if Number(kms) == 0
    kms + 'km'

  date: ->
    date = new Date @datetime
    date.getDate() + ' ' + months[date.getMonth()]
    