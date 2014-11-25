// state indicator
// CSS: set the z-index on a .state-indicator element
//      and change this value using media queries
//
//JS: publish the state on init
//    listen for resize and publish the state as it changes
module.exports = (function () {

  // polyfil
  var debounce = function (func, wait, immediate) {
    var timeout;
    return function () {
      var context = this,
        args = arguments;
      var later = function () {
        timeout = null;
        if (!immediate) func.apply(context, args);
      };
      var callNow = immediate && !timeout;
      clearTimeout(timeout);
      timeout = setTimeout(later, wait);
      if (callNow) func.apply(context, args);
    };
  };

  var stateIndicator = {
    states: {
      8001: 'mobile',
      8002: 'tablet',
      8003: 'desktop'
    }
  };
  var si = stateIndicator;

  si.init = function () {
    si.bindToResize();
    si.bindSubscribers();
  };

  si.bindToResize = function () {
    si.__lastDeviceState = si.__getDeviceState();
    var _supports_orientation = "onorientationchange" in window;
    var _orientation_event = _supports_orientation ? "orientationchange" : "resize";

    if (window.addEventListener) {
      window.addEventListener(_orientation_event, si.__handleOrientation, false);
    } else if (window.attachEvent) {
      window.attachEvent(_orientation_event, si.__handleOrientation);
    } else {
      window[_orientation_event] = si.__handleOrientation;
    }
  };

  si.bindSubscribers = function () {
    // Change event
    si.subscribe('/device-state/change/', function (event, state) {
      console.log('STATE CHANGE callback', state);
    });
  };

  si.subscribe = function (eventName, callback) {
    if ($.subscribe) {
      $.subscribe(eventName, callback);
    }
  };

  si.__init = function () {
    si.__createElement();
    si.__handleOrientation();
  };

  si.__handleOrientation = debounce(function () {
    si.__state = si.__getDeviceState();

    if (si.__state !== si.__lastDeviceState) {
      // Save the new state as current
      si.__lastDeviceState = si.__state;

      if ($.publish) {
        $.publish('/device-state/change/', [si.__state]);
        return;
      }
    }
  }, 20);

  si.__createElement = function () {
    // Create the state-indicator element
    si.indicator = document.createElement('div');
    si.indicator.className = 'state-indicator';
    document.body.appendChild(si.indicator);
    si.$indicator = $(si.indicator);
  };

  si.__getDeviceState = function () {
    var index = parseInt(si.$indicator.css('z-index'), 10);
    return si.states[index] || 'desktop';
  };

  si.__init();
  si.init();

  return stateIndicator;
})();
