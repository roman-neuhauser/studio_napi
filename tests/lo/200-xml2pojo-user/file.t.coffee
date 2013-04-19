{parse, transform} = require './setup'

describe 'XML -> POJO xforms, user: GET /files/:file', ->

  it 'gives metadata for an overlay file', (done) ->
    parse 'tests/user/GET_file.xml', (err, r) ->
      no_error err
      transform 'GET /files/:file', r, async done, (e, r) ->
        no_error e
        contains r, file:
          id: '21'
          filename: 'api.txt'
          path: '/'
          owner: 'nobody'
          group: 'nobody'
          permissions: '644'
          enabled: 'true'
          download_url: 'http://susestudio.com/api/v1/user/files/21/data'

