{parse, transform} = require './setup'

describe 'XML -> POJO xforms, user: /appliances/:app', ->

  it 'GET gives information about the appliance', (done) ->
    parse 'tests/user/GET_appliance.xml', (err, r) ->
      no_error err
      transform 'GET /appliances/:app', r, async done, (e, r) ->
        contains r, appliance:
          id: '24'
          name: "Cornelius' JeOS"
          last_edited: '2009-04-24 12:09:42 UTC'
          edit_url: 'http://susestudio.com/appliance/edit/24'
          icon_url: 'http://susestudio.com/api/v1/user/appliance_icon/1234'
          basesystem: '11.1'
          parent:
            id: '1'
            name: 'openSUSE 11.1, Just enough OS (JeOS)'
          builds: [
            {
              id: '28'
              version: '0.0.1'
              image_type: 'oem'
              image_size: '238'
              compressed_image_size: '87'
              download_url: 'http://susestudio.com/download/bf1a0f08884ebac13f30b0fc62dfc44a/Cornelius_JeOS.x86_64-0.0.1.oem.tar.gz'
            }
          ]

  it 'DELETE is successful', (done) ->
    parse 'tests/user/DELETE_appliance.xml', (err, r) ->
      no_error err
      transform 'DELETE /appliances/:app', r, async done, (e, r) ->
        no_error e
        contains r, success: true
