{parse, transform} = require './setup'

describe 'XML -> POJO xforms, user: GET /builds', ->

  it 'lists finished builds for an appliance', (done) ->
    parse 'tests/user/GET_builds.xml', (err, r) ->
      no_error err
      r = transform 'GET /builds', r, async done, (e, r) ->
        no_error e
        contains r, builds: [
          {
            id: '28'
            version: '0.0.1'
            state: 'finished'
            expired: 'false'
            image_type: 'oem'
            checksum:
              md5: 'bf1a0f08884ebac13f30b0fc62dfc44a'
              sha1: 'bf988e8a338bd4996be33c840de804126fecfeab'
            size: '238'
            compressed_image_size: '87'
            download_url: 'http://susestudio.com/download/bf1a0f08884ebac13f30b0fc62dfc44a/Cornelius_JeOS.x86_64-0.0.1.oem.tar.gz'
          }
        ]

