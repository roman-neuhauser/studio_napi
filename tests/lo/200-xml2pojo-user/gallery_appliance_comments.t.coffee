{parse, transform} = require './setup'

describe 'XML -> POJO xforms, user: GET /gallery/appliance/:app/comments', ->

  it 'lists all appliances of the current user', (done) ->
    parse 'tests/user/GET_gallery_appliance_comments.xml', async done, (err, r) ->
      no_error err
      r = transform 'GET /gallery/appliance/:app/comments', r
      contains r, gallery: appliance:
        id: "22"
        comments: [
          {
            id: "3"
            timestamp: "2010-10-11 14:01:24 UTC"
            username: "Matt Barringer"
            text: "This is a comment posted via the API"
          }
          {
            id: "4"
            parent_id: "3"
            timestamp: "2010-10-11 14:02:05 UTC"
            username: "Matt Barringer"
            text: "This is a reply to a comment posted via the API"
          }
        ]

