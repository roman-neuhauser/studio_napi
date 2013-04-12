fs = require 'fs'
xml = require '../lib/lo/xml'
expect = (require 'chai').expect
diff = (require 'difflet')(indent: 2, comment: true).compare

config_file = (path) ->
  try
    cfg = {}
    (fs.readFileSync path, 'utf8')
      .split(/\n/)
      .filter((l) -> !l.match /^\s*#|^\s*$/)
      .map((l) -> l.split /\s*=\s*/, 2)
      .forEach (pair) ->
        cfg[pair[0]] = pair[1]
    cfg
  catch e
    if e.code == 'ENOENT'
      throw new Error """
        Configuration file '#{path}' not found.

        See README.rest for instructions.

      """
    else
      throw e

exports.config_file = config_file

# FIXME: does not handle arrays well
contains = (actual, expected) ->
  unless expected instanceof Object
    throw new Error "contains function requires objects"
  for p, v of expected
    if v instanceof Object
      contains actual[p], v
    else
      (expect actual[p], diff actual, expected).to.equal v

no_error = (err) ->
  (expect err, 'err').to.not.exist

global.expect = expect

global.contains = contains
global.no_error = no_error

global.async = (done, test) -> (args...) ->
  test args...
  done()

global.responds_to = (req, test) ->
  it "responds to #{req}", test

parseXML = (file, done) ->
  fs.readFile file, (e, r) ->
    return done e if e
    xml.parse r, done

exports.parseXML = parseXML

filerpc = (dir, api2file) -> (httpmethod, apimethod, args..., done) ->
  file = api2file["#{httpmethod} #{apimethod}"] or apimethod[1..]
  fs.readFile "tests/#{dir}/#{file}.xml", done

exports.filerpc = filerpc
