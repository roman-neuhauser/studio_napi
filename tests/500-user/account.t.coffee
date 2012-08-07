{parse, transform} = require './setup'

describe 'XML -> POJO xforms, user: GET /account', ->

  it 'gives information about the account', (done) ->
    parse 'tests/user/account.xml', async done, (err, r) ->
      no_error err
      r = transform 'GET /account', r
      contains r, account:
        username: 'uexample'
        displayname: 'User Example'
        email: 'user@example.com'
        created_at: '2009-05-14 14:51:07 UTC'
        openid_urls: [
          'http://user.example.com/'
        ]
        disk_quota:
          available: '15GB'
          used: '4%'

