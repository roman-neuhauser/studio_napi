{parse, transform} = require './setup'

describe 'XML -> POJO xforms, user: GET /api_version', ->

  it 'gives API version', (done) ->
    parse 'tests/user/GET_api_version.xml', (err, r) ->
      no_error err
      transform 'GET /api_version', r, async done, (e, r) ->
        no_error e
        contains r, version: '1.0'

