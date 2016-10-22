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
@name Parser
@description
Parser Contract Loader.
###

class Parser
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

  p = new Parser [capture_module]

  constructor: () ->

  getModules: () ->
    @generate()
    @el

  generate: () ->

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
            newModuleName = dirtyName.capitalize()
            opname = newModuleName
          if h is privateClassPosition
            newComponentName = dirtyName.toLowerCase()
            opname = newComponentName
        opname: opname
        oppos: h

      _.each parseMap, (q, i) ->
        filename = null
        ankh = null
        classPosition = 0
        privateClassPosition = 2

        open('./stylebook.grams').then (grams) ->
          ankh = grams

          NAME = /%%SCSS_NAME%%/
          NAME_SCOPE = /%%SCSS_NAME%%/g
          INNER = /%%SCSS_INNER%%/
          INNER_SCOPE = /%%SCSS_INNER%%/g
          INIT = /%%SCSS_INIT_INNER%%/
          INIT_SCOPE = /%%SCSS_INIT_INNER%%/g
          inner = grams.match INNER
          init = grams.match INIT
          named = grams.match NAME

          if init and q.oppos is privateClassPosition
            ankh = ankh.replace(INIT_SCOPE, q.opname)

          if inner
            newPrivateClassName = q.opname.capitalize()
            ankh = ankh.replace(INNER_SCOPE, newPrivateClassName)

          if named
            ankh = ankh.replace(NAME_SCOPE, q.opname)
            filename = q.opname

          schema   : ankh
          filename : filename

    return

g = new Grammuelle

  #pathbase = './'
  #ext = '.coffee'
  #filepath = (pathbase + output.filename + ext)
  #inputdata = output.schema
  #__fs__.writeFile filepath, inputdata, (error) =>
    #if error? then return log(error)
    #else log "Saved #{output.filename}"


