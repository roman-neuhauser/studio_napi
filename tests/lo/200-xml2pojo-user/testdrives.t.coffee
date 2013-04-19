{parse, transform} = require './setup'

describe 'XML -> POJO xforms, user: GET /testdrives', ->

  it 'lists running testdrives for current user', (done) ->
    parse 'tests/user/GET_testdrives.xml', (err, r) ->
      no_error err
      transform 'GET /testdrives', r, async done, (e, r) ->
        no_error e
        contains r, testdrives: [
          {
            id: '4'
            state: 'running'
            build_id: '22'
          }
        ]

