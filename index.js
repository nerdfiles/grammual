// Generated by CoffeeScript 1.11.1

/*
@fileOverview ./index.coffee
@description
Grammuelle.
 */

(function() {
  var Grammuelle, Operation, P, Parser, _, __fs__, __q__, async, capture_module, g, log, open;

  __fs__ = require('fs');

  __q__ = require('promise-defer');

  P = require('promise');

  log = console.log;

  _ = require('lodash');

  async = require('async');


  /*
  @internal
  @name int
   */

  String.prototype.int = function() {
    return parseInt(this, 10);
  };


  /*
  @internal
  @name capitalize
   */

  String.prototype.capitalize = function() {
    var capitalizedFirstCharOfName, firstCharRemoved;
    capitalizedFirstCharOfName = this.split('').reverse().pop().toUpperCase();
    firstCharRemoved = this.slice(1, this.length);
    return capitalizedFirstCharOfName + firstCharRemoved;
  };


  /*
  @name open
  @description
  Open a stylebook.
   */

  open = function(f) {
    var defer;
    if (f == null) {
      f = './__test__.scss';
    }
    defer = __q__();
    __fs__.readFile(f, 'utf-8', function(error, data) {
      defer.resolve(data);
    });
    return defer.promise;
  };


  /*
  @name capture_module
  @description
  Look for Do(...)
   */

  capture_module = function(view) {
    var m;
    if (m = view.match(/(\@include\s*(.*)\(\')(.*)(\')/)) {
      view = ("module[" + m.index + "]__") + m[3];
    }
    return view;
  };


  /*
  @class
  @name Parser
  @description
  Parser Contract Loader.
   */

  Parser = (function() {
    function Parser(parsers) {
      this.parsers = parsers;
    }

    Parser.prototype.contract = function(loaded, parser) {
      if (parser) {
        return parser(loaded || '');
      } else {
        return loaded;
      }
    };

    Parser.prototype.parse = function(content) {
      var c, list, view;
      c = content.split("\n");
      return list = (function() {
        var j, len, results;
        results = [];
        for (j = 0, len = c.length; j < len; j++) {
          view = c[j];
          results.push(this.ready(view));
        }
        return results;
      }).call(this);
    };

    Parser.prototype.ready = function(view) {
      var p;
      return p = this.parsers.reduce(this.contract, view);
    };

    return Parser;

  })();


  /*
  @class
  @name Operation
   */

  Operation = (function() {
    function Operation(op) {
      this.op = op;
      this.op;
    }

    return Operation;

  })();


  /*
  @class
  @name Grammuelle
   */

  Grammuelle = (function() {
    var p;

    p = new Parser([capture_module]);

    function Grammuelle() {}

    Grammuelle.prototype.getModules = function() {
      this.generate();
      return this.el;
    };

    Grammuelle.prototype.generate = function() {
      open().then(function(data) {
        var el, parseMap, psb;
        psb = p.parse(data);
        parseMap = _.filter(_.map(psb, function(d) {
          var c, classPosition, dirtyName, h, newComponentName, newModuleName, opname, privateClassPosition;
          opname = null;
          if (c = d.match(/module\[([0-9])\]\_\_(.*)/)) {
            h = c[1].int();
            classPosition = 0;
            privateClassPosition = 2;
            dirtyName = c[2];
            if (h === classPosition) {
              newModuleName = dirtyName.capitalize();
              opname = newModuleName;
            }
            if (h === privateClassPosition) {
              newComponentName = dirtyName.toLowerCase();
              opname = newComponentName;
            }
          }
          return {
            opname: opname,
            oppos: h
          };
        }));
        el = [];
        _.each(parseMap, function(q, i) {
          var ankh, classPosition, filename, privateClassPosition;
          filename = null;
          ankh = null;
          classPosition = 0;
          privateClassPosition = 2;
          open('./stylebook.grams').then(function(grams) {
            var INIT, INIT_SCOPE, INNER, INNER_SCOPE, NAME, NAME_SCOPE, defer, init, inner, named, newPrivateClassName;
            defer = __q__();
            ankh = grams;
            NAME = /%%SCSS_NAME%%/;
            NAME_SCOPE = /%%SCSS_NAME%%/g;
            INNER = /%%SCSS_INNER%%/;
            INNER_SCOPE = /%%SCSS_INNER%%/g;
            INIT = /%%SCSS_INIT_INNER%%/;
            INIT_SCOPE = /%%SCSS_INIT_INNER%%/g;
            inner = grams.match(INNER);
            init = grams.match(INIT);
            named = grams.match(NAME);
            if (init && q.oppos === privateClassPosition) {
              ankh = ankh.replace(INIT_SCOPE, q.opname);
            }
            if (inner) {
              newPrivateClassName = q.opname.capitalize();
              ankh = ankh.replace(INNER_SCOPE, newPrivateClassName);
            }
            if (named) {
              ankh = ankh.replace(NAME_SCOPE, q.opname);
              filename = q.opname;
            }
            return defer.resolve({
              schema: ankh,
              filename: filename
            });
          });
          return el.push(defer.promise);
        });
        return log(el);
      });
    };

    return Grammuelle;

  })();

  g = new Grammuelle;

}).call(this);