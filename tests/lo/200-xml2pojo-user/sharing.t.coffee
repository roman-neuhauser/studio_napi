{parse, transform} = require './setup'

describe 'XML -> POJO xforms, user: GET /appliances/:app/sharing', ->

  it 'gives users permitted to clone an appliance', (done) ->
    parse 'tests/user/GET_sharing.xml', (err, r) ->
      no_error err
      transform 'GET /appliances/:app/sharing', r, async done, (e, r) ->
        no_error e
        contains r, appliance:
          id: '22'
          read_users: [
            'steam'
          ]

