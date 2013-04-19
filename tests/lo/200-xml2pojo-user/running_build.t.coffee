{parse, transform} = require './setup'

describe 'XML -> POJO xforms, user: GET /running_builds/:bld', ->

  it 'gives status of a running build', (done) ->
    parse 'tests/user/GET_running_build.xml', (err, r) ->
      no_error err
      transform 'GET /running_builds/:bld', r, async done, (e, r) ->
        no_error e
        contains r, running_build:
          id: '38'
          state: 'running'
          percent: '0'
          time_elapsed: '5'
          message: 'Fetching appliance configuration'

