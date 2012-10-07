(function() {
  var activities;

  activities = {
    'Ride': 'Rode',
    'Run': 'Ran',
    'Walk': 'Walked'
  };

  this.Trip = (function() {

    function Trip(options) {
      this.activity = options.activity;
      this.milliseconds = options.milliseconds;
      this.kilometers = options.kilometers;
      this.data = options.data;
      this.datetime = new Date();
    }

    Trip.prototype.toString = function() {
      return activities[this.activity] + ' ' + this.distance() + ' in ' + this.time();
    };

    Trip.prototype.time = function() {
      var hours, minutes, seconds, timeString;
      seconds = this.milliseconds / 1000;
      minutes = seconds / 60;
      hours = minutes / 60;
      timeString = '';
      if (hours > 1) {
        timeString += Math.floor(hours) + 'h ';
      }
      if (minutes > 1) {
        timeString += Math.floor(minutes) + 'm ';
      }
      if (minutes < 1) {
        timeString += Math.floor(seconds) + 's';
      }
      return timeString;
    };

    Trip.prototype.distance = function() {
      var kms;
      kms = this.kilometers.toFixed(2);
      if (Number(kms) === 0) {
        return "<u>nowhere</u>";
      }
      return kms + 'km';
    };

    Trip.prototype.date = function() {
      var date;
      date = new Date(this.datetime);
      return date.getDate() + ' ' + months[date.getMonth()];
    };

    return Trip;

  })();

}).call(this);
