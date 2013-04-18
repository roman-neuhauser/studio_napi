{parse, transform} = require './setup'

describe 'XML -> POJO xforms, user: GET /gallery/appliance/:app/rating', ->

  it 'lists all appliances of the current user', (done) ->
    parse 'tests/user/GET_gallery_appliance_rating.xml', async done, (err, r) ->
      no_error err
      r = transform 'GET /gallery/appliance/:app/rating', r
      contains r, gallery: appliance:
        ratings: "2"
        average_rating: "5.0"

