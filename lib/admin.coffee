fs = require 'fs'
xml = require './xml'

asis = (parsed) -> parsed
since = (parsed) ->
  parsed.since = parsed.since['#']
  parsed
runners = (parsed, kind) ->
  unless parsed["#{kind}s"] instanceof Array
    parsed["#{kind}s"] = [parsed["#{kind}s"][kind]]
  parsed

methods =
  about: asis
  active_users: since

  health_check: (parsed) ->
    runners parsed, 'kiwi_runner'
    runners parsed, 'testdrive_runner'
    unless parsed.disks instanceof Array
      if parsed.disks.disk instanceof Array
        parsed.disks = parsed.disks.disk
      else
        parsed.disks = [parsed.disks.disk]
    disks = []
    for d in parsed.disks
      d.path = d['@'].path
      delete d['@']
      disks.push d
    parsed

  job_history: since
  running_jobs: asis

  summary: (parsed) ->
    unless parsed.disks instanceof Array
      parsed.disks = [parsed.disks.disk]
    else
      parsed.disks = (disk for disk in parsed.disks['#'])
    since parsed

exports.api = (method, args..., done) ->
  unless methods[method]
    return done "#{method}: unknown method"
  else
    fs.readFile "tests/admin/#{method}.xml", (err, data) ->
      return done err if err
      xml.parse data, (err, result) ->
        return done err if err
        methods[method] result[method]
        done undefined, result

