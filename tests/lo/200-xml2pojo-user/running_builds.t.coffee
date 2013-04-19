{parse, transform} = require './setup'

describe 'XML -> POJO xforms, user: GET /running_builds', ->

  it 'gives status of all running build of an appliance', (done) ->
    parse 'tests/user/GET_running_builds.xml', (err, r) ->
      no_error err
      transform 'GET /running_builds', r, async done, (e, r) ->
        no_error e
        contains r, running_builds: [
          {
            id: '38'
            state: 'running'
            percent: '0'
            time_elapsed: '5'
            message: 'Fetching appliance configuration'
          }
        ]

