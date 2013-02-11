(function() {
  var AboutScene, App, ContactScene, DownloadScene, IndexScene, PageScene, UsageScene,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  jpp.util.Namespace('jpp.milkpack')["import"]('*');

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
      this.$header = $('#header');
      return this.$footer = $('#footer');
    };

    IndexScene.prototype._onHello = function() {
      return this.addCommand(new Parallel(new JqueryAnimate(this.$header, {
        opacity: '1'
      }, {
        duration: 500,
        easing: 'linear'
      }), new JqueryAnimate(this.$footer, {
        opacity: '1'
      }, {
        duration: 500,
        easing: 'linear'
      })));
    };

    IndexScene.prototype._onArrive = function() {
      return this.addCommand();
    };

    IndexScene.prototype._onLeave = function() {
      return this.addCommand();
    };

    IndexScene.prototype._onBye = function() {
      return this.addCommand(new Parallel(new JqueryAnimate(this.$header, {
        opacity: '0'
      }, {
        duration: 500,
        easing: 'linear'
      }), new JqueryAnimate(this.$footer, {
        opacity: '0'
      }, {
        duration: 500,
        easing: 'linear'
      })));
    };

    return IndexScene;

  })(Scene);

  PageScene = (function(_super) {

    __extends(PageScene, _super);

    function PageScene() {
      this._onBye = __bind(this._onBye, this);

      this._onLeave = __bind(this._onLeave, this);

      this._onArrive = __bind(this._onArrive, this);

      this._onHello = __bind(this._onHello, this);

      this._onInit = __bind(this._onInit, this);
      return PageScene.__super__.constructor.apply(this, arguments);
    }

    PageScene.prototype._onInit = function($page) {
      return this.$page = $page;
    };

    PageScene.prototype._onHello = function() {
      return this.addCommand(new JqueryAnimate(this.$page, {
        opacity: '1'
      }, {
        duration: 500,
        easing: 'linear'
      }));
    };

    PageScene.prototype._onArrive = function() {
      return this.addCommand();
    };

    PageScene.prototype._onLeave = function() {
      return this.addCommand();
    };

    PageScene.prototype._onBye = function() {
      return this.addCommand(new JqueryAnimate(this.$page, {
        opacity: '0'
      }, {
        duration: 500,
        easing: 'linear'
      }));
    };

    return PageScene;

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
      return AboutScene.__super__._onInit.call(this, $('#page_what'));
    };

    AboutScene.prototype._onHello = function() {
      return AboutScene.__super__._onHello.call(this);
    };

    AboutScene.prototype._onArrive = function() {};

    AboutScene.prototype._onLeave = function() {};

    AboutScene.prototype._onBye = function() {
      return AboutScene.__super__._onBye.call(this);
    };

    return AboutScene;

  })(PageScene);

  UsageScene = (function(_super) {

    __extends(UsageScene, _super);

    function UsageScene() {
      this._onBye = __bind(this._onBye, this);

      this._onLeave = __bind(this._onLeave, this);

      this._onArrive = __bind(this._onArrive, this);

      this._onHello = __bind(this._onHello, this);

      this._onInit = __bind(this._onInit, this);
      return UsageScene.__super__.constructor.apply(this, arguments);
    }

    UsageScene.prototype._onInit = function() {
      return UsageScene.__super__._onInit.call(this, $('#page_how'));
    };

    UsageScene.prototype._onHello = function() {
      return UsageScene.__super__._onHello.call(this);
    };

    UsageScene.prototype._onArrive = function() {};

    UsageScene.prototype._onLeave = function() {};

    UsageScene.prototype._onBye = function() {
      return UsageScene.__super__._onBye.call(this);
    };

    return UsageScene;

  })(PageScene);

  DownloadScene = (function(_super) {

    __extends(DownloadScene, _super);

    function DownloadScene() {
      this._onBye = __bind(this._onBye, this);

      this._onLeave = __bind(this._onLeave, this);

      this._onArrive = __bind(this._onArrive, this);

      this._onHello = __bind(this._onHello, this);

      this._onInit = __bind(this._onInit, this);
      return DownloadScene.__super__.constructor.apply(this, arguments);
    }

    DownloadScene.prototype._onInit = function(id) {
      return DownloadScene.__super__._onInit.call(this, $('#page_where'));
    };

    DownloadScene.prototype._onHello = function() {
      return DownloadScene.__super__._onHello.call(this);
    };

    DownloadScene.prototype._onArrive = function() {};

    DownloadScene.prototype._onLeave = function() {};

    DownloadScene.prototype._onBye = function() {
      return DownloadScene.__super__._onBye.call(this);
    };

    return DownloadScene;

  })(PageScene);

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
      return ContactScene.__super__._onInit.call(this, $('#page_who'));
    };

    ContactScene.prototype._onHello = function() {
      return ContactScene.__super__._onHello.call(this);
    };

    ContactScene.prototype._onArrive = function() {};

    ContactScene.prototype._onLeave = function() {};

    ContactScene.prototype._onBye = function() {
      return ContactScene.__super__._onBye.call(this);
    };

    return ContactScene;

  })(PageScene);

  App = (function(_super) {

    __extends(App, _super);

    function App() {
      return App.__super__.constructor.apply(this, arguments);
    }

    App.prototype.root = '/example/milkpack/';

    App.prototype.rootFile = 'index.html';

    App.prototype.routes = {
      '/': IndexScene,
      '/what': AboutScene,
      '/how': UsageScene,
      '/where': DownloadScene,
      '/who': ContactScene
    };

    App.prototype.onInit = function() {
      var _this = this;
      return $('.fragment').on("click", function(event) {
        event.preventDefault();
        return _this.goto(event.currentTarget.pathname);
      });
    };

    return App;

  })(Milkpack);

  $(document).ready(function() {
    return window.app = new App({
      isReleaseMode: false
    });
  });

}).call(this);
