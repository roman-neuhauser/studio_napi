tools = require '../tools'

unapi = tools.api 'user'

describe 'User API', ->

  it 'gives info on a testdrive', (done) ->
    unapi POST '/testdrives', {build_id: 69}, async done, (err, r) ->
      no_error err
      contains r, testdrive:
        id: '1234'
        state: 'new'
        build_id: '12345'
        url: 'http://node52.susestudio.com/testdrive/testdrive/start/11/22/abcdefgh1234567890'
        server:
          vnc:
            host: 'node52.susestudio.com'
            port: '5902'
            password: '1234567890'

