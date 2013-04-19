tools = require './tools'
studio = require './lib-lo'

describe 'Low-level user API:', ->

  creds = tools.config_file 'cfg/user'
  sess = studio.session user: creds

  apimethod = '/gallery/appliances/:app/comments'

  describe "GET #{apimethod}", ->

    it 'fails with nonexistent appliance', (done) ->

      sess GET apimethod, { app: 0 }, async done, (err, r) ->
        (expect err, 'error').to.have.property 'code', 'invalid_appliance_id'
        (expect err, 'error').to.have.property 'message'

    it 'fails with an existing, unpublished, appliance', (done) ->

      sess GET apimethod, { app: 1 }, async done, (err, r) ->
        (expect err, 'error').to.have.property 'code', 'access_denied'
        (expect err, 'error').to.have.property 'message'

    it 'works with an existing template', (done) ->

      sess GET apimethod, { app: 1 }, async done, (err, r) ->

        no_error err

        (expect r, 'result').to.have.keys 'gallery'
        r = r.gallery
        (expect r, 'result').to.have.keys 'appliance'

        (expect r.appliance, 'appliance').to.have.keys \
          'id'
        , 'comments'
        r = r.appliance

        (expect r.comments, 'comments').to.be.an 'array'

        for c in r.comments
          (expect c, 'comment').to.have.keys \
            'id'
          #, 'parent_id' FIXME it's optional
          , 'text'
          , 'timestamp'
          , 'username'
