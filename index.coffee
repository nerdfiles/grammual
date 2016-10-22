###
@fileOverview ./index.coffee
@description
Grammuelle.
###

__fs__ = require('fs')
__q__ = require('promise-defer')
log = console.log
_ = require('lodash')

String::int = () ->
  parseInt @, 10

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
    @schema = null
    @schemas = []
    @done = null
    open('./stylebook.grams').then (data) ->
      @schema = data

  generate: () ->
    d = __q__()
    open().then (data) ->
      psb = p.parse data

      parseMap = _.filter _.map psb, (d) ->
        opname = null
        if c = d.match /module\[([0-9])\]\_\_(.*)/
          h = c[1].int()
          classPosition = 0
          privateClassPosition = 2
          dirtyName = c[2]
          if h is classPosition and dirtyName
            capitalizedFirstCharOfName = dirtyName.split('')
              .reverse()
              .pop()
              .toUpperCase()
            firstCharRemoved = dirtyName.slice(1, dirtyName.length)
            newModuleName = (capitalizedFirstCharOfName + firstCharRemoved)
            opname = newModuleName
          if h is privateClassPosition and dirtyName
            newComponentName = dirtyName.toLowerCase()
            opname = newComponentName
        opname

      _.each parseMap, (q, i) ->
        NAME = /%%SCSS_NAME%%/
        NAME_SCOPE = /%%SCSS_NAME%%/g
        INNER = /%%SCSS_INNER%%/
        INNER_SCOPE = /%%SCSS_INNER%%/g
        INIT = /%%SCSS_INIT_INNER%%/
        INIT_SCOPE = /%%SCSS_INIT_INNER%%/g
        inner = @schema.match INNER
        init = @schema.match INIT
        named = @schema.match NAME

        if named
          @schema = @schema.replace(NAME_SCOPE, q)
          @filename = q
        else if inner or init
          if inner
            capitalizedFirstCharOfName = q.split('')
              .reverse()
              .pop()
              .toUpperCase()
            firstCharRemoved = q.slice(1, q.length)
            newPrivateClassName = (capitalizedFirstCharOfName + firstCharRemoved)
            @schema = @schema.replace(INNER_SCOPE, newPrivateClassName)
          @schema = @schema.replace(INIT_SCOPE, q)

      d.resolve
        schema   : @schema
        filename : @filename

    d.promise

g = new Grammuelle

g.generate().then (output) ->
  pathbase = './'
  ext = '.coffee'
  filepath = (pathbase + output.filename + ext)
  inputdata = output.schema
  __fs__.writeFile filepath, inputdata, (error) =>
    if error? then return log(error)
    else log "Saved #{output.filename}"


