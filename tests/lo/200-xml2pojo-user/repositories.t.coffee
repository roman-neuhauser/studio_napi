{parse, transform} = require './setup'

describe 'XML -> POJO xforms, user:', ->

test = (request) -> (done) ->
    parse 'tests/user/GET_repositories.xml', (err, r) ->
      no_error err
      transform request, r, async done, (e, r) ->
        no_error e
        contains r, repositories: [
          {
            id: '7'
            name: 'Moblin Base'
            type: 'rpm-md'
            base_system: '11.1'
            base_url: 'http://download.opensuse.org/repositories/Moblin:/Base/openSUSE_11.1'
            matches: {
              repository_name: 'moblin base'
              repository_base_url: 'http://download.opensuse.org/repositories/moblin:/base/opensuse_11.1'
            }
          }
        ]

  describe 'GET /repositories', ->
    it 'gives a list of repositories'
    , test 'GET /repositories'

  describe 'GET /appliances/:app/repositories', ->
    it 'gives all repositories for an appliance'
    , test 'GET /appliances/:app/repositories'
