expect = (require 'chai').expect

tools = require '../tools'

unapi = (require '../../lib/user').api tools.rpc 'user'

describe 'User API', ->

  it 'gives metadata for an overlay file', (done) ->
    unapi GET 'file', async done, (err, r) ->
      no_error err
      contains r, file: {
        id: '21'
        filename: 'api.txt'
        path: '/'
        owner: 'nobody'
        group: 'nobody'
        permissions: '644'
        enabled: 'true'
        download_url: 'http://susestudio.com/api/v1/user/files/21/data'
      }

