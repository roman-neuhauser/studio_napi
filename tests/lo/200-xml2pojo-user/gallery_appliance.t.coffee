{parse, transform} = require './setup'

describe 'XML -> POJO xforms, user: GET /gallery/appliance/:app', ->

  it 'gives information about the appliance', (done) ->
    parse 'tests/user/GET_gallery_appliance.xml', async done, (err, r) ->
      no_error err
      r = transform 'GET /gallery/appliance/:app', r
      contains r, gallery: appliance:
        id: "22"
        name: "Matt's Amazing JeOS"
        version: "5.0.0"
        release_notes: "Added the AppArmor package for *EXTRA SECURITY*."
        homepage: "http://susestudio.com"
        description: "THIS IS AN AWESOME JEOS APPLIANCE DOWNLOAD"
        publisher: "Matt Barringer"
        username: "mbarringer"
        based_on: "11.3"
        formats:
          oem: "d12788f96487fce0d41aaafd3e1ab70d"
        configuration:
          accounts: [
            {
              user: "root"
              password: "linux"
            }
            {
              user: "tux"
              password: "linux"
            }
            {
              user: "version3"
              password: "pass2"
            }
          ]
        locale:
          keyboard_layout: "english-us"
          language: "en_US.UTF-8"
          timezone:
            location: "Europe/Berlin"
        network:
          type: "ask_on_first_boot"
        firewall:
          enabled: "true"
          open_ports: ["ssh", "http"]
        security:
          sources:
            only_trusted: "false"
            untrusted_source: "mbarringer openSUSE 11.3"
          custom_packages:
            uses_custom_packages: "false"
          overlay_files: "false"
          custom_scripts: "false"

