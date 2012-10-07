(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  this.Meter = (function() {

    Meter.prototype.checkpointPos = false;

    Meter.prototype.milliseconds = 0;

    Meter.prototype.kilometers = 0;

    Meter.prototype.data = [];

    Meter.prototype.timer = false;

    Meter.prototype.activity = 'Ride';

    function Meter() {
      this.displayDistance = __bind(this.displayDistance, this);

      this.changeActivity = __bind(this.changeActivity, this);

      this.save = __bind(this.save, this);

      this.checkpoint = __bind(this.checkpoint, this);

      this.toggle = __bind(this.toggle, this);
      this.log = new Log();
      this.initActivityTabs();
    }

    Meter.prototype.toggle = function(event) {
      event.preventDefault();
      if (!this.timer) {
        this.start();
        return $('#start').innerHTML = 'Pause';
      } else {
        this.stop();
        return $('#start').innerHTML = 'Continue';
      }
    };

    Meter.prototype.start = function() {
      this.startTime = new Date().getTime();
      this.watcher = navigator.geolocation.watchPosition(this.displayDistance, function(error) {
        return alert("Sheeyat!");
      }, {
        enableHighAccuracy: true
      });
      this.checkpointInterval = setInterval(this.checkpoint, 20000);
      this.displayTime();
      $body.classList.add('running');
      return $body.classList.remove('complete');
    };

    Meter.prototype.checkpoint = function() {
      this.data.push([this.currentPos.latitude, this.currentPos.longitude]);
      this.kilometers += this.calculateDistance(this.checkpointPos.latitude, this.checkpointPos.longitude, this.currentPos.latitude, this.currentPos.longitude);
      return this.checkpointPos = this.currentPos;
    };

    Meter.prototype.stop = function() {
      clearTimeout(this.timer);
      clearInterval(this.checkpointInterval);
      navigator.geolocation.clearWatch(this.watcher);
      this.timer = false;
      this.milliseconds += new Date().getTime() - this.startTime;
      this.checkpoint();
      $('#distance').innerHTML = this.kilometers.toFixed(2);
      $body.classList.remove('running');
      return $body.classList.add('complete');
    };

    Meter.prototype.save = function(event) {
      var trip;
      event.preventDefault();
      trip = new Trip({
        activity: this.activity,
        milliseconds: this.milliseconds,
        kilometers: this.kilometers,
        data: this.data
      });
      this.log.saveTrip(trip);
      return window.location = '/';
    };

    Meter.prototype.initActivityTabs = function() {
      var tab, _i, _len, _ref, _results;
      _ref = ['ride', 'run', 'walk'];
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        tab = _ref[_i];
        _results.push($('#' + tab + ' a').on('click', this.changeActivity));
      }
      return _results;
    };

    Meter.prototype.changeActivity = function(event) {
      var a, el, li, lis, ul, _i, _len;
      event.preventDefault();
      a = event.target;
      li = a.parentNode;
      ul = li.parentNode;
      lis = ul.getElementsByTagName('li');
      for (_i = 0, _len = lis.length; _i < _len; _i++) {
        el = lis[_i];
        el.classList.remove('active');
      }
      li.classList.add('active');
      return this.activity = a.innerHTML;
    };

    Meter.prototype.displayTime = function() {
      var hours, minutes, ms, seconds, x,
        _this = this;
      ms = this.milliseconds + new Date().getTime() - this.startTime;
      x = ms / 1000;
      seconds = x % 60;
      x /= 60;
      minutes = x % 60;
      x /= 60;
      hours = x % 24;
      seconds = Math.floor(seconds);
      minutes = Math.floor(minutes);
      seconds = seconds < 10 ? "0" + seconds : seconds;
      $('#time').innerHTML = "" + minutes + ":" + seconds;
      this.timer = setTimeout(function() {
        return _this.displayTime();
      }, 10);
      return true;
    };

    Meter.prototype.displayDistance = function(pos) {
      var distanceFromCheckpoint;
      this.currentPos = pos.coords;
      if (!this.checkpointPos) {
        return this.checkpointPos = this.currentPos;
      } else {
        distanceFromCheckpoint = this.calculateDistance(this.checkpointPos.latitude, this.checkpointPos.longitude, this.currentPos.latitude, this.currentPos.longitude);
        return $('#distance').innerHTML = (this.kilometers + distanceFromCheckpoint).toFixed(2);
      }
    };

    Meter.prototype.calculateDistance = function(lat1, lon1, lat2, lon2) {
      var R, a, c, dLat, dLon;
      R = 6371;
      dLat = (lat2 - lat1).toRad();
      dLon = (lon2 - lon1).toRad();
      a = Math.sin(dLat / 2) * Math.sin(dLat / 2) + Math.cos(lat1.toRad()) * Math.cos(lat2.toRad()) * Math.sin(dLon / 2) * Math.sin(dLon / 2);
      c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
      return R * c;
    };

    return Meter;

  })();

}).call(this);
