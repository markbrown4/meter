(function() {

  window.$ = function(selector) {
    var $el;
    $el = document.querySelector(selector);
    if ($el) {
      $el.on = function(event, callback) {
        return $el.addEventListener(event, callback, false);
      };
      return $el;
    }
    return false;
  };

  window.emptyFn = function() {};

  window.months = 'Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec'.split(' ');

  Number.prototype.toRad = function() {
    return this * Math.PI / 180;
  };

}).call(this);
