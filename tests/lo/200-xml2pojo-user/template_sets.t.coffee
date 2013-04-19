{parse, transform} = require './setup'

describe 'XML -> POJO xforms, user: GET /template_sets', ->

  it 'gives a list of sets of template appliances', (done) ->
    parse 'tests/user/GET_template_sets.xml', (err, r) ->
      no_error err
      transform 'GET /template_sets', r, async done, (e, r) ->
        no_error e
        contains r, template_sets: [
          {
            description: undefined
            name: 'default'
            templates: [
              {
                appliance_id: '4'
                basesystem: 'SLED11_SP1'
                description: '_("SLED 11 SP1, with KDE 4")'
                name: 'SLED 11 SP1, KDE 4 desktop'
              }
              {
                appliance_id: '5'
                basesystem: 'SLED11_SP1'
                description: '_("SLED 11 SP1, with GNOME")'
                name: 'SLED 11 SP1, GNOME desktop'
              }
              {
                appliance_id: '21'
                basesystem: '12.2'
                description: '_("Base system + GNOME")'
                name: 'openSUSE 12.2, GNOME desktop'
              }
              # ...
            ]
          }
          {
            description: undefined
            name: 'featured'
            templates: []
          }
          {
            description: undefined
            name: 'partners'
            templates: []
          }
        ]
