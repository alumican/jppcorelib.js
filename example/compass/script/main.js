(function() {
  var AboutScene, App, ContactScene, GalleryItemScene, GalleryScene, IndexScene,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    __slice = [].slice;

  jpp.util.Namespace('jpp.compass')["import"]('*');

  jpp.util.Namespace('jpp.command')["import"]('*');

  IndexScene = (function(_super) {

    __extends(IndexScene, _super);

    function IndexScene() {
      this._onBye = __bind(this._onBye, this);

      this._onLeave = __bind(this._onLeave, this);

      this._onArrive = __bind(this._onArrive, this);

      this._onHello = __bind(this._onHello, this);

      this._onInit = __bind(this._onInit, this);
      return IndexScene.__super__.constructor.apply(this, arguments);
    }

    IndexScene.prototype._onInit = function() {
      console.log('init index scene');
      console.log("  rule     = '" + (this.getRule()) + "'");
      console.log("  fragment = '" + (this.getFragment()) + "'");
      return console.log("  param    = [" + (this.getParams().join(', ')) + "]");
    };

    IndexScene.prototype._onHello = function() {
      return this.addCommand(new Wait(1), new Trace('index hello complete'));
    };

    IndexScene.prototype._onArrive = function() {
      return this.addCommand(new Wait(1), new Trace('index arrive complete'));
    };

    IndexScene.prototype._onLeave = function() {
      return this.addCommand(new Wait(1), new Trace('index leave complete'));
    };

    IndexScene.prototype._onBye = function() {
      return this.addCommand(new Wait(1), new Trace('index bye complete'));
    };

    return IndexScene;

  })(Scene);

  AboutScene = (function(_super) {

    __extends(AboutScene, _super);

    function AboutScene() {
      this._onBye = __bind(this._onBye, this);

      this._onLeave = __bind(this._onLeave, this);

      this._onArrive = __bind(this._onArrive, this);

      this._onHello = __bind(this._onHello, this);

      this._onInit = __bind(this._onInit, this);
      return AboutScene.__super__.constructor.apply(this, arguments);
    }

    AboutScene.prototype._onInit = function() {
      console.log('init about scene');
      console.log("  rule     = '" + (this.getRule()) + "'");
      console.log("  fragment = '" + (this.getFragment()) + "'");
      return console.log("  param    = [" + (this.getParams().join(', ')) + "]");
    };

    AboutScene.prototype._onHello = function() {};

    AboutScene.prototype._onArrive = function() {};

    AboutScene.prototype._onLeave = function() {};

    AboutScene.prototype._onBye = function() {};

    return AboutScene;

  })(Scene);

  GalleryScene = (function(_super) {

    __extends(GalleryScene, _super);

    function GalleryScene() {
      this._onBye = __bind(this._onBye, this);

      this._onLeave = __bind(this._onLeave, this);

      this._onArrive = __bind(this._onArrive, this);

      this._onHello = __bind(this._onHello, this);

      this._onInit = __bind(this._onInit, this);
      return GalleryScene.__super__.constructor.apply(this, arguments);
    }

    GalleryScene.prototype._onInit = function() {
      console.log('init gallery scene');
      console.log("  rule     = '" + (this.getRule()) + "'");
      console.log("  fragment = '" + (this.getFragment()) + "'");
      return console.log("  param    = [" + (this.getParams().join(', ')) + "]");
    };

    GalleryScene.prototype._onHello = function() {};

    GalleryScene.prototype._onArrive = function() {};

    GalleryScene.prototype._onLeave = function() {};

    GalleryScene.prototype._onBye = function() {};

    return GalleryScene;

  })(Scene);

  GalleryItemScene = (function(_super) {

    __extends(GalleryItemScene, _super);

    function GalleryItemScene() {
      this._onBye = __bind(this._onBye, this);

      this._onLeave = __bind(this._onLeave, this);

      this._onArrive = __bind(this._onArrive, this);

      this._onHello = __bind(this._onHello, this);

      this._onInit = __bind(this._onInit, this);
      return GalleryItemScene.__super__.constructor.apply(this, arguments);
    }

    GalleryItemScene.prototype._onInit = function(id) {
      console.log('init gallery item scene');
      console.log("  rule     = '" + (this.getRule()) + "'");
      console.log("  fragment = '" + (this.getFragment()) + "'");
      return console.log("  param    = [" + (this.getParams().join(', ')) + "]");
    };

    GalleryItemScene.prototype._onHello = function() {};

    GalleryItemScene.prototype._onArrive = function() {};

    GalleryItemScene.prototype._onLeave = function() {};

    GalleryItemScene.prototype._onBye = function() {};

    return GalleryItemScene;

  })(Scene);

  ContactScene = (function(_super) {

    __extends(ContactScene, _super);

    function ContactScene() {
      this._onBye = __bind(this._onBye, this);

      this._onLeave = __bind(this._onLeave, this);

      this._onArrive = __bind(this._onArrive, this);

      this._onHello = __bind(this._onHello, this);

      this._onInit = __bind(this._onInit, this);
      return ContactScene.__super__.constructor.apply(this, arguments);
    }

    ContactScene.prototype._onInit = function() {
      console.log('init contact scene');
      console.log("  rule     = '" + (this.getRule()) + "'");
      console.log("  fragment = '" + (this.getFragment()) + "'");
      return console.log("  param    = [" + (this.getParams().join(', ')) + "]");
    };

    ContactScene.prototype._onHello = function() {};

    ContactScene.prototype._onArrive = function() {};

    ContactScene.prototype._onLeave = function() {};

    ContactScene.prototype._onBye = function() {};

    return ContactScene;

  })(Scene);

  /*
  Application
  */


  App = (function(_super) {

    __extends(App, _super);

    function App() {
      this._clickHandler = __bind(this._clickHandler, this);
      return App.__super__.constructor.apply(this, arguments);
    }

    App.prototype.root = '/example/compass/';

    App.prototype.rootFile = 'index.html';

    App.prototype.routes = {
      '/': IndexScene,
      '/about/<int:n>/<string:s>': AboutScene,
      '/gallery': GalleryScene,
      '/gallery/<int:id>': GalleryItemScene,
      '/contact': ContactScene
    };

    App.prototype.onInit = function() {
      /*
      		@getScene('/')
      			.setHello(
      				new Wait(1),
      				new Trace('index hello complete')
      			)
      			.setArrive(
      				new Wait(1),
      				new Trace('index arrive complete')
      			)
      			.setLeave(
      				new Wait(1),
      				new Trace('index leave complete')
      			)
      			.setBye(
      				new Wait(1),
      				new Trace('index bye complete')
      			)
      */

    };

    App.prototype.onSceneRequest = function() {
      var fragment, params;
      fragment = arguments[0], params = 2 <= arguments.length ? __slice.call(arguments, 1) : [];
      console.log("onSceneRequest : fragment = '" + fragment + "', params = [" + (params.join(', ')) + "]");
      return null;
    };

    App.prototype._clickHandler = function(event) {
      event.preventDefault();
      return this.goto(event.currentTarget.pathname);
    };

    App.prototype.bind = function($target) {
      return $target.on("click", this._clickHandler);
    };

    App.prototype.unbind = function($target) {
      return $target.off("click", this._clickHandler);
    };

    return App;

  })(Compass);

  $(document).ready(function() {
    window.app = new App({
      isReleaseMode: false
    });
    return window.app.bind($('.navi'));
  });

}).call(this);
