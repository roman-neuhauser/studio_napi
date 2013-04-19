{parse, transform} = require './setup'

describe 'XML -> POJO xforms, user: GET /gallery/appliance/:app/rating', ->

  it 'lists all appliances of the current user', (done) ->
    parse 'tests/user/GET_gallery_appliance_rating.xml', (err, r) ->
      no_error err
      transform 'GET /gallery/appliance/:app/rating', r, async done, (e, r) ->
        no_error e
        contains r, gallery: appliance:
          ratings: "2"
          average_rating: "5.0"

