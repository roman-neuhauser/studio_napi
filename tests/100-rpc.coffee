expect = (require 'chai').expect
admin = require '../lib/lo/admin'
tools = require './tools'

describe 'RPC (HTTP) client', ->

  it 'calls http.request with correctly transformed arguments', (done) ->
    httprequest = (reqopts, done) -> done undefined, reqopts

    anrpc = admin.rpc httprequest, options:
      url: 'http://example.org:4269/'
      user: 'ytsarev'
      key: 'blabla'

    anrpc 'DELETE', '/fubar', foo: 'bar', (err, res) ->
      no_error err
      expected =
        method: 'DELETE'
        path: '/api/v2/admin/fubar'
        port: '4269'
        hostname: 'example.org'
        auth: 'ytsarev:blabla'
      contains res, expected
      done()

  it 'embeds API params in the requested url', (done) ->
    httprequest = (reqopts, done) -> done undefined, reqopts

    anrpc = admin.rpc httprequest, options:
      url: 'http://example.org:6942/'
      user: 'ytsarev'
      key: 'blabla'

    anrpc 'PUT', '/snafu/:foo/omg/:wtf', foo: 'bar', wtf: 'rofl', (err, res) ->
      no_error err
      expected =
        method: 'PUT'
        path: '/api/v2/admin/snafu/bar/omg/rofl'
        port: '6942'
        hostname: 'example.org'
        auth: 'ytsarev:blabla'
      contains res, expected
      done()

