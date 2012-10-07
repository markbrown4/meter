(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  this.Log = (function() {

    Log.prototype.trips = [];

    function Log() {
      this.reset = __bind(this.reset, this);

      var tripData, tripsData, _i, _len;
      if (!localStorage['trips']) {
        localStorage['trips'] = JSON.stringify([]);
      }
      tripsData = JSON.parse(localStorage['trips']);
      for (_i = 0, _len = tripsData.length; _i < _len; _i++) {
        tripData = tripsData[_i];
        this.trips.push(new Trip(tripData));
      }
    }

    Log.prototype.saveTrip = function(trip) {
      this.trips.push(trip);
      return localStorage['trips'] = JSON.stringify(this.trips);
    };

    Log.prototype.reset = function(event) {
      event.preventDefault();
      if (confirm('Are you sure you want to reset your trips?')) {
        this.trips = [];
        localStorage['trips'] = JSON.stringify([]);
        return this.render();
      }
    };

    Log.prototype.render = function() {
      var kilometersTotal, logData, millisecondsTotal, totalTrip, trip, _i, _len, _ref;
      logData = [];
      millisecondsTotal = 0;
      kilometersTotal = 0;
      _ref = this.trips;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        trip = _ref[_i];
        millisecondsTotal += trip.milliseconds;
        kilometersTotal += trip.kilometers;
        logData.push({
          date: trip.date(),
          story: trip.toString()
        });
      }
      totalTrip = new Trip({
        milliseconds: millisecondsTotal,
        kilometers: kilometersTotal
      });
      $('#logs').innerHTML = tmpl("logs_tmpl", {
        logs: logData
      });
      $('#time').innerHTML = totalTrip.time();
      return $('#distance').innerHTML = kilometersTotal.toFixed(2) + 'km';
    };

    return Log;

  })();

}).call(this);
