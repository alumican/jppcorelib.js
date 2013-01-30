// Generated by CoffeeScript 1.3.3

/*
	(c) 2013 Eikichi Yamaguchi
	kazitori.js may be freely distributed under the MIT license.
	http://dev.hageee.net

	fork from::
//     (c) 2010-2012 Jeremy Ashkenas, DocumentCloud Inc.
//     Backbone may be freely distributed under the MIT license.
//     For all details and documentation:
//     http://backbonejs.org
*/


(function() {
  var Deffered, EventDispatcher, Kazitori, delegater, escapeRegExp, namedParam, optionalParam, routeStripper, splatParam, trailingSlash,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  delegater = function(target, func) {
    return function() {
      return func.apply(target, arguments);
    };
  };

  trailingSlash = /\/$/;

  routeStripper = /^[#\/]|\s+$/g;

  escapeRegExp = /[\-{}\[\]+?.,\\\^$|#\s]/g;

  namedParam = /:\w+/g;

  optionalParam = /\((.*?)\)/g;

  splatParam = /\*\w+/g;

  /*
  # ほとんど Backbone.Router と Backbone.History から拝借。
  # jQuery や underscore に依存していないのでいろいろなライブラリと組み合わせられるはず。
  # もっと高級なことしたけりゃ素直に Backbone 使うことをおぬぬめ。
  #
  */


  Kazitori = (function() {

    Kazitori.prototype.VERSION = "0.1.3";

    Kazitori.prototype.history = null;

    Kazitori.prototype.location = null;

    Kazitori.prototype.handlers = [];

    Kazitori.prototype.beforeHandlers = [];

    Kazitori.prototype.afterhandlers = [];

    Kazitori.prototype.root = null;

    Kazitori.prototype.beforeAnytimeHandler = null;

    Kazitori.prototype.beforeFaildHandler = function() {};

    Kazitori.prototype.isBeforeForce = false;

    Kazitori.prototype.breaker = {};

    Kazitori.prototype._dispatcher = null;

    Kazitori.prototype._beforeDeffer = null;

    function Kazitori(options) {
      this.beforeFaild = __bind(this.beforeFaild, this);

      this.beforeComplete = __bind(this.beforeComplete, this);

      var docMode, win;
      this.options = options || (options = {});
      if (options.routes) {
        this.routes = options.routes;
      }
      this.root = options.root ? options.root : '/';
      win = window;
      if (typeof win !== 'undefined') {
        this.location = win.location;
        this.history = win.history;
      }
      docMode = document.docmentMode;
      this.isOldIE = (win.navigator.userAgent.toLowerCase().indexOf('msie') !== -1) && (!docMode || docMode < 7);
      this._dispatcher = new EventDispatcher();
      this._bindBefores();
      this._bindRules();
      if (__indexOf.call(options, "isAutoStart") < 0 || options["isAutoStart"] !== false) {
        this.start();
      }
      return;
    }

    Kazitori.prototype.start = function(options) {
      var atRoot, fragment, frame, win;
      if (Kazitori.started) {
        throw new Error('mou hazim matteru');
      }
      Kazitori.started = true;
      win = window;
      this.options = this._extend({}, {
        root: '/'
      }, this.options, options);
      this._hasPushState = !!(this.history && this.history.pushState);
      this._wantChangeHash = this.options.hashChange !== false;
      fragment = this.getFragment();
      atRoot = this.location.pathname.replace(/[^\/]$/, '$&/') === this.root;
      if (this.isOldIE && this._wantChangeHash) {
        frame = document.createElement("iframe");
        frame.setAttribute("src", "javascript:0");
        frame.setAttribute("tabindex", "-1");
        frame.style.display = "none";
        document.body.appendChild(frame);
        this.iframe = frame.contentWindow;
        this.change(fragment);
      }
      if (this._hasPushState === true) {
        win.addEventListener('popstate', delegater(this, this.observeURLHandler));
      } else if (this._wantChangeHash === true && (__indexOf.call(win, 'onhashchange') >= 0) && !this.isOldIE) {
        win.addEventListener('hashchange', delegater(this, this.observeURLHandler));
      }
      if (this._hasPushState && atRoot && this.location.hash) {
        this.fragment = this.getHash().replace(routeStripper, '');
        this.history.replaceState({}, document.title, this.root + this.fragment + this.location.search);
      }
      if (!this.options.silent) {
        return this.loadURL();
      }
    };

    Kazitori.prototype.stop = function() {
      var win;
      win = window;
      win.removeEventListener('popstate', arguments.callee);
      return win.removeEventListener('hashchange', arguments.callee);
    };

    Kazitori.prototype.change = function(fragment, options) {
      var frag, next, prev, url;
      if (!Kazitori.started) {
        return false;
      }
      prev = this.fragment;
      if (!options) {
        options = {
          'trigger': options
        };
      }
      frag = this.getFragment(fragment || '');
      if (this.fragment === frag) {
        return;
      }
      this.fragment = frag;
      next = this.fragment;
      url = this.root + frag;
      if (this._hasPushState) {
        this.history[options.replace ? 'replaceState' : 'pushState']({}, document.title, url);
      } else if (this._wantChangeHash) {
        this._updateHash(this.location, frag, options.replace);
        if (this.iframe && (frag !== this.getFragment(this.getHash(this.iframe)))) {
          if (!options.replace) {
            this.iframe.document.open().close();
          }
          this._updateHash(this.iframe.location, frag, options.replace);
        }
      } else {
        return this.location.assign(url);
      }
      this._dispatcher.dispatchEvent({
        type: KazitoriEvent.CHANGE,
        prev: prev,
        next: next
      });
      this.loadURL(frag);
    };

    Kazitori.prototype.reject = function() {
      this.dispatchEvent({
        type: KazitoriEvent.REJECT
      });
      this._beforeDeffer.removeEventListener(KazitoriEvent.TASK_QUEUE_COMPLETE, this.beforeComplete);
      this._beforeDeffer.removeEventListener(KazitoriEvent.TASK_QUEUE_FAILD, this.beforeFaild);
      this._beforeDeffer = null;
    };

    Kazitori.prototype.registHandler = function(rule, name, isBefore, callback) {
      var orgRule, target;
      orgRule = null;
      if (typeof rule !== RegExp) {
        orgRule = rule;
        rule = this._ruleToRegExp(rule);
      }
      if (!callback) {
        callback = isBefore ? this._bindFunctions(name) : this[name];
      }
      target = isBefore ? this.beforeHandlers : this.handlers;
      target.unshift({
        rule: rule,
        orgRule: orgRule,
        callback: this._binder(function(fragment) {
          var args;
          args = this._extractParams(rule, fragment);
          return callback && callback.apply(this, args);
        }, this)
      });
      return this;
    };

    Kazitori.prototype.loadURL = function(fragmentOverride) {
      var fragment, handler, matched, y, _i, _len, _ref,
        _this = this;
      fragment = this.fragment = this.getFragment(fragmentOverride);
      matched = [];
      this._beforeDeffer = new Deffered();
      this._beforeDeffer.queue = [];
      this._beforeDeffer.index = -1;
      if (this.beforeAnytimeHandler != null) {
        this._beforeDeffer.deffered(function(d) {
          _this.beforeAnytimeHandler.callback(fragment);
          d.execute(d);
        });
      }
      y = 0;
      _ref = this.beforeHandlers;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        handler = _ref[_i];
        if (handler.rule.test(fragment) === true) {
          this._beforeDeffer.deffered(function(d) {
            handler.callback(fragment);
            d.execute(d);
          });
        }
      }
      this._beforeDeffer.addEventListener(KazitoriEvent.TASK_QUEUE_COMPLETE, this.beforeComplete);
      this._beforeDeffer.addEventListener(KazitoriEvent.TASK_QUEUE_FAILD, this.beforeFaild);
      return this._beforeDeffer.execute(this._beforeDeffer);
    };

    Kazitori.prototype.beforeComplete = function(event) {
      var handler, matched, _i, _len, _ref;
      this._beforeDeffer.removeEventListener(KazitoriEvent.TASK_QUEUE_COMPLETE, this.beforeComplete);
      this._beforeDeffer.removeEventListener(KazitoriEvent.TASK_QUEUE_FAILD, this.beforeFaild);
      matched = [];
      this._beforeDeffer.queue = [];
      this._beforeDeffer.index = -1;
      _ref = this.handlers;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        handler = _ref[_i];
        console.log(handler.orgRule, this.fragment);
        if (handler.orgRule === this.fragment) {
          handler.callback(this.fragment);
          matched.push(true);
          return matched;
        }
        if (handler.rule.test(this.fragment)) {
          handler.callback(this.fragment);
          matched.push(true);
        }
      }
      return matched;
    };

    Kazitori.prototype.beforeFaild = function(event) {
      this.beforeFaildHandler.apply(this, arguments);
      if (this.isBeforeForce) {
        this.beforeComplete();
      }
      return this._beforeDeffer = null;
    };

    Kazitori.prototype.observeURLHandler = function(event) {
      var current;
      current = this.getFragment();
      if (current === this.fragment && this.iframe) {
        current = this.getFragment(this.getHash(this.iframe));
      }
      if (current === this.fragment) {
        return false;
      }
      if (this.iframe) {
        this.change(current);
      }
      return this.loadURL() || this.loadURL(this.getHash());
    };

    Kazitori.prototype._bindRules = function() {
      var routes, rule, _i, _len;
      if (!(this.routes != null)) {
        return;
      }
      routes = this._keys(this.routes);
      for (_i = 0, _len = routes.length; _i < _len; _i++) {
        rule = routes[_i];
        this.registHandler(rule, this.routes[rule], false);
      }
    };

    Kazitori.prototype._bindBefores = function() {
      var befores, callback, key, _i, _len;
      if (!(this.befores != null)) {
        return;
      }
      befores = this._keys(this.befores);
      for (_i = 0, _len = befores.length; _i < _len; _i++) {
        key = befores[_i];
        this.registHandler(key, this.befores[key], true);
      }
      if (this.beforeAnytime) {
        callback = this._bindFunctions(this.beforeAnytime);
        this.beforeAnytimeHandler = {
          callback: this._binder(function(fragment) {
            var args;
            args = [fragment];
            return callback && callback.apply(this, args);
          }, this)
        };
      }
    };

    Kazitori.prototype._updateHash = function(location, fragment, replace) {
      var href;
      if (replace) {
        href = location.href.replace(/(javascript:|#).*$/, '');
        location.replace(href + '#' + fragment);
      } else {
        location.hash = "#" + fragment;
      }
    };

    Kazitori.prototype.getFragment = function(fragment) {
      var root;
      if (!(fragment != null)) {
        if (this._hasPushState || !this._wantChangeHash) {
          fragment = this.location.pathname;
          root = this.root.replace(trailingSlash, '');
          if (!fragment.indexOf(root)) {
            fragment = fragment.substr(root.length);
          }
        } else {
          fragment = this.getHash();
        }
      }
      return fragment.replace(routeStripper, '');
    };

    Kazitori.prototype.getHash = function() {
      var match;
      match = (window || this).location.href.match(/#(.*)$/);
      if (match != null) {
        return match[1];
      } else {
        return '';
      }
    };

    Kazitori.prototype._extractParams = function(rule, fragment) {
      var param;
      param = rule.exec(fragment);
      if (param != null) {
        return param.slice(1);
      } else {
        return null;
      }
    };

    Kazitori.prototype._ruleToRegExp = function(rule) {
      var newRule;
      newRule = rule.replace(escapeRegExp, '\\$&').replace(optionalParam, '(?:$1)?').replace(namedParam, '([^\/]+)').replace(splatParam, '(.*?)');
      return new RegExp('^' + newRule + '$');
    };

    Kazitori.prototype.addEventListener = function(type, listener) {
      return this._dispatcher.addEventListener(type, listener);
    };

    Kazitori.prototype.removeEventListener = function(type, listener) {
      return this._dispatcher.removeEventListener(type, listener);
    };

    Kazitori.prototype.dispatchEvent = function(event) {
      return this._dispatcher.dispatchEvent(event);
    };

    Kazitori.prototype._slice = Array.prototype.slice;

    Kazitori.prototype._keys = Object.keys || function(obj) {
      var key, keys;
      if (obj === !Object(obj)) {
        throw new TypeError('object ja nai');
      }
      keys = [];
      for (key in obj) {
        if (Object.hasOwnProperty.call(obj, key)) {
          keys[keys.length] = key;
        }
      }
      return keys;
    };

    Kazitori.prototype._binder = function(func, obj) {
      var args, slice;
      slice = this._slice;
      args = slice.call(arguments, 2);
      return function() {
        return func.apply(obj || {}, args.concat(slice.call(arguments)));
      };
    };

    Kazitori.prototype._extend = function(obj) {
      this._each(this._slice.call(arguments, 1), function(source) {
        var prop, _results;
        if (source) {
          _results = [];
          for (prop in source) {
            _results.push(obj[prop] = source[prop]);
          }
          return _results;
        }
      });
      return obj;
    };

    Kazitori.prototype._each = function(obj, iter, ctx) {
      var each, i, k, l;
      if (!(obj != null)) {
        return;
      }
      each = Array.prototype.forEach;
      if (each && obj.forEach === each) {
        return obj.forEach(iter, ctx);
      } else if (obj.length === +obj.length) {
        i = 0;
        l = obj.length;
        while (i < l) {
          if (iter.call(ctx, obj[i], i, obj) === this.breaker) {
            return;
          }
          i++;
        }
      } else {
        for (k in obj) {
          if (__indexOf.call(obj, k) >= 0) {
            if (iter.call(ctx, obj[k], k, obj) === this.breaker) {
              return;
            }
          }
        }
      }
    };

    Kazitori.prototype._bindFunctions = function(funcs) {
      var bindedFuncs, callback, f, func, funcName, i, len, names, newF, _i, _len;
      if (typeof funcs === 'string') {
        funcs = funcs.split(',');
      }
      bindedFuncs = [];
      for (_i = 0, _len = funcs.length; _i < _len; _i++) {
        funcName = funcs[_i];
        func = this[funcName];
        if (!(func != null)) {
          names = funcName.split('.');
          if (names.length > 1) {
            f = window[names[0]];
            i = 1;
            len = names.length;
            while (i < len) {
              newF = f[names[i]];
              if (newF != null) {
                f = newF;
                i++;
              } else {
                break;
              }
            }
            func = f;
          } else {
            func = window[funcName];
          }
        }
        if (func != null) {
          bindedFuncs.push(func);
        }
      }
      callback = function(args) {
        var _j, _len1;
        for (_j = 0, _len1 = bindedFuncs.length; _j < _len1; _j++) {
          func = bindedFuncs[_j];
          func.apply(this, [args]);
        }
      };
      return callback;
    };

    return Kazitori;

  })();

  EventDispatcher = (function() {

    function EventDispatcher() {}

    EventDispatcher.prototype.listeners = {};

    EventDispatcher.prototype.addEventListener = function(type, listener) {
      if (this.listeners[type] === void 0) {
        this.listeners[type] = [];
      }
      if (this.listeners[type].indexOf(listener === -1)) {
        this.listeners[type].push(listener);
      }
    };

    EventDispatcher.prototype.removeEventListener = function(type, listener) {
      var index;
      index = this.listeners[type].indexOf(listener);
      if (index !== -1) {
        this.listeners[type].splice(index, 1);
      }
    };

    EventDispatcher.prototype.dispatchEvent = function(event) {
      var ary, handler, _i, _len;
      ary = this.listeners[event.type];
      if (ary !== void 0) {
        event.target = this;
        for (_i = 0, _len = ary.length; _i < _len; _i++) {
          handler = ary[_i];
          handler.call(this, event);
        }
      }
    };

    return EventDispatcher;

  })();

  Deffered = (function(_super) {

    __extends(Deffered, _super);

    Deffered.prototype.queue = [];

    Deffered.prototype.index = -1;

    function Deffered() {
      this.queue = [];
      this.index = -1;
    }

    Deffered.prototype.deffered = function(func) {
      this.queue.push(func);
      return this;
    };

    Deffered.prototype.execute = function() {
      this.index++;
      try {
        if (this.queue[this.index]) {
          this.queue[this.index].apply(this, arguments);
          if (this.queue.length === this.index) {
            this.queue = [];
            this.index = -1;
            return this.dispatchEvent({
              type: KazitoriEvent.TASK_QUEUE_COMPLETE
            });
          }
        }
      } catch (error) {
        return this.reject(error);
      }
    };

    Deffered.prototype.reject = function(error) {
      return this.dispatchEvent({
        type: KazitoriEvent.TASK_QUEUE_FAILD,
        index: this.index,
        message: error.message
      });
    };

    return Deffered;

  })(EventDispatcher);

  (function(window) {
    var KazitoriEvent;
    KazitoriEvent = {};
    KazitoriEvent.TASK_QUEUE_COMPLETE = 'task_queue_complete';
    KazitoriEvent.TASK_QUEUE_FAILD = 'task_queue_faild';
    KazitoriEvent.CHANGE = 'change';
    KazitoriEvent.REJECT = 'reject';
    return window.KazitoriEvent = KazitoriEvent;
  })(window);

  Kazitori.started = false;

  window.Kazitori = Kazitori;

}).call(this);
