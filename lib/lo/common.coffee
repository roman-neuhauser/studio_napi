for v in 'DELETE GET POST PUT'.split(' ')
  do (v) ->
    global[v] = (method, args..., done) -> [v, method, args..., done]

asis = (parsed) -> parsed

as_array = (parsed) ->
    if parsed instanceof Array
      parsed
    else if parsed is undefined
      []
    else
      [parsed]

to_array = (parsed, kind) ->
  kinds = "#{kind}s"
  return parsed unless kinds of parsed
  unless parsed[kinds] instanceof Array
    if parsed[kinds][kind] is undefined
      parsed[kinds] = []
    else if parsed[kinds][kind] instanceof Array
      parsed[kinds] = parsed[kinds][kind]
    else
      parsed[kinds] = [parsed[kinds][kind]]
  parsed

exports.asis = asis
exports.as_array = as_array
exports.to_array = to_array

exports.api = (methods) -> (rpcgen, xml) ->

  xml ?= (require './xml')

  xml2pojo = xml.to_js methods

  rpc = rpcgen methods

  response_handlers =
    'application/xml': (sig) -> (res, done) ->
      body = new Buffer 0
      res.on 'data', (chunk) ->
        body = Buffer.concat [body, chunk]
      res.on 'end', ->
        xml.parse body, (err, result) ->
          return done err if err
          return done result.error if result.error and result.error.code
          xml2pojo sig, result, (err, result) ->
            return done err if err
            done undefined, result
    '*/*': (sig) -> (res, done) ->
      done undefined, res

  (httpmethod, apimethod, args..., done) ->
    unless apimethod? and done?
      # FIXME: coverage
      [httpmethod, apimethod, args..., done] = httpmethod
    sig = "#{httpmethod} #{apimethod}"

    unless methods[sig]
      return done new Error "#{sig}: unknown method"

    rpc httpmethod, apimethod, args..., (err, res) ->
      return done err if err
      ct = res.headers['content-type'].match(/^[^;$]+/)[0]
      ct = '*/*' unless ct of response_handlers
      rh = response_handlers[ct] sig
      rh res, done

{url, qstring} = require './url'

subst_path = (path, args, inpath) ->
  path.replace /:(\w+)/g, (_, param) ->
    throw new Error \
      "parameter '#{param}' not found in arguments" \
      unless param of args
    inpath[param] = yes
    qstring.escape args[param]

build_qs = (args, inpath) ->
  query = {}
  query[k] = v for k, v of args when not inpath[k]
  qs = qstring.stringify query
  qs = "?#{qs}" if qs.length
  qs

exports.rpc = (httpc, options) -> (methods) ->
  if not options?
    # FIXME: coverage
    [httpc, options] = [(require './http').request, httpc]
  options = options.options
  server = url.parse options.url
  (httpmethod, apimethod, args..., done) ->
    path = apimethod
    if args.length
      args = args[0]
    inpath = {}
    try
      path = subst_path path, args, inpath
    catch e
      return done new Error "#{httpmethod} #{apimethod}: #{e.message}"
    qs = build_qs args, inpath
    reqopts =
      method: httpmethod
      path: "#{server.pathname}#{path}#{qs}"
      port: server.port
      hostname: server.hostname
      auth: "#{options.user}:#{options.key}"
    httpc reqopts, done

