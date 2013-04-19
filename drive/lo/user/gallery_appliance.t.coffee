tools = require './tools'
studio = require './lib-lo'

describe 'Low-level user API:', ->

  creds = tools.config_file 'cfg/user'
  sess = studio.session user: creds

  apimethod = '/gallery/appliances/:app'

  describe "GET #{apimethod}", ->

    it 'fails on nonexisting appliance', (done) ->

      sess GET apimethod, { app: 0 }, async done, (err, r) ->
        (expect err, 'error').to.have.property 'code', 'invalid_appliance_id'
        (expect err, 'error').to.have.property 'message'

    it 'works with existing template', (done) ->

      sess GET apimethod, { app: 711 }, async done, (err, r) ->

        no_error err

        (expect r, 'result').to.have.keys 'gallery'
        r = r.gallery
        (expect r, 'result').to.have.keys 'appliance'
        r = r.appliance
        (expect r, 'result').to.have.keys \
          'based_on'
        , 'configuration'
        , 'description'
        , 'firewall'
        , 'formats'
        , 'homepage'
        , 'id'
        , 'locale'
        , 'name'
        , 'network'
        , 'publisher'
        , 'release_notes'
        , 'security'
        , 'username'
        , 'version'

        '
          based_on
          description
          homepage
          id
          name
          publisher
          release_notes
          username
          version
        '.trim().split(/\s+/).forEach (p) ->
          (expect r[p], p).to.be.a 'string'

