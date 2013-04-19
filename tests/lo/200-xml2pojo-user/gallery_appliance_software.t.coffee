{parse, transform} = require './setup'

describe 'XML -> POJO xforms, user: GET /gallery/appliances/:app/software', ->

  it 'lists all appliances of the current user', (done) ->
    parse 'tests/user/GET_gallery_appliance_software.xml', (err, r) ->
      no_error err
      transform 'GET /gallery/appliances/:app/software', r, async done, (e, r) ->
        no_error e
        contains r, gallery: appliance:
          id: "22"
          repositories:
            "mbarringer openSUSE 11.3": trusted: "false"
            "openSUSE 11.3 OSS": trusted: "true"
            "openSUSE 11.3 Updates": trusted: "true"
          selected_software:
            patterns:
              apparmor:
                from: "openSUSE 11.3 OSS"
                version: "11.3"
            packages:
              "branding-openSUSE":
                from: "openSUSE 11.3 OSS"
                version: "11.3-1.2"
              insserv:
                from: "openSUSE 11.3 OSS"
                version: "1.14.0-9.1"
              iputils:
                from: "openSUSE 11.3 Updates"
                version: "ss021109-300.1.1"
              licenses:
                from: "openSUSE 11.3 OSS"
                version: "20070810-89.1"
              rpcbind:
                from: "openSUSE 11.3 OSS"
                version: "0.1.6+git20080930-10.1"
          installed_software:
            patterns:
              apparmor:
                from: "openSUSE 11.3 OSS"
                version: "11.3"
            packages:
              "branding-openSUSE":
                from: "openSUSE 11.3 OSS"
                version: "11.3-1.2"
              "bundle-lang-common-en":
                from: "openSUSE 11.3 OSS"
                version: "11.3-8.1"
              insserv:
                from: "openSUSE 11.3 OSS"
                version: "1.14.0-9.1"
              iputils:
                from: "openSUSE 11.3 Updates"
                version: "ss021109-300.1.1"
              libgcc45:
                from: "openSUSE 11.3 OSS"
                version: "4.5.0_20100604-1.12"
              liblzma0:
                from: "openSUSE 11.3 OSS"
                version: "4.999.9beta-3.7"
              "libssh2-1":
                from: "openSUSE 11.3 OSS"
                version: "1.2.2_git200911281702-3.1"
              "libstdc++45":
                from: "openSUSE 11.3 OSS"
                version: "4.5.0_20100604-1.12"
              licenses:
                from: "openSUSE 11.3 OSS"
                version: "20070810-89.1"
              permissions:
                from: "openSUSE 11.3 OSS"
                version: "2010.04.23.1140-1.6"
              "polkit-default-privs":
                from: "openSUSE 11.3 OSS"
                version: "0.1_201006171648-1.2"
              rpcbind:
                from: "openSUSE 11.3 OSS"
                version: "0.1.6+git20080930-10.1"
              timezone:
                from: "openSUSE 11.3 Updates"
                version: "2010l-0.3.1"

