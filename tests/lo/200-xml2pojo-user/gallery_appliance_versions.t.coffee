{parse, transform} = require './setup'

describe 'XML -> POJO xforms, user: GET /gallery/appliance/:app/versions', ->

  it 'lists all appliances of the current user', (done) ->
    parse 'tests/user/GET_gallery_appliance_versions.xml', async done, (err, r) ->
      no_error err
      r = transform 'GET /gallery/appliance/:app/versions', r
      contains r, gallery: appliance:
        versions: [
          '0.0.1'
          '1.0.0'
          '2.0.0'
          '3.0.0'
          '4.0.0'
          '5.0.0'
        ]
