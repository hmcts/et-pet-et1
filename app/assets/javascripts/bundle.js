(function e(t,n,r){function s(o,u){if(!n[o]){if(!t[o]){var a=typeof require=="function"&&require;if(!u&&a)return a(o,!0);if(i)return i(o,!0);var f=new Error("Cannot find module '"+o+"'");throw f.code="MODULE_NOT_FOUND",f}var l=n[o]={exports:{}};t[o][0].call(l.exports,function(e){var n=t[o][1][e];return s(n?n:e)},l,l.exports,e,t,n,r)}return n[o].exports}var i=typeof require=="function"&&require;for(var o=0;o<r.length;o++)s(r[o]);return s})({1:[function(require,module,exports){
var polyfillDetail = require('./polyfills/polyfill.details'),
  reveal = require('./modules/moj.reveal'),
  checkboxToggle = require('./modules/moj.checkbox-toggle'),
  selectedOption = require('./modules/moj.selected-option'),
  checkboxReveal = require('./modules/moj.checkbox-reveal'),
  formHintReveal = require('./modules/moj.reveal-hints'),
  nodeCloning    = require('./modules/moj.node-cloning');

},{"./modules/moj.checkbox-reveal":2,"./modules/moj.checkbox-toggle":3,"./modules/moj.node-cloning":4,"./modules/moj.reveal":6,"./modules/moj.reveal-hints":5,"./modules/moj.selected-option":7,"./polyfills/polyfill.details":8}],2:[function(require,module,exports){
/* Toggles content if checkbox is checked
*/
module.exports = (function() {
  $('.reveal-checkbox').each(function(i, container){
    var input = $(container).find('.input-reveal');
    input.change(function(){
      var checked = input.is(':checked');
      $(container).next('.panel-indent').toggleClass('toggle-content', !checked);
    });
  });
})();

},{}],3:[function(require,module,exports){
/* Toggles disabled groups of adjacent checkboxes
* assumes structure: .related-checkboxes-root + .related-checkboxes-collection
*/
module.exports = (function() {
  var rootCheckbox = $('.related-checkboxes-root'),
    toggleRootCheckbox = function(array, root) {
      var checkbox = root.find('input');
      return checkbox.prop({
        checked : array.length
      });
    },
    toggleCheckboxes = function(checked, array, val) {
      if(checked){
        return array.push(val);
      } else {
        return array.pop(array.indexOf(val));
      }
    };

  rootCheckbox.each(function(i, root) {
    var main = $(root),
      collection = main.next('.related-checkboxes-collection'),
      selectedArray = [],
      checkboxes = collection.find('input');

    main.on('change', function(){
      var checked = main.is(':checked');
      if(!checked){
        $.each(selectedArray, function(i,val){
          $(checkboxes[val]).prop('checked' , false);
        });
        selectedArray = [];
      }
    });

    checkboxes.each(function(index, el) {
      var checked,
        checkbox = $(el);
      checkbox.on('change', function() {
        checked = checkbox.is(':checked');
        toggleCheckboxes(checked, selectedArray, index);
        toggleRootCheckbox(selectedArray, main);
      });
    })
  });

})();

},{}],4:[function(require,module,exports){
module.exports = (function() {
  var cloneSection = function(section) {
    var clone    = section.clone(),
        span     = $('span.index', clone),
        inputs   = $('input', clone);

    span.text(parseInt(span.text(), 10) + 1);
    inputs.val('');
    inputs.each(incrementAttrs);
    clone.insertAfter(section);
  }

  var incrementAttrs = function(_, input) {
    var oldId = input.id;
    var id    = oldId.replace(/_(\d+)_/, function(_, i) {
      return '_' + (parseInt(i, 10) + 1) + '_'
    });

    input = $(input);

    var name = input.attr('name').replace(/\[(\d+)\]/, function(_, i) {
      return '[' + (parseInt(i, 10) + 1) + ']'
    });

    input.attr('name', name);
    input.attr('id', id);
  }

  $('input[type=number].toggle').show().bind('change', function(event) {
    var selector = $(event.target).data('target');

    while($('.' + selector).size() < event.target.value) {
      cloneSection($('.' + selector).last());
    }

    while($('.' + selector).size() > event.target.value) {
      $('.' + selector).last().remove();
    }
  });
})();

},{}],5:[function(require,module,exports){
// Reveals hidden hint text

module.exports = (function() {
  $('.field_with_hint').each(function(i, field){
    var container = $(field),
      trigger = container.find('.hint-reveal');
    if(container.length){
      var content = container.find('.toggle-content');
      trigger.on('click', function(){
        content.toggle();
      });
    }
  });
})();
},{}],6:[function(require,module,exports){
// Reveals hidden content
module.exports = (function() {
  var reveal = {
    init : function() {
      $('.form-group-reveal').each(function(i, group) {
        reveal.bindLabels(group);
      });
    },
    bindLabels: function(container) {
      var blocklabels = $(container).find('.block-label'),
        labels = blocklabels.find('label');

      labels.each(function(i, label){
        $(label).on('click', function(event){
          reveal.toggleState(labels);
        });
      });
    },
    toggleState: function(labels, target) {
      var checked;

      return labels.each(function(i, label){
        var input = $(label).find('input'),
          target = $(document.getElementById(input.attr('data-target'))),
          checked = input.is(':checked');

        if(checked) {
          target.show();
        } else {
          target.hide();
        }

      });
    }
  };

  reveal.init();

  return reveal;

})();

},{}],7:[function(require,module,exports){
/* Toggles selected option class
* .block-label > label > input
*/
module.exports = (function() {
  $('.options').each(function(i, container){
    var blocklabels = $(container).find('.block-label'),
      labels = blocklabels.find('label');

    labels.each(function(i, el){
      var label = $(el),
        input = label.find('input');
      input.on('change', function(){
        var checked = input.is(':checked');
        labels.removeClass('selected');
        label.toggleClass('selected', checked);
      });
    });
  });
})();
},{}],8:[function(require,module,exports){
module.exports = (function () {
  // <details> polyfill
  // http://caniuse.com/#feat=details

  // FF Support for HTML5's <details> and <summary>
  // https://bugzilla.mozilla.org/show_bug.cgi?id=591737

  // http://www.sitepoint.com/fixing-the-details-element/

  // Add event construct for modern browsers or IE
  // which fires the callback with a pre-converted target reference
  function addEvent(node, type, callback) {
    if (node.addEventListener) {
      node.addEventListener(type, function (e) {
        callback(e, e.target);
      }, false);
    } else if (node.attachEvent) {
      node.attachEvent('on' + type, function (e) {
        callback(e, e.srcElement);
      });
    }
  }

  // Handle cross-modal click events
  function addClickEvent(node, callback) {
    var keydown = false;
    addEvent(node, 'keydown', function () {
      keydown = true;
    });
    addEvent(node, 'keyup', function (e, target) {
      keydown = false;
      if (e.keyCode === 13) { callback(e, target); }
    });
    addEvent(node, 'click', function (e, target) {
      if (!keydown) { callback(e, target); }
    });
  }

  // Get the nearest ancestor element of a node that matches a given tag name
  function getAncestor(node, match) {
    do {
      if (!node || node.nodeName.toLowerCase() === match) {
        break;
      }
    } while (node = node.parentNode);

    return node;
  }

  // Create a started flag so we can prevent the initialisation
  // function firing from both DOMContentLoaded and window.onload
  var started = false;

  // Initialisation function
  function addDetailsPolyfill(list) {

    // If this has already happened, just return
    // else set the flag so it doesn't happen again
    if (started) {
      return;
    }
    started = true;

    // Get the collection of details elements, but if that's empty
    // then we don't need to bother with the rest of the scripting
    if ((list = document.getElementsByTagName('details')).length === 0) {
      return;
    }

    // else iterate through them to apply their initial state
    var n = list.length, i = 0;
    for (n; i < n; i++) {
      var details = list[i];

      // Detect native implementations
      details.__native = typeof(details.open) == 'boolean';

      // Save shortcuts to the inner summary and content elements
      details.__summary = details.getElementsByTagName('summary').item(0);
      details.__content = details.getElementsByTagName('div').item(0);

      // If the content doesn't have an ID, assign it one now
      // which we'll need for the summary's aria-controls assignment
      if (!details.__content.id) {
        details.__content.id = 'details-content-' + i;
      }

      // Add role=button to summary
      details.__summary.setAttribute('role', 'button');

      // Add aria-controls
      details.__summary.setAttribute('aria-controls', details.__content.id);

      // Set tabindex so the summary is keyboard accessible
      details.__summary.setAttribute('tabindex', '0');

      // Detect initial open/closed state
      var detailsAttr = details.hasAttribute('open');
      if (typeof detailsAttr !== 'undefined' && detailsAttr !== false) {
        details.__summary.setAttribute('aria-expanded', 'true');
        details.__content.setAttribute('aria-hidden', 'false');
      } else {
        details.__summary.setAttribute('aria-expanded', 'false');
        details.__content.setAttribute('aria-hidden', 'true');
        details.__content.style.display = 'none';
      }

      // Create a circular reference from the summary back to its
      // parent details element, for convenience in the click handler
      details.__summary.__details = details;

      // If this is not a native implementation, create an arrow
      // inside the summary, saving its reference as a summary property
      if (!details.__native) {
        var twisty = document.createElement('i');
        twisty.className = 'arrow arrow-closed';
        twisty.appendChild(document.createTextNode('\u25ba'));
        details.__summary.__twisty = details.__summary.insertBefore(twisty, details.__summary.firstChild);
      }
    }

    // Define a statechange function that updates aria-expanded and style.display
    // Also update the arrow position
    function statechange(summary) {

      // Update aria-expanded attribute on click
      var expanded = summary.__details.__summary.getAttribute('aria-expanded') == 'true';
      var hidden = summary.__details.__content.getAttribute('aria-hidden') == 'true';

      summary.__details.__summary.setAttribute('aria-expanded', (expanded ? 'false' : 'true'));
      summary.__details.__content.setAttribute('aria-hidden', (hidden ? 'false' : 'true'));
      summary.__details.__content.style.display = (expanded ? 'none' : 'block');

      if (summary.__twisty) {
        summary.__twisty.firstChild.nodeValue = (expanded ? '\u25ba' : '\u25bc');
        summary.__twisty.setAttribute('class', (expanded ? 'arrow arrow-closed' : 'arrow arrow-open'));
      }

      return true;
    }

    // Bind a click event to handle summary elements
    addClickEvent(document, function(e, summary) {
      if (!(summary = getAncestor(summary, 'summary'))) {
        return true;
      }
      return statechange(summary);
    });
  }

  // Bind two load events for modern and older browsers
  // If the first one fires it will set a flag to block the second one
  // but if it's not supported then the second one will fire
  addEvent(document, 'DOMContentLoaded', addDetailsPolyfill);
  addEvent(window, 'load', addDetailsPolyfill);

})();

},{}]},{},[1]);
