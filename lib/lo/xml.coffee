clone = require 'clone'
xml2js = require 'xml2js'

xml2js_options = clone xml2js.defaults["0.2"]
xml2js_options.emptyTag = []
xml2js_options.explicitArray = false
xml2js_options.attrkey = "@"
xml2js_options.charkey = "#"

parser = new xml2js.Parser(xml2js_options)

exports.parse = (data, done) ->
  parser.parseString data, done

deattr = (xo) ->
  if xo instanceof Array
    for v, i in xo
      deattr v
  else if xo instanceof Object
    delete xo['@']
    for p, v of xo
      deattr v
  xo

exports.transform = (transforms) -> (sig, result, done) ->
  unless transforms[sig]
    return done new Error "#{sig}: unknown method"

  t = transforms[sig].response
  t sig, result, done

xmldoc = ->
  children = []
  @append = (child) ->
    children.push child
    this
  @toString = ->
    rv = ''
    rv += c.toString() for c in children
    rv
  this

xmltag = (name) ->
  @name = name
  @attrs = null
  children = []
  @append = (child) ->
    children.push child
    this
  @toString = ->
    rv = "<#{name}"
    if @attrs
      rv += " #{n}=\"#{v}\"" for n, v of @attrs
    rv += "/" unless children.length
    rv += ">"
    if children.length
      rv += children.join('')
      rv += "</#{name}>"
    rv
  this

exports.builder = builder = (ji, more) ->

  root = new xmldoc

  tag = (par, ji) ->

    impl = (name, _1, _2) ->

      # do not clobber state shared between invocations
      ctx = ji

      par.append curr = new xmltag name

      switch arguments.length
        when 1
          curr.append ctx[name] if ctx and name of ctx
        when 2
          body = arguments[1]
          switch typeof body
            when 'function'
              ctx = ctx?[name]
              attrs = body.call curr, (tag curr, ctx), ctx
              curr.attrs = attrs if attrs
            when 'object'
              curr.append ctx[name] if ctx and name of ctx
              curr.attrs = body
            else
              curr.append body
        else
          [ctx, body] = [arguments[1], arguments[2]]
          attrs = body.call curr, (tag curr, ctx), ctx
          curr.attrs = attrs if attrs

      null

    impl.attrs = (attrs) ->
      par.attrs = attrs

    impl

  more.call root, (tag root, ji), ji

  root.toString()
