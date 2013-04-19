{parse, transform} = require './setup'

describe 'XML -> POJO xforms, user: GET /files', ->

  it 'gives metadata for all overlay files in an appliance', (done) ->
    parse 'tests/user/GET_files.xml', (err, r) ->
      no_error err
      transform 'GET /files', r, async done, (e, r) ->
        no_error e
        contains r, files: [
          {
            id: '21'
            filename: 'api.txt'
            path: '/'
            owner: 'nobody'
            group: 'nobody'
            permissions: '644'
            enabled: 'true'
            download_url: 'http://susestudio.com/api/v1/user/files/21/data'
          }
          {
            id: '22'
            filename: 'appliances.xml'
            path: '/'
            owner: 'nobody'
            group: 'nobody'
            permissions: '644'
            enabled: 'true'
            download_url: 'http://susestudio.com/api/v1/user/files/22/data'
          }
        ]

