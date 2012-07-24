expect = (require 'chai').expect

tools = require '../tools'

unapi = (require '../../lib/user').api tools.rpc 'user'

describe 'User API', ->

  it 'gives all repositories for an appliance', (done) ->
    unapi GET 'repositories', (err, r) ->
      no_error err
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
      done()
