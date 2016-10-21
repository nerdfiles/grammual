__fs__ = require('fs')
__q__ = require('promise-defer')
log = console.log
_ = require('lodash')

open = (f = './__test__.scss') ->
  defer = __q__()
  __fs__.readFile(f, 'utf-8', (error, data) ->
    defer.resolve data
    return
  )
  defer.promise

capture_module = (view) ->
  if m = view.match /(\@include\s*(.*)\(\')(.*)(\')/
    firstCharOfName = m[3].split('').reverse().pop().toUpperCase()
    name = firstCharOfName + m[3].slice(1, m[3].length)

capture_array = (view) ->
  v = view.split('\n')
  counter++
  if m = view.match /(\@include\s*(.*))/
    if z = m[2].match /(.*)\(\(/
      z


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
  ready: (view) ->
    p = @parsers.reduce @contract, view
  parse: (content) ->
    c = content.split("\n")
    list = _.filter(@ready(view) for view in c)

class Operation
  constructor: (@op) ->
    @op

class Grammuelle

  p = new Parser [capture_module]

  constructor: () ->
    @schema = null
    @done = null
    open('./stylebook.grams').then (data) ->
      @schema = data

  initialize: () ->
    open().then (data) ->
      psb = p.parse data

      parseMap = _.map psb, (d) ->
        new Operation d

      _.each parseMap, (q, i) ->
        if @schema.match /%%SCSS_NAME%%/
          @schema = @schema.replace(/%%SCSS_NAME%%/g, q.op)
          @done = _.remove parseMap, (n) -> (n == i)
        else
          @schema = @schema.replace(/%%SCSS_INNER%%/g, q.op)

      log @schema

g = new Grammuelle

g.initialize()


