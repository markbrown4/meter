class @Log
  trips: []

  constructor: ->
    if !localStorage['trips']
      localStorage['trips'] = JSON.stringify []
    tripsData = JSON.parse localStorage['trips']
    for tripData in tripsData
      @trips.push new Trip tripData

  saveTrip: (trip)->
    @trips.push trip
    localStorage['trips'] = JSON.stringify @trips

  reset: (event)=>
    event.preventDefault();
    if confirm('Are you sure you want to reset your trips?')
      @trips = []
      localStorage['trips'] = JSON.stringify []
      @render()

  render: ->
    logData = []
    millisecondsTotal = 0
    kilometersTotal = 0
    for trip in @trips
      millisecondsTotal += trip.milliseconds
      kilometersTotal += trip.kilometers
      
      logData.push
        date: trip.date()
        story: trip.toString()
    
    totalTrip = new Trip
      milliseconds: millisecondsTotal
      kilometers: kilometersTotal
    
    $('#logs').innerHTML = tmpl "logs_tmpl", { logs: logData }
    $('#time').innerHTML = totalTrip.time()
    $('#distance').innerHTML = kilometersTotal.toFixed(2) + 'km'