
/*
Namespace
*/


(function() {
  var Arr, Break, Command, CommandList, CommandState, DoTweenJS, Easing, Err, Event, EventDispatcher, Func, JqueryAjax, JqueryAnimate, JqueryGet, JqueryPost, Listen, Namespace, Num, Obj, Parallel, Return, Serial, Trace, Tween, Wait, _NamespaceObject,
    __slice = [].slice,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  Namespace = (function() {

    function Namespace(path) {
      if (!Namespace._validatePath(path)) {
        return _printError("Namespace('" + path + "'), '" + path + "' is invalid.");
      }
      return new _NamespaceObject(path);
    }

    /*
    	STATIC PRIVATE MEMBER
    */


    Namespace._spaces = {};

    Namespace._separator = '.';

    Namespace._defaultScope = window;

    Namespace._regSeparator = Namespace._separator.match(/[\[\]\-^$.+*?{}\\]/) !== null ? "\\" + Namespace._separator : Namespace._separator;

    Namespace._regPath = new RegExp("^[0-9a-zA-Z]+(" + Namespace._regSeparator + "[0-9a-zA-Z]+)*$");

    /*
    	STATIC PRIVATE METHOD
    */


    Namespace._getSpace = function(path) {
      return Namespace._spaces[path];
    };

    Namespace._setSpace = function(path) {
      var _base, _ref;
      return (_ref = (_base = Namespace._spaces)[path]) != null ? _ref : _base[path] = {};
    };

    Namespace._existSpace = function(path) {
      return Namespace._spaces[path] != null;
    };

    Namespace._validatePath = function(path) {
      return (path != null) && Namespace._regPath.test(path);
    };

    Namespace._print = function(message) {
      return typeof console !== "undefined" && console !== null ? typeof console.log === "function" ? console.log(message) : void 0 : void 0;
    };

    Namespace._printError = function(func, message) {
      return Namespace._print("###ERROR### at " + func + " : " + message);
    };

    /*
    	STATIC PUBLIC METHOD
    */


    Namespace.enumerate = function() {
      return Namespace._print(Namespace._spaces);
    };

    return Namespace;

  })();

  /*
  NamespaceObject (Internal)
  */


  _NamespaceObject = (function() {

    function _NamespaceObject(path) {
      this._path = path;
      this._names = this._path.split(Namespace._separator);
      this._space = Namespace._getSpace(this._path);
      this._scope = Namespace._defaultScope;
    }

    /*
    	PUBLIC METHOD
    */


    _NamespaceObject.prototype.register = function(classname, object, ignoreConflict) {
      if (ignoreConflict == null) {
        ignoreConflict = false;
      }
      if (!((classname != null) && (object != null))) {
        Namespace._printError("Namespace('" + this._path + "').register", 'one of arguments is not defined');
        return this;
      }
      this._allocate();
      if (ignoreConflict || !(this._space[classname] != null)) {
        this._space[classname] = object;
        return this;
      }
      Namespace._printError("Namespace('" + this._path + "').register", "'" + classname + "' is already registered.");
      return this;
    };

    _NamespaceObject.prototype["import"] = function(classname) {
      var key, object, _i, _len, _ref;
      if (classname == null) {
        classname = '*';
      }
      this._allocate();
      if (classname === '*') {
        _ref = this._space;
        for (key in _ref) {
          object = _ref[key];
          this._extern(key);
        }
        return this;
      }
      if (classname instanceof Array) {
        for (_i = 0, _len = classname.length; _i < _len; _i++) {
          key = classname[_i];
          this._extern(key);
        }
        return this;
      }
      if (this._space[classname] != null) {
        this._extern(classname);
        return this;
      }
      Namespace._printError("Namespace('" + this._path + "').import", "'" + classname + "' is not defined");
      return this;
    };

    _NamespaceObject.prototype.exist = function() {
      return Namespace._existSpace(this._path);
    };

    _NamespaceObject.prototype.use = function() {
      var key, name, ns, object, _i, _len, _ref, _ref1, _ref2;
      this._allocate();
      ns = this._scope;
      _ref = this._names;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        name = _ref[_i];
        ns = (_ref1 = ns[name]) != null ? _ref1 : ns[name] = {};
      }
      _ref2 = this._space;
      for (key in _ref2) {
        object = _ref2[key];
        ns[key] = object;
      }
      return this;
    };

    _NamespaceObject.prototype.scope = function(scope) {
      if (scope == null) {
        scope = Namespace._defaultScope;
      }
      this._scope = scope;
      return this;
    };

    _NamespaceObject.prototype.getPath = function() {
      return this._path;
    };

    /*
    	PRIVATE MEMBER
    */


    _NamespaceObject.prototype._allocate = function() {
      var i, n, _results;
      if (Namespace._existSpace(this._path)) {
        return;
      }
      this._space = Namespace._setSpace(this._path);
      n = this._names.length;
      i = 1;
      _results = [];
      while (i < n) {
        Namespace._setSpace(this._names.slice(0, i).join('.'));
        _results.push(++i);
      }
      return _results;
    };

    _NamespaceObject.prototype._extern = function(classname) {
      return this._scope[classname] = this._space[classname];
    };

    return _NamespaceObject;

  })();

  Namespace('jpp.util').register('Namespace', Namespace).use();

  /*
  Error Util
  */


  Err = (function() {

    function Err() {}

    Err.build = function(at, text) {
      if (text == null) {
        text = '';
      }
      return new Error(("Error at " + at) + (text !== '' ? " : " + text : void 0));
    };

    Err["throw"] = function(at, text) {
      if (text == null) {
        text = '';
      }
      throw Err.build(at, text);
    };

    return Err;

  })();

  Namespace('jpp.util').register('Err', Err);

  /*
  Number Util
  */


  Num = (function() {

    function Num() {}

    Num.PI = Math.PI;

    Num.PI2 = Num.PI * 2;

    Num.PI_2 = Num.PI / 2;

    Num.PI_3 = Num.PI / 3;

    Num.PI_4 = Num.PI / 4;

    Num.PI_6 = Num.PI / 6;

    Num.toRadian = function(degree) {
      return degree * PI / 180;
    };

    Num.toDegree = function(radian) {
      return radian * 180 / PI;
    };

    Num.dist = function(dx, dy, squared) {
      if (squared == null) {
        squared = true;
      }
      if (squared) {
        return Math.sqrt(dx * dx + dy * dy);
      } else {
        return dx * dx + dy * dy;
      }
    };

    Num.dist2 = function(x0, y0, x1, y1, squared) {
      if (squared == null) {
        squared = true;
      }
      return dist(x1 - x0, y1 - y0, squared);
    };

    Num.map = function(value, srcMin, srcMax, dstMin, dstMax) {
      if (value < srcMin) {
        value = srcMin;
      }
      if (value > srcMax) {
        value = srcMax;
      }
      return (value - srcMin) * (dstMax - dstMin) / (srcMax - srcMin) + dstMin;
    };

    Num.internallyDividing = function(p1, p2, d1, d2) {
      if (p1 === p2) {
        return p1;
      } else {
        return (d2 * p1 + d1 * p2) / (d1 + d2);
      }
    };

    Num.externallyDividing = function(p1, p2, d1, d2) {
      if (p1 === p2) {
        return p1;
      } else {
        return (d2 * p1 - d1 * p2) / (d2 - d1);
      }
    };

    Num.sign = function(value) {
      var _ref;
      return (_ref = value < 0) != null ? _ref : -{
        1: 1
      };
    };

    Num.choose = function() {
      var args;
      args = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
      return args[Math.floor(Math.random() * args.length)];
    };

    Num.combine = function(value1, value2, ratio1, ratio2) {
      var t;
      if (ratio2 == null) {
        ratio2 = null;
      }
      if (ratio1 > 1) {
        if (ratio2 == null) {
          ratio2 = 1;
        }
      } else {
        if (ratio2 == null) {
          ratio2 = 1 - ratio1;
        }
      }
      t = ratio1 + ratio2;
      return value1 * ratio1 / t + value2 * (1 - ratio1 / t);
    };

    Num.range = function(min, max) {
      return Math.random() * (max - min) + min;
    };

    return Num;

  })();

  Namespace('jpp.util').register('Num', Num);

  /*
  Array Util
  */


  Arr = (function() {

    function Arr() {}

    Arr.sequence = function(size, start, step) {
      var a, i;
      if (start == null) {
        start = 0;
      }
      if (step == null) {
        step = 1;
      }
      a = [];
      i = 0;
      while (i < size) {
        a[i] = i * step;
        ++i;
      }
      return a;
    };

    Arr.choose = function(array, splice) {
      var index;
      if (splice == null) {
        splice = false;
      }
      index = Math.floor(Math.random() * array.length);
      if (splice) {
        return array.splice(index, 1)[0];
      } else {
        return array[index];
      }
    };

    Arr.shuffle = function(array, overwrite) {
      var i, n, t, tmp;
      if (overwrite == null) {
        overwrite = false;
      }
      if (overwrite) {
        array = array.concat();
      }
      i = n = array.length;
      while (i--) {
        t = Math.floor(Math.random() * i);
        tmp = array[i];
        array[i] = array[t];
        array[t] = tmp;
      }
      return array;
    };

    Arr.clone = function(array) {
      return array.concat();
    };

    return Arr;

  })();

  Namespace('jpp.util').register('Arr', Arr);

  /*
  Object Util
  */


  Obj = (function() {

    function Obj() {}

    Obj.clone = function(object) {
      var dst, key, value;
      dst = {};
      for (key in object) {
        value = object[key];
        dst[key] = value;
      }
      return dst;
    };

    return Obj;

  })();

  Namespace('jpp.util').register('Obj', Obj);

  /*
  Easing
  */


  Easing = (function() {
    /*
    	Linear
    */

    function Easing() {}

    Easing.Linear = function(x, t, b, c, d) {
      return c * t / d + b;
    };

    /*
    	Quad
    */


    Easing.easeInQuad = function(x, t, b, c, d) {
      return c * (t /= d) * t + b;
    };

    Easing.easeOutQuad = function(x, t, b, c, d) {
      return (-c) * (t /= d) * (t - 2) + b;
    };

    Easing.easeInOutQuad = function(x, t, b, c, d) {
      if ((t /= d / 2) < 1) {
        return c / 2 * t * t + b;
      }
      return (-c) / 2 * ((--t) * (t - 2) - 1) + b;
    };

    /*
    	Cubic
    */


    Easing.easeInCubic = function(x, t, b, c, d) {
      return c * (t /= d) * t * t + b;
    };

    Easing.easeOutCubic = function(x, t, b, c, d) {
      return c * ((t = t / d - 1) * t * t + 1) + b;
    };

    Easing.easeInOutCubic = function(x, t, b, c, d) {
      if ((t /= d / 2) < 1) {
        return c / 2 * t * t * t + b;
      }
      return c / 2 * ((t -= 2) * t * t + 2) + b;
    };

    /*
    	Quart
    */


    Easing.easeInQuart = function(x, t, b, c, d) {
      return c * (t /= d) * t * t * t + b;
    };

    Easing.easeOutQuart = function(x, t, b, c, d) {
      return (-c) * ((t = t / d - 1) * t * t * t - 1) + b;
    };

    Easing.easeInOutQuart = function(x, t, b, c, d) {
      if ((t /= d / 2) < 1) {
        return c / 2 * t * t * t * t + b;
      }
      return (-c) / 2 * ((t -= 2) * t * t * t - 2) + b;
    };

    /*
    	Quint
    */


    Easing.easeInQuint = function(x, t, b, c, d) {
      return c * (t /= d) * t * t * t * t + b;
    };

    Easing.easeOutQuint = function(x, t, b, c, d) {
      return c * ((t = t / d - 1) * t * t * t * t + 1) + b;
    };

    Easing.easeInOutQuint = function(x, t, b, c, d) {
      if ((t /= d / 2) < 1) {
        return c / 2 * t * t * t * t * t + b;
      }
      return c / 2 * ((t -= 2) * t * t * t * t + 2) + b;
    };

    /*
    	Sine
    */


    Easing.easeInSine = function(x, t, b, c, d) {
      return (-c) * Math.cos(t / d * (Math.PI / 2)) + c + b;
    };

    Easing.easeOutSine = function(x, t, b, c, d) {
      return c * Math.sin(t / d * (Math.PI / 2)) + b;
    };

    Easing.easeInOutSine = function(x, t, b, c, d) {
      return (-c) / 2 * (Math.cos(Math.PI * t / d) - 1) + b;
    };

    /*
    	Expo
    */


    Easing.easeInExpo = function(x, t, b, c, d) {
      if (t === 0) {
        return b;
      }
      return c * Math.pow(2, 10 * (t / d - 1)) + b;
    };

    Easing.easeOutExpo = function(x, t, b, c, d) {
      if (t === d) {
        return b + c;
      }
      return c * (-Math.pow(2, -10 * t / d) + 1) + b;
    };

    Easing.easeInOutExpo = function(x, t, b, c, d) {
      if (t === 0) {
        return b;
      }
      if (t === d) {
        return b + c;
      }
      if ((t /= d / 2) < 1) {
        return c / 2 * Math.pow(2, 10 * (t - 1)) + b;
      }
      return c / 2 * (-Math.pow(2, -10 * --t) + 2) + b;
    };

    /*
    	Circ
    */


    Easing.easeInCirc = function(x, t, b, c, d) {
      return (-c) * (Math.sqrt(1 - (t /= d) * t) - 1) + b;
    };

    Easing.easeOutCirc = function(x, t, b, c, d) {
      return c * Math.sqrt(1 - (t = t / d - 1) * t) + b;
    };

    Easing.easeInOutCirc = function(x, t, b, c, d) {
      if ((t /= d / 2) < 1) {
        return (-c) / 2 * (Math.sqrt(1 - t * t) - 1) + b;
      }
      return c / 2 * (Math.sqrt(1 - (t -= 2) * t) + 1) + b;
    };

    /*
    	Elastic
    */


    Easing.easeInElastic = function(x, t, b, c, d) {
      var a, p, s;
      s = 1.70158;
      p = 0;
      a = c;
      if (t === 0) {
        return b;
      }
      if ((t /= d) === 1) {
        return b + c;
      }
      if (p === 0) {
        p = d * 0.3;
      }
      if (a < Math.abs(c)) {
        a = c;
        s = p / 4;
      } else {
        s = p / (2 * Math.PI) * Math.asin(c / a);
      }
      return (-a * Math.pow(2, 10 * (t -= 1)) * Math.sin((t * d - s) * (2 * Math.PI) / p)) + b;
    };

    Easing.easeOutElastic = function(x, t, b, c, d) {
      var a, p, s;
      s = 1.70158;
      p = 0;
      a = c;
      if (t === 0) {
        return b;
      }
      if ((t /= d) === 1) {
        return b + c;
      }
      if (p === 0) {
        p = d * 0.3;
      }
      if (a < Math.abs(c)) {
        a = c;
        s = p / 4;
      } else {
        s = p / (2 * Math.PI) * Math.asin(c / a);
      }
      return a * Math.pow(2, -10 * t) * Math.sin((t * d - s) * (2 * Math.PI) / p) + c + b;
    };

    Easing.easeInOutElastic = function(x, t, b, c, d) {
      var a, p, s;
      s = 1.70158;
      p = 0;
      a = c;
      if (t === 0) {
        return b;
      }
      if ((t /= d / 2) === 2) {
        return b + c;
      }
      if (p === 0) {
        p = d * (0.3 * 1.5);
      }
      if (a < Math.abs(c)) {
        a = c;
        s = p / 4;
      } else {
        s = p / (2 * Math.PI) * Math.asin(c / a);
      }
      if (t < 1) {
        return -0.5 * (a * Math.pow(2, 10 * (t -= 1)) * Math.sin((t * d - s) * (2 * Math.PI) / p)) + b;
      }
      return a * Math.pow(2, -10 * (t -= 1)) * Math.sin((t * d - s) * (2 * Math.PI) / p) * 0.5 + c + b;
    };

    /*
    	Back
    */


    Easing.easeInBack = function(x, t, b, c, d, s) {
      if (s == null) {
        s = 1.70158;
      }
      return c * (t /= d) * t * ((s + 1) * t - s) + b;
    };

    Easing.easeOutBack = function(x, t, b, c, d, s) {
      if (s == null) {
        s = 1.70158;
      }
      return c * ((t = t / d - 1) * t * ((s + 1) * t + s) + 1) + b;
    };

    Easing.easeInOutBack = function(x, t, b, c, d, s) {
      if (s == null) {
        s = 1.70158;
      }
      if ((t /= d / 2) < 1) {
        return c / 2 * (t * t * (((s *= 1.525) + 1) * t - s)) + b;
      }
      return c / 2 * ((t -= 2) * t * (((s *= 1.525) + 1) * t + s) + 2) + b;
    };

    /*
    	Bounce
    */


    Easing.easeInBounce = function(x, t, b, c, d) {
      return c - Easing.easeOutBounce(x, d - t, 0, c, d) + b;
    };

    Easing.easeOutBounce = function(x, t, b, c, d) {
      if ((t /= d) < (1 / 2.75)) {
        return c * (7.5625 * t * t) + b;
      } else if (t < (2 / 2.75)) {
        return c * (7.5625 * (t -= 1.5 / 2.75) * t + 0.75) + b;
      } else if (t < (2.5 / 2.75)) {
        return c * (7.5625 * (t -= 2.25 / 2.75) * t + 0.9375) + b;
      } else {
        return c * (7.5625 * (t -= 2.625 / 2.75) * t + 0.984375) + b;
      }
    };

    Easing.easeInOutBounce = function(x, t, b, c, d) {
      if (t < d / 2) {
        return Easing.easeInBounce(x, t * 2, 0, c, d) * 0.5 + b;
      }
      return Easing.easeOutBounce(x, t * 2 - d, 0, c, d) * 0.5 + c * 0.5 + b;
    };

    return Easing;

  })();

  Namespace('jpp.util').register('Easing', Easing);

  /*
  Event
  	@type
  	@target
  	@data
  */


  Event = (function() {

    Event.COMPLETE = 'complete';

    Event.OPEN = 'open';

    Event.CLOSE = 'close';

    Event.ERROR = 'error';

    Event.CANCEL = 'cancel';

    Event.RESIZE = 'resize';

    Event.INIT = 'init';

    Event.CONNECT = 'connect';

    Event.PROGRESS = 'progress';

    Event.ADDED = 'added';

    Event.REMOVED = 'removed';

    Event.SELECT = 'select';

    Event.FOCUS = 'focus';

    Event.RENDER = 'render';

    function Event(type, target, extra) {
      this.type = type;
      this.target = target;
      this.extra = extra;
    }

    return Event;

  })();

  Namespace('jpp.event').register('Event', Event);

  /*
  AS3 like EventDispatcher
  */


  EventDispatcher = (function() {

    function EventDispatcher(target) {
      if (target == null) {
        target = null;
      }
      this._target = target != null ? target : this;
      this._listeners = {};
    }

    EventDispatcher.prototype.addEventListener = function(type, listener) {
      var l, _base, _i, _len, _ref, _ref1;
      if (typeof listener !== 'function') {
        return this;
      }
      if ((_ref = (_base = this._listeners)[type]) == null) {
        _base[type] = [];
      }
      _ref1 = this._listeners[type];
      for (_i = 0, _len = _ref1.length; _i < _len; _i++) {
        l = _ref1[_i];
        if (l === listener) {
          return this;
        }
      }
      this._listeners[type].push(listener);
      return this;
    };

    EventDispatcher.prototype.removeEventListener = function(type, listener) {
      var i, l, _i, _len, _ref;
      if (!this.hasEventListener(type)) {
        return this;
      }
      _ref = this._listeners[type];
      for (i = _i = 0, _len = _ref.length; _i < _len; i = ++_i) {
        l = _ref[i];
        if (l === listener) {
          this._listeners[type].splice(i, 1);
        }
      }
      if (this._listeners[type].length === 0) {
        delete this._listeners[type];
      }
      return this;
    };

    EventDispatcher.prototype.removeAllEventListeners = function(type) {
      if (type == null) {
        type = '';
      }
      if (type === '') {
        this._listeners = {};
      } else {
        delete this._listeners[type];
      }
      return this;
    };

    EventDispatcher.prototype.hasEventListener = function(type) {
      return this._listeners[type] != null;
    };

    EventDispatcher.prototype.dispatchEvent = function(type, extra) {
      var event, l, _i, _len, _ref;
      if (extra == null) {
        extra = null;
      }
      if (!this.hasEventListener(type)) {
        return this;
      }
      event = new Event(type, this._target, extra);
      _ref = this._listeners[type];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        l = _ref[_i];
        l.call(this._target, event);
      }
      return this;
    };

    return EventDispatcher;

  })();

  Namespace('jpp.event').register('EventDispatcher', EventDispatcher);

  /*
  CommandState
  */


  CommandState = (function() {

    function CommandState() {}

    CommandState.SLEEPING = 0;

    CommandState.EXECUTING = 1;

    CommandState.INTERRUPTING = 2;

    return CommandState;

  })();

  Namespace('jpp.command').register('CommandState', CommandState);

  /*
  Command
  */


  Command = (function(_super) {

    __extends(Command, _super);

    /*
    	Constructor
    */


    function Command(executeFunction, interruptFunction, destroyFunction) {
      if (executeFunction == null) {
        executeFunction = null;
      }
      if (interruptFunction == null) {
        interruptFunction = null;
      }
      if (destroyFunction == null) {
        destroyFunction = null;
      }
      Command.__super__.constructor.call(this);
      this.setExecuteFunction(executeFunction);
      this.setInterruptFunction(interruptFunction);
      this.setDestroyFunction(destroyFunction);
      this._state = CommandState.SLEEPING;
      this._self = this;
      this._parent = null;
    }

    /*
    	Method
    */


    Command.prototype.execute = function() {
      if (this._state > CommandState.SLEEPING) {
        Err["throw"]('Command.execute', 'Command is already executing.');
      }
      this._state = CommandState.EXECUTING;
      this.getExecuteFunction().call(this, this);
      return this;
    };

    Command.prototype.interrupt = function() {
      if (this._state === CommandState.EXECUTING) {
        this._state = CommandState.INTERRUPTING;
        this.getInterruptFunction().call(this, this);
      }
      return this;
    };

    Command.prototype.destroy = function() {
      this._state = CommandState.SLEEPING;
      this.getDestroyFunction().call(this, this);
      this._parent = null;
      this.__executeFunction = null;
      this.__interruptFunction = null;
      this.__destroyFunction = null;
      return this;
    };

    Command.prototype.notifyComplete = function() {
      switch (this._state) {
        case CommandState.SLEEPING:
          return this;
        case CommandState.EXECUTING:
          this.dispatchEvent(Event.COMPLETE);
          this.destroy();
          return this;
        case CommandState.INTERRUPTING:
          this.dispatchEvent(Event.COMPLETE);
          this.destroy();
          return this;
      }
    };

    /*
    	Getter / Setter
    */


    Command.prototype.getExecuteFunction = function() {
      var _ref;
      return (_ref = this.__executeFunction) != null ? _ref : this._executeFunction;
    };

    Command.prototype.setExecuteFunction = function(f) {
      this.__executeFunction = f;
      return this;
    };

    Command.prototype.getInterruptFunction = function() {
      var _ref;
      return (_ref = this.__interruptFunction) != null ? _ref : this._interruptFunction;
    };

    Command.prototype.setInterruptFunction = function(f) {
      this.__interruptFunction = f;
      return this;
    };

    Command.prototype.getDestroyFunction = function() {
      var _ref;
      return (_ref = this.__destroyFunction) != null ? _ref : this._destroyFunction;
    };

    Command.prototype.setDestroyFunction = function(f) {
      this.__destroyFunction = f;
      return this;
    };

    Command.prototype.getState = function() {
      return this._state;
    };

    Command.prototype.getSelf = function() {
      return this._self;
    };

    Command.prototype.getParent = function() {
      return this._parent;
    };

    Command.prototype.setParent = function(parent) {
      return this._parent = parent;
    };

    /*
    	Protected
    */


    Command.prototype._executeFunction = function(command) {
      return this.notifyComplete();
    };

    Command.prototype._interruptFunction = function(command) {};

    Command.prototype._destroyFunction = function(command) {};

    return Command;

  })(EventDispatcher);

  Namespace('jpp.command').register('Command', Command);

  /*
  CommandList
  */


  CommandList = (function(_super) {

    __extends(CommandList, _super);

    /*
    	Constructor
    */


    function CommandList() {
      var commands;
      commands = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
      CommandList.__super__.constructor.call(this);
      this._commands = [];
      this.addCommand.apply(this, commands);
    }

    /*
    	Method
    */


    CommandList.prototype.addCommand = function() {
      var commands;
      commands = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
      if (commands.length > 0) {
        this._setParent(commands);
        this._commands = this.getCommands().concat(commands);
      }
      return this;
    };

    CommandList.prototype.insertCommand = function() {
      var commands, index;
      index = arguments[0], commands = 2 <= arguments.length ? __slice.call(arguments, 1) : [];
      if (commands.length > 0) {
        this._setParent(commands);
        Array.prototype.splice.apply(this.getCommands(), [index, 0].concat(commands));
      }
      return this;
    };

    CommandList.prototype.addCommandArray = function(commands) {
      this.addCommand.apply(this, commands);
      return this;
    };

    CommandList.prototype.insertCommandArray = function(index, commands) {
      this.insertCommand.apply(this, commands);
      return this;
    };

    CommandList.prototype._setParent = function(commands) {
      var c, i, _i, _len, _results;
      i = 0;
      _results = [];
      for (_i = 0, _len = commands.length; _i < _len; _i++) {
        c = commands[_i];
        if (typeof c === 'function') {
          commands[i] = c = new Func(c);
        }
        c.setParent(this);
        _results.push(++i);
      }
      return _results;
    };

    CommandList.prototype.notifyBreak = function() {};

    CommandList.prototype.notifyReturn = function() {};

    /*
    	Getter / Setter
    */


    CommandList.prototype.getCommandByIndex = function(index) {
      return this._commands[index];
    };

    CommandList.prototype.getCommands = function() {
      return this._commands;
    };

    CommandList.prototype.getLength = function() {
      return this._commands.length;
    };

    /*
    	Protected
    */


    CommandList.prototype._executeFunction = function(command) {
      return this.notifyComplete();
    };

    CommandList.prototype._interruptFunction = function(command) {};

    CommandList.prototype._destroyFunction = function(command) {
      return this._commands = [];
    };

    return CommandList;

  })(Command);

  Namespace('jpp.command').register('CommandList', CommandList);

  /*
  Serial
  */


  Serial = (function(_super) {

    __extends(Serial, _super);

    /*
    	Constructor
    */


    function Serial() {
      var commands;
      commands = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
      this._completeHandler = __bind(this._completeHandler, this);

      Serial.__super__.constructor.apply(this, commands);
      this._currentCommand = null;
      this._position = 0;
      this._isPaused = false;
      this._isCompleteOnPaused = false;
    }

    /*
    	Method
    */


    Serial.prototype.addCommand = function() {
      var commands;
      commands = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
      Serial.__super__.addCommand.apply(this, commands);
      return this;
    };

    Serial.prototype.insertCommand = function() {
      var commands;
      commands = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
      Serial.__super__.insertCommand.apply(this, [this._position + 1].concat(__slice.call(commands)));
      return this;
    };

    Serial.prototype._next = function() {
      this._currentCommand = this.getCommandByIndex(this._position);
      this._currentCommand.addEventListener(Event.COMPLETE, this._completeHandler);
      return this._currentCommand.execute();
    };

    Serial.prototype._completeHandler = function(event) {
      this._currentCommand.removeEventListener(Event.COMPLETE, this._completeHandler);
      this._currentCommand = null;
      if (++this._position >= this.getLength()) {
        return this.notifyComplete();
      } else {
        return this._next();
      }
    };

    Serial.prototype.notifyBreak = function() {
      var _ref;
      if (((_ref = this._currentCommand) != null ? _ref.getState() : void 0) === CommandState.EXECUTING) {
        this._currentCommand.removeEventListener(Event.COMPLETE, this._completeHandler);
        this._currentCommand.interrupt();
      }
      return this.notifyComplete();
    };

    Serial.prototype.notifyReturn = function() {
      var _ref, _ref1;
      if (((_ref = this._currentCommand) != null ? _ref.getState() : void 0) === CommandState.EXECUTING) {
        this._currentCommand.removeEventListener(Event.COMPLETE, this._completeHandler);
        this._currentCommand.interrupt();
      }
      if ((_ref1 = this.getParent()) != null) {
        _ref1.notifyReturn();
      }
      return this.destroy();
    };

    /*
    	Getter / Setter
    */


    Serial.prototype.getPosition = function() {
      return this._position;
    };

    /*
    	Protected
    */


    Serial.prototype._executeFunction = function(command) {
      this._position = 0;
      if (this.getLength() > 0) {
        return this._next();
      } else {
        return this.notifyComplete();
      }
    };

    Serial.prototype._interruptFunction = function(command) {
      if (this._currentCommand != null) {
        this._currentCommand.removeEventListener(Event.COMPLETE, this._completeHandler);
        this._currentCommand.interrupt();
      }
      this._currentCommand = null;
      this._position = 0;
      return Serial.__super__._interruptFunction.call(this, command);
    };

    Serial.prototype._destroyFunction = function(command) {
      if (this._currentCommand != null) {
        this._currentCommand.removeEventListener(Event.COMPLETE, this._completeHandler);
        this._currentCommand.destroy();
      }
      this._currentCommand = null;
      this._position = 0;
      this._isPaused = false;
      this._isCompleteOnPaused = false;
      return Serial.__super__._destroyFunction.call(this, command);
    };

    return Serial;

  })(CommandList);

  Namespace('jpp.command').register('Serial', Serial);

  /*
  Parallel
  */


  Parallel = (function(_super) {

    __extends(Parallel, _super);

    /*
    	Constructor
    */


    function Parallel() {
      var commands;
      commands = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
      this._completeHandler = __bind(this._completeHandler, this);

      Parallel.__super__.constructor.apply(this, commands);
      this._completeCount = 0;
    }

    /*
    	Method
    */


    Parallel.prototype.addCommand = function() {
      var commands;
      commands = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
      Parallel.__super__.addCommand.apply(this, commands);
      return this;
    };

    Parallel.prototype.insertCommand = function() {
      var commands;
      commands = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
      Parallel.__super__.insertCommand.apply(this, [this.getLength()].concat(__slice.call(commands)));
      return this;
    };

    Parallel.prototype._completeHandler = function(event) {
      if (++this._completeCount >= this.getLength()) {
        return this.notifyComplete();
      }
    };

    Parallel.prototype.notifyBreak = function() {
      var c, _i, _len, _ref;
      _ref = this.getCommands();
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        c = _ref[_i];
        if (c.getState() === CommandState.EXECUTING) {
          c.removeEventListener(Event.COMPLETE, this._completeHandler);
          c.interrupt();
        }
      }
      return this.notifyComplete();
    };

    Parallel.prototype.notifyReturn = function() {
      var c, _i, _len, _ref, _ref1;
      _ref = this.getCommands();
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        c = _ref[_i];
        if (c.getState() === CommandState.EXECUTING) {
          c.removeEventListener(Event.COMPLETE, this._completeHandler);
          c.interrupt();
        }
      }
      if ((_ref1 = this.getParent()) != null) {
        _ref1.notifyReturn();
      }
      return this.destroy();
    };

    /*
    	Getter / Setter
    */


    Parallel.prototype.getCompleteCount = function() {
      return this._completeCount;
    };

    /*
    	Protected
    */


    Parallel.prototype._executeFunction = function(command) {
      var c, _i, _len, _ref, _results;
      this._completeCount = 0;
      _ref = this.getCommands();
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        c = _ref[_i];
        c.addEventListener(Event.COMPLETE, this._completeHandler);
        _results.push(c.execute());
      }
      return _results;
    };

    Parallel.prototype._interruptFunction = function(command) {
      var c, _i, _len, _ref;
      _ref = this.getCommands();
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        c = _ref[_i];
        c.removeEventListener(Event.COMPLETE, this._completeHandler);
        c.interrupt();
      }
      return Parallel.__super__._interruptFunction.call(this, command);
    };

    Parallel.prototype._destroyFunction = function(command) {
      var c, _i, _len, _ref;
      _ref = this.getCommands();
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        c = _ref[_i];
        c.removeEventListener(Event.COMPLETE, this._completeHandler);
        c.destroy();
      }
      this._completeCount = 0;
      return Parallel.__super__._destroyFunction.call(this, command);
    };

    return Parallel;

  })(CommandList);

  Namespace('jpp.command').register('Parallel', Parallel);

  /*
  Break Command
  */


  Break = (function(_super) {

    __extends(Break, _super);

    /*
    	Constructor
    */


    function Break() {
      Break.__super__.constructor.call(this);
    }

    /*
    	Method
    */


    /*
    	Getter / Setter
    */


    /*
    	Protected
    */


    Break.prototype._executeFunction = function(command) {
      var _ref;
      if ((_ref = this.getParent()) != null) {
        _ref.notifyBreak();
      }
      return this.notifyComplete();
    };

    Break.prototype._interruptFunction = function(command) {};

    Break.prototype._destroyFunction = function(command) {};

    return Break;

  })(Command);

  Namespace('jpp.command').register('Break', Break);

  /*
  Return Command
  */


  Return = (function(_super) {

    __extends(Return, _super);

    /*
    	Constructor
    */


    function Return() {
      Return.__super__.constructor.call(this);
    }

    /*
    	Method
    */


    /*
    	Getter / Setter
    */


    /*
    	Protected
    */


    Return.prototype._executeFunction = function(command) {
      var _ref;
      if ((_ref = this.getParent()) != null) {
        _ref.notifyReturn();
      }
      return this.notifyComplete();
    };

    Return.prototype._interruptFunction = function(command) {};

    Return.prototype._destroyFunction = function(command) {};

    return Return;

  })(Command);

  Namespace('jpp.command').register('Return', Return);

  /*
  Func Command
  */


  Func = (function(_super) {

    __extends(Func, _super);

    /*
    	Constructor
    */


    function Func(func, args, dispatcher, eventType) {
      if (func == null) {
        func = null;
      }
      if (args == null) {
        args = [];
      }
      if (dispatcher == null) {
        dispatcher = null;
      }
      if (eventType == null) {
        eventType = null;
      }
      this._completeHandler = __bind(this._completeHandler, this);

      Func.__super__.constructor.call(this);
      this._func = func;
      this._args = args;
      this._dispatcher = dispatcher;
      this._eventType = eventType;
    }

    /*
    	Method
    */


    Func.prototype._completeHandler = function(event) {
      return this.notifyComplete();
    };

    /*
    	Getter / Setter
    */


    Func.prototype.getFunction = function() {
      return this._func;
    };

    Func.prototype.setFunction = function(func) {
      this._func = func;
      return this;
    };

    Func.prototype.getArguments = function() {
      return this._args;
    };

    Func.prototype.setArguments = function(args) {
      this._args = args;
      return this;
    };

    /*
    	Protected
    */


    Func.prototype._executeFunction = function(command) {
      if ((this._dispatcher != null) && (this._eventType != null)) {
        this._dispatcher.addEventListener(this._eventType, this._completeHandler);
        return typeof this._func === "function" ? this._func.apply(this, this._args) : void 0;
      } else {
        if (typeof this._func === "function") {
          this._func.apply(this, this._args);
        }
        return this.notifyComplete();
      }
    };

    Func.prototype._interruptFunction = function(command) {
      if ((this._dispatcher != null) && (this._eventType != null)) {
        return this._dispatcher.removeEventListener(this._eventType, this._completeHandler);
      }
    };

    Func.prototype._destroyFunction = function(command) {
      this._func = null;
      this._args = null;
      this._dispatcher = null;
      return this._eventType = null;
    };

    return Func;

  })(Command);

  Namespace('jpp.command').register('Func', Func);

  /*
  Trace Command
  */


  Trace = (function(_super) {

    __extends(Trace, _super);

    /*
    	Constructor
    */


    function Trace(message) {
      Trace.__super__.constructor.call(this);
      this._message = message;
    }

    /*
    	Method
    */


    /*
    	Getter / Setter
    */


    Trace.prototype.getMessage = function() {
      return this._message;
    };

    Trace.prototype.setMessage = function(message) {
      this._message = message;
      return this;
    };

    /*
    	Protected
    */


    Trace.prototype._executeFunction = function(command) {
      console.log(this._message);
      return this.notifyComplete();
    };

    Trace.prototype._interruptFunction = function(command) {};

    Trace.prototype._destroyFunction = function(command) {
      return this._message = null;
    };

    return Trace;

  })(Command);

  Namespace('jpp.command').register('Trace', Trace);

  /*
  Wait Command
  */


  Wait = (function(_super) {

    __extends(Wait, _super);

    /*
    	Constructor
    */


    function Wait(time) {
      if (time == null) {
        time = 1;
      }
      this._completeHandler = __bind(this._completeHandler, this);

      Wait.__super__.constructor.call(this);
      this._time = time;
      this._timeoutId = -1;
    }

    /*
    	Method
    */


    Wait.prototype._cancel = function() {
      if (this._timeoutId !== -1) {
        clearTimeout(this._timeoutId);
      }
      return this._timeoutId = -1;
    };

    Wait.prototype._completeHandler = function(event) {
      return this.notifyComplete();
    };

    /*
    	Getter / Setter
    */


    Wait.prototype.getTime = function() {
      return this._time;
    };

    Wait.prototype.setTime = function(time) {
      this._time = time;
      return this;
    };

    /*
    	Protected
    */


    Wait.prototype._executeFunction = function(command) {
      return this._timeoutId = setTimeout(this._completeHandler, this._time * 1000);
    };

    Wait.prototype._interruptFunction = function(command) {
      return this._cancel();
    };

    Wait.prototype._destroyFunction = function(command) {
      return this._cancel();
    };

    return Wait;

  })(Command);

  Namespace('jpp.command').register('Wait', Wait);

  /*
  Listen Command
  */


  Listen = (function(_super) {

    __extends(Listen, _super);

    /*
    	Constructor
    */


    function Listen(type, dispatcher) {
      if (type == null) {
        type = null;
      }
      if (dispatcher == null) {
        dispatcher = null;
      }
      this._handler = __bind(this._handler, this);

      Listen.__super__.constructor.call(this);
      this._type = type;
      this._dispatcher = dispatcher;
    }

    /*
    	Method
    */


    Listen.prototype._handler = function(event) {
      return this.notifyComplete();
    };

    /*
    	Getter / Setter
    */


    Listen.prototype.getType = function() {
      return this._type;
    };

    Listen.prototype.setType = function(type) {
      this._type = type;
      return this;
    };

    Listen.prototype.getDispatcher = function() {
      return this._dispatcher;
    };

    Listen.prototype.setDispatcher = function(dispatcher) {
      this._dispatcher = dispatcher;
      return this;
    };

    /*
    	Protected
    */


    Listen.prototype._executeFunction = function(command) {
      var _ref;
      if (this._type != null) {
        return (_ref = this._dispatcher) != null ? _ref.addEventListener(this._type, this._handler) : void 0;
      }
    };

    Listen.prototype._interruptFunction = function(command) {
      var _ref;
      if (this._type != null) {
        return (_ref = this._dispatcher) != null ? _ref.removeEventListener(this._type, this._handler) : void 0;
      }
    };

    Listen.prototype._destroyFunction = function(command) {
      var _ref;
      if (this._type != null) {
        if ((_ref = this._dispatcher) != null) {
          _ref.removeEventListener(this._type, this._handler);
        }
      }
      this._type = null;
      return this._dispatcher = null;
    };

    return Listen;

  })(Command);

  Namespace('jpp.command').register('Listen', Listen);

  /*
  Tween Command
  */


  Tween = (function(_super) {

    __extends(Tween, _super);

    /*
    	Constructor
    */


    function Tween(target, to, from, time, easing, onStart, onUpdate, onComplete) {
      if (from == null) {
        from = null;
      }
      if (time == null) {
        time = 1;
      }
      if (easing == null) {
        easing = Easing.Linear;
      }
      if (onStart == null) {
        onStart = null;
      }
      if (onUpdate == null) {
        onUpdate = null;
      }
      if (onComplete == null) {
        onComplete = null;
      }
      this._intervalHandler = __bind(this._intervalHandler, this);

      Tween.__super__.constructor.call(this);
      this._target = target;
      this._to = to;
      this._from = from;
      this._time = time;
      this._easing = easing;
      this._onStart = onStart;
      this._onUpdate = onUpdate;
      this._onComplete = onComplete;
      this._intervalId = -1;
      this._tRatio = 0;
      this._vRatio = 0;
      this._startTime;
    }

    /*
    	Method
    */


    Tween.prototype._cancel = function() {
      if (this._intervalId !== -1) {
        clearInterval(this._intervalId);
      }
      return this._intervalId = -1;
    };

    Tween.prototype._apply = function(ratio) {
      var key, value0, value1, _ref, _results;
      this._tRatio = ratio;
      this._vRatio = this._easing(0, this._tRatio, 0, 1, 1);
      _ref = this._to;
      _results = [];
      for (key in _ref) {
        value1 = _ref[key];
        value0 = this._from[key];
        _results.push(this._target[key] = value0 + (value1 - value0) * this._vRatio);
      }
      return _results;
    };

    Tween.prototype._intervalHandler = function(event) {
      var t;
      t = (new Date().getTime() - this._startTime) / 1000;
      if (t < this._time) {
        this._apply(t / this._time);
        return typeof this._onUpdate === "function" ? this._onUpdate() : void 0;
      } else {
        this._apply(1);
        if (typeof this._onUpdate === "function") {
          this._onUpdate();
        }
        if (typeof this._onComplete === "function") {
          this._onComplete();
        }
        this._cancel();
        return this.notifyComplete();
      }
    };

    /*
    	Getter / Setter
    */


    Tween.prototype.getTarget = function() {
      return this._target;
    };

    Tween.prototype.setTarget = function(target) {
      this._target = target;
      return this;
    };

    Tween.prototype.getTo = function() {
      return this._to;
    };

    Tween.prototype.setTo = function(to) {
      this._to = to;
      return this;
    };

    Tween.prototype.getFrom = function() {
      return this._from;
    };

    Tween.prototype.setFrom = function(from) {
      this._from = from;
      return this;
    };

    Tween.prototype.getTime = function() {
      return this._time;
    };

    Tween.prototype.setTime = function(time) {
      this._time = time;
      return this;
    };

    Tween.prototype.getEasing = function() {
      return this._easing;
    };

    Tween.prototype.setEasing = function(easing) {
      this._easing = easing;
      return this;
    };

    Tween.prototype.getOnStart = function() {
      return this._onStart;
    };

    Tween.prototype.setOnStart = function(onStart) {
      this._onStart = onStart;
      return this;
    };

    Tween.prototype.getOnUpdate = function() {
      return this._onUpdate;
    };

    Tween.prototype.setOnUpdate = function(onUpdate) {
      this._onUpdate = onUpdate;
      return this;
    };

    Tween.prototype.getOnComplete = function() {
      return this._onComplete;
    };

    Tween.prototype.setOnComplete = function(onComplete) {
      this._onComplete = onComplete;
      return this;
    };

    Tween.prototype.getRatio = function() {
      return this._vRatio;
    };

    Tween.prototype.getTimeRatio = function() {
      return this._tRatio;
    };

    /*
    	Protected
    */


    Tween.prototype._executeFunction = function(command) {
      var key, value1, _base, _ref, _ref1, _ref2;
      if ((_ref = this._from) == null) {
        this._from = {};
      }
      _ref1 = this._to;
      for (key in _ref1) {
        value1 = _ref1[key];
        if ((_ref2 = (_base = this._from)[key]) == null) {
          _base[key] = this._target[key];
        }
      }
      if (this._time > 0) {
        this._intervalId = setInterval(this._intervalHandler, 10);
        this._startTime = new Date().getTime();
        this._apply(0);
        return typeof this._onStart === "function" ? this._onStart() : void 0;
      } else {
        this._apply(0);
        if (typeof this._onStart === "function") {
          this._onStart();
        }
        this._apply(1);
        if (typeof this._onUpdate === "function") {
          this._onUpdate();
        }
        if (typeof this._onComplete === "function") {
          this._onComplete();
        }
        return this.notifyComplete();
      }
    };

    Tween.prototype._interruptFunction = function(command) {
      return this._cancel();
    };

    Tween.prototype._destroyFunction = function(command) {
      return this._cancel();
    };

    return Tween;

  })(Command);

  Namespace('jpp.command').register('Tween', Tween);

  /*
  jQuery.ajax Command
  */


  JqueryAjax = (function(_super) {

    __extends(JqueryAjax, _super);

    /*
    	Constructor
    */


    function JqueryAjax(options) {
      if (options == null) {
        options = null;
      }
      this._completeHandler = __bind(this._completeHandler, this);

      JqueryAjax.__super__.constructor.call(this);
      this._options = options != null ? options : {};
      this._status = '';
      this._isSucceed = false;
    }

    /*
    	Method
    */


    JqueryAjax.prototype._completeHandler = function(XMLHttpRequest, status) {
      var _base;
      console.log(this);
      this._status = status;
      this._isSucceed = status === 'success';
      if (typeof (_base = this._options).complete === "function") {
        _base.complete(XMLHttpRequest, status);
      }
      if (this.getState() === CommandState.EXECUTING) {
        return this.notifyComplete();
      }
    };

    /*
    	Getter / Setter
    */


    JqueryAjax.prototype.getOptions = function() {
      return this._options;
    };

    JqueryAjax.prototype.setOptions = function(options) {
      this._options = options;
      return this;
    };

    JqueryAjax.prototype.getUrl = function() {
      return this._options.url;
    };

    JqueryAjax.prototype.setUrl = function(url) {
      this._options.url = url;
      return this;
    };

    JqueryAjax.prototype.getMethod = function() {
      return this._options.type;
    };

    JqueryAjax.prototype.setMethod = function(method) {
      this._options.type = method;
      return this;
    };

    JqueryAjax.prototype.getData = function() {
      return this._options.data;
    };

    JqueryAjax.prototype.setData = function(data) {
      this._options.data = data;
      return this;
    };

    JqueryAjax.prototype.getDataType = function() {
      return this._options.dataType;
    };

    JqueryAjax.prototype.setDataType = function(dataType) {
      this._options.dataType = dataType;
      return this;
    };

    JqueryAjax.prototype.getOnSuccess = function() {
      return this._options.success;
    };

    JqueryAjax.prototype.setOnSuccess = function(callback) {
      this._options.success = callback;
      return this;
    };

    JqueryAjax.prototype.getOnError = function() {
      return this._options.error;
    };

    JqueryAjax.prototype.setOnError = function(callback) {
      this._options.error = callback;
      return this;
    };

    JqueryAjax.prototype.getOnComplete = function() {
      return this._options.complete;
    };

    JqueryAjax.prototype.setOnComplete = function(callback) {
      this._options.complete = callback;
      return this;
    };

    JqueryAjax.prototype.getStatus = function() {
      return this._status;
    };

    JqueryAjax.prototype.getIsSucceed = function() {
      return this._isSucceed;
    };

    /*
    	Protected
    */


    JqueryAjax.prototype._executeFunction = function(command) {
      var key, p, value, _ref;
      p = {};
      _ref = this._options;
      for (key in _ref) {
        value = _ref[key];
        p[key] = value;
      }
      p.complete = this._completeHandler;
      return jQuery.ajax(p);
    };

    JqueryAjax.prototype._interruptFunction = function(command) {
      return this;
    };

    JqueryAjax.prototype._destroyFunction = function(command) {
      this._options = null;
      this._status = '';
      return this._isSucceed = false;
    };

    return JqueryAjax;

  })(Command);

  Namespace('jpp.command').register('JqueryAjax', JqueryAjax);

  /*
  jQuery.get Command
  */


  JqueryGet = (function(_super) {

    __extends(JqueryGet, _super);

    /*
    	Constructor
    */


    function JqueryGet(url, data, onSuccess, onError, dataType) {
      if (url == null) {
        url = null;
      }
      if (data == null) {
        data = null;
      }
      if (onSuccess == null) {
        onSuccess = null;
      }
      if (onError == null) {
        onError = null;
      }
      if (dataType == null) {
        dataType = null;
      }
      JqueryGet.__super__.constructor.call(this, {
        type: 'get',
        url: url,
        data: data,
        success: onSuccess,
        error: onError,
        dataType: dataType
      });
    }

    /*
    	Method
    */


    /*
    	Getter / Setter
    */


    /*
    	Protected
    */


    return JqueryGet;

  })(JqueryAjax);

  Namespace('jpp.command').register('JqueryGet', JqueryGet);

  /*
  jQuery.post Command
  */


  JqueryPost = (function(_super) {

    __extends(JqueryPost, _super);

    /*
    	Constructor
    */


    function JqueryPost(url, data, onSuccess, onError, dataType) {
      if (url == null) {
        url = null;
      }
      if (data == null) {
        data = null;
      }
      if (onSuccess == null) {
        onSuccess = null;
      }
      if (onError == null) {
        onError = null;
      }
      if (dataType == null) {
        dataType = null;
      }
      JqueryPost.__super__.constructor.call(this, {
        type: 'post',
        url: url,
        data: data,
        success: onSuccess,
        error: onError,
        dataType: dataType
      });
    }

    /*
    	Method
    */


    /*
    	Getter / Setter
    */


    /*
    	Protected
    */


    return JqueryPost;

  })(JqueryAjax);

  Namespace('jpp.command').register('JqueryPost', JqueryPost);

  /*
  JqueryAnimate Command
  */


  JqueryAnimate = (function(_super) {

    __extends(JqueryAnimate, _super);

    /*
    	Constructor
    */


    function JqueryAnimate(target, params, options) {
      if (options == null) {
        options = null;
      }
      this._completeHandler = __bind(this._completeHandler, this);

      JqueryAnimate.__super__.constructor.call(this);
      this._target = target;
      this._params = params;
      this._options = options;
      this._isTweening = false;
    }

    /*
    	Method
    */


    JqueryAnimate.prototype._completeHandler = function() {
      var p;
      p = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
      this._isTweening = false;
      if (this._originalComplete !== null) {
        this._originalComplete.apply(this._target, p);
      }
      return this.notifyComplete();
    };

    JqueryAnimate.prototype._cancel = function() {
      if (!this._isTweening) {
        return;
      }
      this._isTweening = false;
      return this._target.stop();
    };

    /*
    	Getter / Setter
    */


    JqueryAnimate.prototype.getTarget = function() {
      return this._target;
    };

    JqueryAnimate.prototype.setTarget = function(target) {
      this._target = target;
      return this;
    };

    JqueryAnimate.prototype.getParams = function() {
      return this._params;
    };

    JqueryAnimate.prototype.setParams = function(params) {
      this._params = params;
      return this;
    };

    JqueryAnimate.prototype.getOptions = function() {
      return this._options;
    };

    JqueryAnimate.prototype.setOptions = function(options) {
      this._options = options;
      return this;
    };

    /*
    	Protected
    */


    JqueryAnimate.prototype._executeFunction = function(command) {
      var options, _ref;
      if (this._isTweening) {
        return;
      }
      this._isTweening = true;
      this._originalComplete = (_ref = this._options.complete) != null ? _ref : null;
      options = Obj.clone(this._options);
      options.complete = this._completeHandler;
      return this._target.animate(this._params, options);
    };

    JqueryAnimate.prototype._interruptFunction = function(command) {
      return this._cancel();
    };

    JqueryAnimate.prototype._destroyFunction = function(command) {
      return this._cancel();
    };

    return JqueryAnimate;

  })(Command);

  Namespace('jpp.command').register('JqueryAnimate', JqueryAnimate);

  /*
  DoTweenJS Command
  */


  DoTweenJS = (function(_super) {

    __extends(DoTweenJS, _super);

    /*
    	Constructor
    */


    function DoTweenJS(tweenProvider) {
      this._completeHandler = __bind(this._completeHandler, this);
      DoTweenJS.__super__.constructor.call(this);
      this._tweenProvider = tweenProvider;
    }

    /*
    	Method
    */


    DoTweenJS.prototype._completeHandler = function(tween) {
      this._cancel();
      return this.notifyComplete();
    };

    DoTweenJS.prototype._cancel = function() {
      return this._tween.pause(this._tween);
    };

    /*
    	Getter / Setter
    */


    DoTweenJS.prototype.getTween = function() {
      return this._tween;
    };

    DoTweenJS.prototype.setTween = function(tween) {
      this._tween = tween;
      return this;
    };

    /*
    	Protected
    */


    DoTweenJS.prototype._executeFunction = function(command) {
      this._tween = this._tweenProvider();
      this._tween.loop = false;
      this._tween.call(this._completeHandler);
      return this._tween.play(this._tween);
    };

    DoTweenJS.prototype._interruptFunction = function(command) {
      return this._cancel();
    };

    DoTweenJS.prototype._destroyFunction = function(command) {
      return this._cancel();
    };

    return DoTweenJS;

  })(Command);

  Namespace('jpp.command').register('DoTweenJS', DoTweenJS);

}).call(this);
