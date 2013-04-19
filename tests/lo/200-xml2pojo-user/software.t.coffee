{parse, transform} = require './setup'

describe 'XML -> POJO xforms, user: GET /appliances/:app/software', ->

  it 'gives all selected packages and patterns of an appliance', (done) ->
    parse 'tests/user/GET_software.xml', (err, r) ->
      no_error err
      transform 'GET /appliances/:app/software', r, async done, (e, r) ->
        no_error e
        contains r, software:
          appliance_id: '42'
          patterns: [
            'laptop'
            'x11'
          ]
          packages: [
            { name: 'MozillaFirefox' }
            { name: 'PolicyKit' }
            { name: 'SuSEfirewall2' }
            { name: 'aaa_base' }
            { name: 'branding-openSUSE' }
            { name: 'dhcpcd' }
            { name: 'fate' }
            { name: 'grub' }
            { name: 'hwinfo' }
            { name: 'insserv' }
            { name: 'kbd' }
            { name: 'kde4-yakuake' }
            { name: 'kernel-default', version: '2.6.27.7-9.1' }
            { name: 'licenses' }
            { name: 'mkinitrd' }
            { name: 'module-init-tools' }
            { name: 'netcfg' }
            { name: 'openSUSE-build-key' }
            { name: 'openSUSE-release' }
            { name: 'openssh' }
            { name: 'polkit-default-privs' }
            { name: 'procps' }
            { name: 'pwdutils' }
            { name: 'rpcbind' }
            { name: 'rpm' }
            { name: 'sysconfig' }
            { name: 'syslog-ng' }
            { name: 'vim', version: '7.2-7.3' }
          ]

