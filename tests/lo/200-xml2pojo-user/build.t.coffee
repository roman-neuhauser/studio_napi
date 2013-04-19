{parse, transform} = require './setup'

describe 'XML -> POJO xforms, user: GET /builds/:bld', ->

  it 'gives info for a build', (done) ->
    parse 'tests/user/GET_build.xml', (err, r) ->
      no_error err
      transform 'GET /builds/:bld', r, async done, (e, r) ->
        no_error e
        contains r, build:
          id: '28'
          version: '0.0.1'
          state: 'finished'
          expired: 'false'
          image_type: 'oem'
          checksum:
            md5: 'f0071c5f47c892478a8d28b0fe1cfde6'
            sha1: 'bf988e8a338bd4996be33c840de804126fecfeab'
          size: '238'
          compressed_image_size: '87'
          download_url: 'http://susestudio.com/download/bf1a0f08884ebac13f30b0fc62dfc44a/Cornelius_JeOS.x86_64-0.0.1.oem.tar.gz'
          log:
            build: []
            kiwi: []
          profile:
            steps: [
              {
                name: 'Setting%20up%20build%20directories'
                time: '0'
                percent: '0'
              },
              {
                name: 'Fetching%20appliance%20configuration',
                time: '9',
                percent: '2',
              },
              # etc etc
            ]

