{parse, transform} = require './setup'

describe 'XML -> POJO xforms, user: GET /gallery/appliance/:app/testdrive', ->

  it 'lists all appliances of the current user', (done) ->
    parse 'tests/user/GET_gallery_appliance_testdrive.xml', async done, (err, r) ->
      no_error err
      r = transform 'GET /gallery/appliance/:app/testdrive', r
      contains r, gallery: testdrive:
        url: "http://localhost:3002/testdrive/start/22/54/APASSWORD"
        server:
          vnc:
            host: 'localhost'
            port: '5907'
            password: 'APASSWORD'
