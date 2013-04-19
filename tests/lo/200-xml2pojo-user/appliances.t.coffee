{parse, transform} = require './setup'

describe 'XML -> POJO xforms, user: GET /appliances', ->

  it 'lists all appliances of the current user', (done) ->
    parse 'tests/user/GET_appliances.xml', (err, r) ->
      no_error err
      transform 'GET /appliances', r, async done, (e, r) ->
        no_error e
        contains r, appliances: [
          {
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
          }
          {
            id: '8'
            name: 'Text Only'
            last_edited: '2009-04-20 14:21:49 UTC'
            edit_url: 'http://susestudio.com/appliance/edit/8'
            icon_url: 'http://susestudio.com/api/v1/user/appliance_icon/1234'
            parent:
              id: '2'
              name: 'openSUSE 11.1, Server'
              basesystem: '11.1'
            builds: [
              {
                id: '26'
                version: '0.0.3'
                image_type: 'iso'
                image_size: '136'
                compressed_image_size: '0'
                download_url: 'http://susestudio.com/download/3b8c8785320b147610b8488c837195ac/Text_Only.i686-0.0.3.iso'
              }
              {
                id: '25'
                version: '0.0.3'
                image_type: 'oem'
                image_size: '498'
                compressed_image_size: '149'
                download_url: 'http://susestudio.com/download/1e06698c8c88a65d4759a7c24ad26015/Text_Only.i686-0.0.3.oem.tar.gz'
              }
            ]
          }
        ]

