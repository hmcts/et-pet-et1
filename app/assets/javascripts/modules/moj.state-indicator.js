// state indicator
// This requires CSS media queries that
// update the z-index on div.state-indicator.
// The element will be created by the JS.
module.exports = (function () {

  // Debounce
  // http://davidwalsh.name/function-debounce
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

  // setting some defaults
  var stateIndicator = {
    states: {
      8001: 'mobile',
      8002: 'tablet',
      8003: 'desktop'
    },
    baseState: 'desktop'
  };

  // Just a little shorter to write
  var si = stateIndicator;

  si.init = function () {
    // create the element
    si.__createElement();

    // run the handler manually at start
    si.__handleOrientation();

    si.bindToResize();
  };

  // Bind to the resize / onorientationchange event
  si.bindToResize = function () {
    si.__lastDeviceState = si.getDeviceState();
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

  // Return the current state based on the
  // z-index for the hidden element
  // defaults to si.baseState
  si.getDeviceState = function () {
    var index = parseInt(si.$indicator.css('z-index'), 10);
    return si.states[index] || si.baseState;
  };

  si.__handleOrientation = debounce(function () {
    si.__state = si.getDeviceState();

    if (si.__state !== si.__lastDeviceState) {
      // Save the new state as current

      // Publishes two events:
      // - A state change occured (/device/change/)
      // - The to / from direction (/device/move/[fromState]/to/[toState])
      // - The actual state will be passed into the callback
      if ($.publish) {
        $.publish('/device/change/', [si.__state]);
        $.publish('/device/move/' + si.__lastDeviceState + '/to/' + si.__state + '/', [si.__state]);
      }
      si.__lastDeviceState = si.__state;
    }
  }, 20);

  si.__createElement = function () {
    // Create the state-indicator element
    si.indicator = document.createElement('div');
    si.indicator.className = 'state-indicator';
    document.body.appendChild(si.indicator);
    si.$indicator = $(si.indicator);
  };

  ////////////////
  // Init steps //
  ////////////////
  si.init();

  return stateIndicator;
})();
