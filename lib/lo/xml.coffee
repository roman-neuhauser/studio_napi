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

# A CDATA section cannot contain the string "]]>" and therefore
# it is not possible for a CDATA section to contain nested CDATA
# sections.
# The preferred approach to using CDATA sections for encoding text
# that contains the triad "]]>" is to use multiple CDATA sections
# by splitting each occurrence of the triad just before the ">".
#
# For example, to encode "]]>" one would write:
#
#   <![CDATA[]]]]><![CDATA[>]]>
#
#   -- http://en.wikipedia.org/wiki/CDATA#Nesting
CDATA = (v) ->
  "<![CDATA[#{(String v).replace /]]>/g, ']]]]><![CDATA[>'}]]>"

xmldoc = ->
  children = []
  @append = (child) ->
    children.push child
    this
  @CDATA = CDATA
  @toString = ->
    rv = ''
    rv += c.toString() for c in children
    rv
  this

entities = (v) ->
  values =
    '<': '&lt;'
    '>': '&gt;'
    '&': '&amp;'
    '"': '&quot;'
    "'": '&apos;'
  (String v).replace /[<>&"']/, (v) ->
    values[v]

xmltag = (name) ->
  @name = name
  @attrs = null
  children = []
  @append = (child) ->
    children.push child
    this
  @CDATA = CDATA
  @toString = ->
    rv = "<#{name}"
    if @attrs
      rv += " #{n}=\"#{entities v}\"" for n, v of @attrs
    rv += "/" unless children.length
    rv += ">"
    if children.length
      rv += children.join('')
      rv += "</#{name}>"
    rv
  this

assign_attrs = (node, vals) ->
  return unless typeof vals is 'object'
  return if vals instanceof Array
  return if vals instanceof Number
  return if vals instanceof String

  attrs = {}
  attrs[k] = v for k, v of vals
  node.attrs = attrs

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
              assign_attrs curr, (body.call curr, (tag curr, ctx), ctx)
            when 'object'
              curr.append ctx[name] if ctx and name of ctx
              assign_attrs curr, body
            else
              curr.append body
        else
          [ctx, body] = [arguments[1], arguments[2]]
          assign_attrs curr, (body.call curr, (tag curr, ctx), ctx)

      null

    impl.attrs = (attrs) ->
      par.attrs = attrs

    impl

  more.call root, (tag root, ji), ji

  root.toString()
