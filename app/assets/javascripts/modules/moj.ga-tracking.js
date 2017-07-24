var gaTracker = (function () {
  /**
   * Loading the GA JS.
   */
  (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
  (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
  m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
  })(window,document,'script','//www.google-analytics.com/analytics.js','ga');

  var tpl, utils, gaTracking;

  /**
   * Blue prints for Analytics Field objects
   * @type {Object}
   */
  tpl = {
    events: {
      'hitType': 'event', // Required - always ‘event’
      'eventAction': 'click', // Required - always ‘click’
      'eventCategory': '__default__', // Required - either ‘button;, ‘radio’ or ‘link’
      'eventLabel': '__default__' // Required (for us) - value from attribute or innerHTML
    }
  };

  // Util methods
  utils = {
    pageURL: window.location.pathname + window.location.search,
    /**
     * Extract the correct values from different types of elements
     * using the tagName property of the element.
     */
    events: {
      A: function (elm) {
        return {
          eventCategory: 'link',
          eventLabel: elm.innerHTML
        };
      },
      INPUT: function (elm) {
        return {
          eventCategory: elm.type,
          eventLabel: (elm.type === 'submit' ? elm.value : elm.id)
        };
      },
      BUTTON: function (elm) {
        return {
          eventCategory: elm.type,
          eventLabel: elm.innerHTML
        };
      }
    },

    /**
     * Return the field object to pass to the `ga` function
     * with the correct data extracted from the DOM
     * @param  { HTMLElement }  elm
     * @return { Object }
     */
    getEventsDataObj: function (elm) {
      return $.extend({}, tpl.events, utils.events[elm.tagName](elm));
    },

    /**
     * Return the field object to pass to the `ga` function
     * with the correct data extracted from the DOM
     * @param  { HTMLElement } elm
     * @return { Object }
     */
    getPageViewDataObj: function (elm) {
      return {
        'hitType': 'pageview',
        'page': 'reveal-' + elm.id,
        'title': 'reveal'
      };
    },

    /**
     * Check for the `ga` method and Analytics ID
     * @return { boolean }
     */
    sendGaRequest: function () {
      return (gaTracking.gaID && typeof ga === 'function');
    },

    /**
     * Closure to bind click events
     * @param  { jQuery     HMTLElement } $elm
     * @param  { object }   gaData        Analytics Field Object
     */
    clickEvent: function ($elm, gaData) {
      return (function () {
        $elm.on('click', function () {
          gaTracking.gaProxy(gaData);
        });
      }());
    }
  };

  /**
   * Internal object
   * @type {Object}
   */
  gaTracking = {
    gaID: null
  };

  /**
   * Init method.
   */
  gaTracking.init = function () {
    gaTracking.pageView();
    gaTracking.errorMessageCheck();
  };

  /**
   * Proxy to Analytics call for custom tracking
   * @param  { object } gaData  Analytics Field Object
   */
  gaTracking.gaProxy = function (gaData) {
    if (utils.sendGaRequest()) {
      ga('send', gaData);
    }
  };

  /**
   * Analytics page view calls
   */
  gaTracking.pageView = function () {
    if (utils.sendGaRequest()) {
      ga('create', gaTracking.gaID, 'auto');

      if (utils.pageURL.indexOf('/apply/pay/') !== -1) {
        ga('set', 'referrer', ' ');
      }

      ga('send', 'pageview');
      ga('set', 'anonymizeIP', true);

    }
  };

  /**
   * Handle the virtual page view when the page has errors
   */
  gaTracking.errorMessageCheck = function () {
    $('#error-summary').is(function (idx, elm) {
      var gaData = {
        'hitType': 'pageview',
        'page': 'error-' + utils.pageURL,
        'title': 'error'
      };
      gaTracking.gaProxy(gaData);
    });
  };

  /**
   * Method to handle Virtual Page Views on click
   */
  gaTracking.gaVirtualPageViews = (function () {
    $('.ga-vpv').each(function (idx, elm) {
      var $elm = $(elm);
      utils.clickEvent($elm, utils.getPageViewDataObj(elm));
    });
  }());

  /**
   * Method to handle Custom Events on click
   */
  gaTracking.gaCustomEvents = (function () {
    $('.ga-event').each(function (idx, elm) {
      var $elm = $(elm);
      utils.clickEvent($elm, utils.getEventsDataObj(elm));
    });
  }());

  /**
   * Return an init method to allow the Google Analytics ID
   * to be set from the View
   */
  return {
    init: function (gaID) {
      gaTracking.gaID = gaID;
      gaTracking.init();
    }
  };
})();
