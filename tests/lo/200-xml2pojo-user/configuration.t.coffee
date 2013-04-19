{parse, transform} = require './setup'

describe 'XML -> POJO xforms, user: GET /appliances/:app/configuration', ->

  exp = configuration: # {{{

    id: '24'
    name: 'LAMP Server'
    description: '''This is a LAMP server.

  It provides Linux, Apache, MySQL, and Perl.'''
    website: 'http://susestudio.com'

    tags: [
      'lamp'
      'server'
    ]

    locale:
      keyboard_layout: 'english-uk'
      language: 'en_GB.UTF-8'
      timezone:
        location: 'Europe/Berlin'

    network:
      type: 'manual'
      hostname: 'lampserver'
      ip: '192.168.1.100'
      netmask: '255.255.255.0'
      route: '192.168.1.1'
      nameservers: '192.168.1.1, 192.168.1.2'

    firewall:
      enabled: 'true'
      open_ports: [
        'ssh'
        'http'
      ]

    users: [
      {
        name: 'root'
        password: 'linux'
        group: 'root'
        shell: '/bin/bash'
        homedir: '/root'
      }
      {
        name: 'tux'
        password: 'linux'
        group: 'users'
        shell: '/bin/bash'
        homedir: '/home/tux'
      }
      {
        name: 'webdev'
        password: 'linux1234'
        group: 'users'
        shell: '/bin/bash'
        homedir: '/home/webdev'
      }
    ]

    eulas: [
      'This is an End User License Agreement.\n'
    ]

    databases: [
      {
        type: 'pgsql'
        users: [
          {
            username: 'db_user'
            password: 'linux'
            database_list: 'project_db'
          }
        ]
      }
    ]

    autostarts: [
      {
        command: '/usr/bin/someprogram'
        description: 'Launch "someprogram"'
        enabled: 'true'
        user: 'tux'
      }
    ]

    settings:
      memory_size: '512'
      disk_size: '16'
      swap_size: '512'
      pae_enabled: 'false'
      xen_host_mode_enabled: 'true'
      cdrom_enabled: 'true'
      webyast_enabled: 'false'
      public_clonable: 'true'
      runlevel: '3'
      automatic_login: 'tux'

    lvm:
      enabled: 'true'
      volume_group: 'systemVG'
      volumes: [
        {
          size: '1000'
          path: '/'
        }
        {
          size: '100000'
          path: '/home'
        }
      ]

    scripts:

      build:
        enabled: 'true'
        script: '''#!/bin/bash -e
        #
        # This script is executed at the end of appliance creation.  Here you can do
        # one-time actions to modify your appliance before it is ever used, like
        # removing files and directories to make it smaller, creating symlinks,
        # generating indexes, etc.
        #
        # The 'kiwi_type' variable will contain the format of the appliance (oem =
        # disk image, vmx = VMware, iso = CD/DVD, xen = Xen).
        #

        # read in some variables
        . /studio/profile

        #======================================
        # Prune extraneous files
        #--------------------------------------
        # Remove all documentation
        docfiles=`find /usr/share/doc/packages -type f |grep -iv "copying\\|license\\|copyright"`
        rm -f $docfiles
        rm -rf /usr/share/info
        rm -rf /usr/share/man

        # fix the setlocale error
        sed -i 's/en_US.UTF-8/POSIX/g' /etc/sysconfig/language

        exit 0'''

      boot:
        enabled: 'true'
        script: '''#!/bin/bash
        #
        # This script is executed whenever your appliance boots.  Here you can add
        # commands to be executed before the system enters the first runlevel.  This
        # could include loading kernel modules, starting daemons that aren't managed
        # by init files, asking questions at the console, etc.
        #
        # The 'kiwi_type' variable will contain the format of the appliance (oem =
        # disk image, vmx = VMware, iso = CD/DVD, xen = Xen).
        #

        # read in some variables
        . /studio/profile

        if [ -f /etc/init.d/suse_studio_firstboot ]
        then

          # Put commands to be run on the first boot of your appliance here
          echo "Running SUSE Studio first boot script..."

        fi'''

      autoyast:
        enabled: 'false'

  # }}}

  payload = 'tests/user/GET_configuration.xml'

  it 'includes locale information', (done) ->
    parse payload, (err, r) ->
      no_error err
      transform 'GET /appliances/:app/configuration', r, async done, (e, r) ->
        no_error e
        (expect r).to.have.deep.property('configuration.locale')
          .deep.equal(exp.configuration.locale)

  it 'includes network information', (done) ->
    parse payload, (err, r) ->
      no_error err
      transform 'GET /appliances/:app/configuration', r, async done, (e, r) ->
        (expect r).to.have.deep.property('configuration.network')
          .deep.equal(exp.configuration.network)

  it 'includes firewall information', (done) ->
    parse payload, (err, r) ->
      no_error err
      transform 'GET /appliances/:app/configuration', r, async done, (e, r) ->
        (expect r).to.have.deep.property('configuration.firewall')
          .deep.equal(exp.configuration.firewall)

  it 'includes configured users', (done) ->
    parse payload, (err, r) ->
      no_error err
      transform 'GET /appliances/:app/configuration', r, async done, (e, r) ->
        (expect r).to.have.deep.property('configuration.users')
          .deep.equal(exp.configuration.users)

  it 'includes configured EULAs', (done) ->
    parse payload, (err, r) ->
      no_error err
      transform 'GET /appliances/:app/configuration', r, async done, (e, r) ->
        (expect r).to.have.deep.property('configuration.eulas')
          .deep.equal(exp.configuration.eulas)

  it 'includes database configs', (done) ->
    parse payload, (err, r) ->
      no_error err
      transform 'GET /appliances/:app/configuration', r, async done, (e, r) ->
        (expect r).to.have.deep.property('configuration.databases')
          .deep.equal(exp.configuration.databases)

  it 'includes configured autostart programs', (done) ->
    parse payload, (err, r) ->
      no_error err
      transform 'GET /appliances/:app/configuration', r, async done, (e, r) ->
        (expect r).to.have.deep.property('configuration.autostarts')
          .deep.equal(exp.configuration.autostarts)

  it 'includes basic image settings', (done) ->
    parse payload, (err, r) ->
      no_error err
      transform 'GET /appliances/:app/configuration', r, async done, (e, r) ->
        (expect r).to.have.deep.property('configuration.settings')
          .deep.equal exp.configuration.settings

  it 'includes LVM config', (done) ->
    parse payload, (err, r) ->
      no_error err
      transform 'GET /appliances/:app/configuration', r, async done, (e, r) ->
        (expect r).to.have.deep.property('configuration.lvm')
          .deep.equal exp.configuration.lvm

  describe 'custom scripts', ->
    it 'includes custom build script', (done) ->
      parse payload, (err, r) ->
        no_error err
        transform 'GET /appliances/:app/configuration', r, async done, (e, r) ->
          no_error e
        (expect r).to.have.deep.property('configuration.scripts.build')
        (expect r).to.have.deep.property(
          'configuration.scripts.build.script'
        , exp.configuration.scripts.build.script
        )
        (expect r.configuration.scripts.build).to.deep.equal(
          exp.configuration.scripts.build
        )

    it 'includes custom boot script', (done) ->
      parse payload, (err, r) ->
        no_error err
        transform 'GET /appliances/:app/configuration', r, async done, (e, r) ->
          no_error e
          (expect r).to.have.deep.property 'configuration.scripts.boot'
          (expect r).to.have.deep.property \
            'configuration.scripts.boot.script'
          , exp.configuration.scripts.boot.script
          (expect r.configuration.scripts.boot).to.deep.equal \
            exp.configuration.scripts.boot

  it 'includes custom scripts', (done) ->
    parse payload, (err, r) ->
      no_error err
      transform 'GET /appliances/:app/configuration', r, async done, (e, r) ->
        (expect r).to.have.deep.property 'configuration.scripts'
        (expect r.configuration.scripts).to.deep.equal \
          exp.configuration.scripts

  it 'gives configuration of an appliance', (done) ->
    parse payload, (err, r) ->
      no_error err
      transform 'GET /appliances/:app/configuration', r, async done, (e, r) ->
        no_error e
        contains r, exp

