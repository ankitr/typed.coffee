(function() {
  "use strict";
  var Typed;

  Typed = function(el, options) {
    this.el = $(el);
    this.options = $.extend({}, $.fn.typed.defaults, options);
    this.text = this.el.text();
    this.typeSpeed = this.options.typeSpeed;
    this.backDelay = this.options.backDelay;
    this.strings = this.options.strings;
    this.strPos = 0;
    this.arrayPos = 0;
    this.string = this.strings[this.arrayPos];
    this.stopNum = 0;
    this.loop = this.options.loop;
    this.loopCount = this.options.loopCount;
    this.curLoop = 1;
    if (this.loop === false) {
      this.stopArray = this.strings.length - 1;
    } else {
      this.stopArray = this.strings.length;
    }
    return this.build();
  };

  Typed.prototype = {
    constructor: Typed,
    init: function() {
      return this.typewrite(this.string, this.strPos);
    },
    build: function() {
      this.el.after("<span id=\"typed-cursor\">|</span>");
      return this.init();
    },
    typewrite: function(curString, curStrPos) {
      var humanize, self;
      humanize = Math.round(Math.random() * (100 - 30)) + this.typeSpeed;
      self = this;
      return setTimeout(function() {
        var clear;
        if (self.arrayPos < self.strings.length) {
          self.el.text(self.text + curString.substr(0, curStrPos));
          if (curStrPos > curString.length && self.arrayPos < self.stopArray) {
            clearTimeout(clear);
            return clear = setTimeout(function() {
              return self.backspace(curString, curStrPos);
            }, self.backDelay);
          } else {
            curStrPos++;
            self.typewrite(curString, curStrPos);
            if (self.loop === false) {
              if (self.arrayPos === self.stopArray && curStrPos === curString.length) {
                clear = self.options.callback();
                return clearTimeout(clear);
              }
            }
          }
        } else if (self.loop === true && self.loopCount === false) {
          self.arrayPos = 0;
          return self.init();
        } else if (self.loopCount !== false && self.curLoop < self.loopCount) {
          self.arrayPos = 0;
          self.curLoop = self.curLoop + 1;
          return self.init();
        }
      }, humanize);
    },
    backspace: function(curString, curStrPos) {
      var humanize, self;
      humanize = Math.round(Math.random() * (100 - 30)) + this.typeSpeed;
      self = this;
      return setTimeout(function() {
        var clear;
        self.el.text(self.text + curString.substr(0, curStrPos));
        if (curStrPos > self.stopNum) {
          curStrPos--;
          return self.backspace(curString, curStrPos);
        } else if (curStrPos <= self.stopNum) {
          clearTimeout(clear);
          clear = self.arrayPos = self.arrayPos + 1;
          return self.typewrite(self.strings[self.arrayPos], curStrPos);
        }
      }, humanize);
    }
  };

  $.fn.typed = function(option) {
    return this.each(function() {
      var $this, data, options;
      $this = $(this);
      data = $this.data('typed');
      options = typeof option === 'object' && option;
      if (!data) {
        $this.data('typed', (data = new Typed(this, options)));
      }
      if (typeof option === 'string') {
        data[option]();
        return true;
      }
    });
  };

  $.fn.typed.defaults = {
    strings: ["These are the default values...", "You know what you should do?", "Use your own!", "Have a great day!"],
    typeSpeed: 0,
    backDelay: 500,
    loop: false,
    loopCount: false,
    callback: function() {
      return null;
    }
  };

}).call(this);
