{parse, transform} = require './setup'

describe 'XML -> POJO xforms, user: POST /testdrives', ->

  it 'starts a new testdrive', (done) ->
    parse 'tests/user/GET_testdrive.xml', (err, r) ->
      no_error err
      transform 'POST /testdrives', r, async done, (e, r) ->
        no_error e
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

