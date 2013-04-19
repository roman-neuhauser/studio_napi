{parse, transform} = require './setup'

describe 'XML -> POJO xforms, user: GET /appliances/:app/status', ->

  it 'gives current state of an appliance', (done) ->
    parse 'tests/user/GET_appliance_status.xml', (err, r) ->
      no_error err
      transform 'GET /appliances/:app/status', r, async done, (e, r) ->
        no_error e
        contains r, status:
          state: 'error'
          issues: [
            {
              type: 'error'
              text: 'You must include a kernel package in your appliance.'
              solution:
                type: 'install'
                package: 'kernel-default'
            }
          ]

