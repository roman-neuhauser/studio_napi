for v in 'DELETE GET POST PUT'.split(' ')
  do (v) ->
    global[v] = (method, args..., done) -> [v, method, args..., done]

asis = (parsed) -> parsed

as_array = (parsed) ->
    if parsed instanceof Array
      parsed
    else
      [parsed]

deattr = (xo) ->
  if xo instanceof Array
    for v, i in xo
      deattr v
  else if xo instanceof Object
    delete xo['@']
    for p, v of xo
      deattr v
  xo

exports.asis = asis
exports.as_array = as_array

transform = (transforms) -> (sig, result) ->
  t = transforms[sig]
  result[t.root] = t.output result[t.root]
  deattr result

exports.transform = transform

exports.api = (methods) -> (rpc, xml) ->

  xml ?= (require './xml')

  xml2pojo = transform methods

  (httpmethod, apimethod, args..., done) ->
    unless apimethod? and done?
      # FIXME: coverage
      [httpmethod, apimethod, args..., done] = httpmethod
    sig = "#{httpmethod} #{apimethod}"

    unless methods[sig]
      return done new Error "#{sig}: unknown method"

    rpc httpmethod, apimethod, args..., (err, data) ->
      return done err if err
      xml.parse data, (err, result) ->
        return done err if err
        # FIXME: coverage
        done undefined, xml2pojo sig, result

url = require 'url'

exports.rpc = (httpc, options) ->
  if not options?
    # FIXME: coverage
    [httpc, options] = [(require './http').request, httpc]
  options = options.options
  server = url.parse options.url
  (httpmethod, apimethod, args..., done) ->
    if args.length
      apimethod = apimethod.replace /:(\w+)/g, (_, param) -> args[0][param]
    reqopts =
      method: httpmethod
      path: "#{server.pathname}#{apimethod}"
      port: server.port
      hostname: server.hostname
      auth: "#{options.user}:#{options.key}"
    httpc reqopts, done

