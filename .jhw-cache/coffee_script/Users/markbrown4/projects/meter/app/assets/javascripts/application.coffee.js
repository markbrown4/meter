(function() {

  window.$body = document.body;

  window.onerror = function(msg, url, line) {
    return alert("" + line + ": " + msg);
  };

  window.onload = function() {
    var log, meter;
    setTimeout(function() {
      return window.scrollTo(0, 1);
    }, 1);
    switch (document.body.className) {
      case "index":
        log = new Log();
        log.render();
        return $('#reset').on('click', log.reset);
      case "new":
        meter = new Meter();
        $('#start').on('click', meter.toggle);
        return $('#save').on('click', meter.save);
    }
  };

}).call(this);
