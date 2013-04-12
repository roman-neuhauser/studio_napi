tools = require '../tools'
admin = require './lib-lo-admin'
xml   = require './lib-lo-xml'

transform = xml.to_js admin.transforms

parse = tools.parseXML

describe 'XML -> POJO xforms, admin:', ->

  describe 'GET /about', ->
    it 'gives hostname, RoR env, git commitish', (done) ->
      parse "tests/admin/about.xml", (err, r) ->
        no_error err
        transform 'GET /about', r, (e, r) ->
          no_error e
          contains r, about:
            server_name: 'kerogen.suse.de:3000'
            environment: 'development'
            git_revision: '074b2a42d48c7b8256c1b9328a7b29a944aeb8c7'
          do done

  describe 'GET /active_users', ->
    it 'gives overview of active users', (done) ->
      parse 'tests/admin/active_users.xml', (err, r) ->
        no_error err
        transform 'GET /active_users', r, (e, r) ->
          no_error e
          contains r, active_users:
            day: '2013-02-14'
            total: '2'
            groups: [
              { name: 'beta-testers',  value: '1' }
              { name: 'azure-testers', value: '0' }
              { name: 'sid-testers',   value: '0' }
              { name: 'log viewers',   value: '0' }
              { name: 'Users',         value: '1' }
            ]
          do done

  describe 'GET /job_history', ->
    it 'gives build/testdrive stats', (done) ->
      parse 'tests/admin/job_history.xml', (err, r) ->
        no_error err
        transform 'GET /job_history', r, (e, r) ->
          no_error e
          contains r, job_history:
            since: '86400'
            builds:
              succeeded: '0'
              failed: '0'
              successrate: '0'
            testdrives: '0'
          do done

  describe 'GET /running_jobs', ->
    it 'gives build/testdrive data', (done) ->
      parse 'tests/admin/running_jobs.xml', (err, r) ->
        no_error err
        transform 'GET /running_jobs', r, (e, r) ->
          no_error e
          contains r, running_jobs:
            builds: []
            testdrives: []
          do done

  describe 'GET /summary', ->
    it 'gives uptime, build/testdrive/user/bug stats, df, etc', (done) ->
      parse 'tests/admin/summary.xml', (err, r) ->
        no_error err
        transform 'GET /summary', r, (e, r) ->
          no_error e
          contains r, summary:
            since: '86400'
            last_bug_status_refresh_time: {}
            unassigned_failures_count: '10'
            builds:
              succeeded: '0'
              failed: '0'
              errored: '0'
              successrate: '0'
            testdrives: '0'
            active_users: []
            disks: [
              {
                filesystem: '/dev/sda7'
                total: '121449922560'
                used: '104339582976'
                used_percentage: '91%'
                available: '10940973056'
                mount_point: '/build'
              }
            ]
            bugs: []
          do done

  describe 'GET /health_check', ->
    it 'gives information about the state of the system', (done) ->
      parse 'tests/admin/health_check.xml', (err, r) ->
        no_error err
        transform 'GET /health_check', r, (e, r) ->
          no_error e
          contains r, health_check:
            state: 'error'
            mysql: 'ok'
            thoth: 'ok'
            rmds: 'ok'
            kiwi_runners: [
              {
                id: '1'
                address: 'localhost:3001'
                status: 'pinged'
                last_pinged: '2009-07-16 09:27:32 UTC'
                slots: '1'
                used_slots: '0'
                load: '2.68'
              }
            ]
            testdrive_runners: [
              {
                id: '2'
                address: 'localhost:3002'
                status: 'unreachable'
                last_pinged: '2009-06-25 14:21:02 UTC'
                slots: '8'
                used_slots: '0'
                load: '0.34'
              }
            ]
            disks: [
              {
                path: '/'
                used: '61%'
                available: '7999651840'
              }
              {
                path: '/dev'
                used: '1%'
                available: '1038233600'
              }
            ]

          do done

