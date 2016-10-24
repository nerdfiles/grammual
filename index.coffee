###
@fileOverview ./index.coffee
@description
Grammuelle.
###

__fs__ = require('fs')
__q__ = require('promise-defer')
P = require('promise')
log = console.log
_ = require('lodash')
async = require('async')
colors = require('colors')

###
@internal
@name int
###
String::int = () ->
  parseInt @, 10

###
@internal
@name capitalize
###
String::capitalize = () ->
  capitalizedFirstCharOfName = @split('')
    .reverse()
    .pop()
    .toUpperCase()
  firstCharRemoved = @slice(1, @length)
  (capitalizedFirstCharOfName + firstCharRemoved)


###
@name open
@description
Open a stylebook.
###

open = (f = './__test__.scss') ->
  defer = __q__()
  __fs__.readFile(f, 'utf-8', (error, data) ->
    defer.resolve data
    return
  )
  defer.promise

###
@name capture_module
@description
Look for Do(...)
###

capture_module = (view) ->
  if m = view.match /(\@include\s*(.*)\(\')(.*)(\')/
    view = "module[#{m.index}]__" + m[3]
  view


###
@class
@name Lexer
@description
Lexer Contract Loader.
###

class Lexer
  constructor: (@parsers) ->

  contract: (loaded, parser) ->
    if parser
      parser(loaded or '')
    else
      loaded
  parse: (content) ->
    c = content.split("\n")
    list = (@ready(view) for view in c)
  ready: (view) ->
    p = @parsers.reduce @contract, view


###
@class
@name Operation
###

class Operation
  constructor: (@op) ->
    @op


###
@class
@name Grammuelle
###

class Grammuelle

  p = new Lexer [capture_module]

  constructor: () ->

  generate: () ->
    defer = __q__()
    el = []

    open().then (data) ->
      psb = p.parse data

      parseMap = _.filter _.map psb, (d) ->
        opname = null
        if c = d.match /module\[([0-9])\]\_\_(.*)/
          h = c[1].int()
          classPosition = 0
          privateClassPosition = 2
          dirtyName = c[2]
          if h is classPosition
            newModuleName = dirtyName and dirtyName.capitalize()
            opname = newModuleName
          if h is privateClassPosition
            newComponentName = dirtyName and dirtyName.toLowerCase()
            opname = newComponentName
        opname: opname
        oppos: h

      oldgrams = null
      open('./stylebook.grams').then (grams) ->
        z = _.remove parseMap, (a) -> a.opname
        oldname = null
        obj = {}
        _.each z, (o) ->
          if o.hasOwnProperty('oppos')
            if o.oppos is 0
              obj[o.opname] = {}
              oldname = o.opname
            else
              obj[oldname][o.opname] = {}

        _.each obj, (a, i) ->
          key = i
          sub = a

          NAME = /%%SCSS_NAME%%/
          NAME_SCOPE = /%%SCSS_NAME%%/g
          named = grams.match NAME
          ankh = grams.replace(NAME_SCOPE, key)

          INNER = /%%SCSS_INNER%%/
          INNER_SCOPE = /%%SCSS_INNER%%/g
          inner = grams.match INNER
          ankh = ankh.replace(INNER_SCOPE, _.keys(a).join('').capitalize())

          INIT = /%%SCSS_INIT_INNER%%/
          INIT_SCOPE = /%%SCSS_INIT_INNER%%/g
          init = grams.match INIT
          ankh = ankh.replace(INIT_SCOPE, _.keys(a))

          el.push
            filename: key
            schema: ankh
        defer.resolve el

    defer.promise

g = new Grammuelle

g.generate().then (output) ->

  pathbase = './'
  ext = '.coffee'

  _.each output, (o, i) ->
    filepath = (pathbase + o.filename + ext)
    inputdata = o.schema
    __fs__.writeFile filepath, inputdata, (error) ->
      if error? then return log(error)
      else log "Saved #{o.filename}.coffee".rainbow


