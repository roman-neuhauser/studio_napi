common = require './common'

asis = common.asis
to_array = common.to_array

since = (parsed) ->
  parsed.since = parsed.since['#']
  parsed

transforms =
  'GET /about':
    response: (sig, xo, done) ->
      done undefined, xo

  'GET /active_users':
    response: (sig, xo, done) ->
      output = (parsed) ->
        day: parsed.day
        total: parsed.total
        groups: parsed.groups.group
      done undefined, active_users:
        output xo.active_users

  'GET /health_check':
    response: (sig, xo, done) ->
      output = (parsed) ->
        to_array parsed, 'kiwi_runner'
        to_array parsed, 'testdrive_runner'
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
      done undefined, health_check:
        output xo.health_check

  'GET /job_history':
    response: (sig, xo, done) ->
      done undefined, job_history:
        since xo.job_history

  'GET /running_jobs':
    response: (sig, xo, done) ->
      output = (parsed) ->
        to_array parsed, 'build'
        to_array parsed, 'testdrive'
        parsed
      done undefined, running_jobs:
        output xo.running_jobs

  'GET /summary':
    response: (sig, xo, done) ->
      output = (parsed) ->
        unless parsed.disks instanceof Array
          parsed.disks = [parsed.disks.disk]
        else
          parsed.disks = (disk for disk in parsed.disks['#'])
        since parsed
      done undefined, summary:
        output xo.summary

exports.transforms = transforms
exports.api = common.api transforms

