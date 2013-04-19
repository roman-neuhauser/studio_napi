tools = require './tools'
studio = require './lib-lo'

describe 'Low-level user API:', ->

  creds = tools.config_file 'cfg/user'
  sess = studio.session user: creds

  describe 'GET /appliances/:app/configuration', ->

    it 'fails on nonexisting appliance', (done) ->

      sess GET '/appliances/:app/configuration', { app: 0 }, async done, (err, r) ->
        (expect err, 'error').to.have.property 'code', 'invalid_appliance_id'
        (expect err, 'error').to.have.property 'message'

    it 'works with existing template', (done) ->

      sess GET '/appliances/:app/configuration', { app: 1 }, async done, (err, r) ->

        no_error err
        (expect r, 'configuration').to.have.keys 'configuration'
        r = r.configuration
        (expect r, 'configuration').to.have.keys \
          'eulas'
        , 'firewall'
        , 'id'
        , 'locale'
        , 'lvm'
        , 'name'
        , 'network'
        , 'scripts'
        , 'settings'
        , 'slms'
        , 'type'
        , 'users'
        , 'version'

        (expect r.slms, 'slms').to.have.keys \
          'enabled'
        , 'gpg_key_name'
        , 'server_host'
        , 'vendor'
        (expect r.slms.enabled, 'slms.enabled').to.match /true|false/
        (expect r.slms.gpg_key_name, 'slms.gpg_key_name').to.be.a 'string'
        (expect r.slms.server_host, 'slms.server_host').to.be.a 'string'
        (expect r.slms.vendor, 'slms.vendor').to.be.a 'string'

        (expect r.locale, 'locale').to.have.keys \
          'keyboard_layout'
        , 'language'
        , 'timezone'
        (expect r.locale.timezone, 'timezone').to.have.keys \
          'location'

        (expect r.network, 'network').to.have.keys \
          'type'

        (expect r.firewall, 'firewall').to.have.keys \
          'enabled'
        , 'open_ports'
        (expect r.firewall.open_ports, 'open_ports').to.be.an 'array'

        (expect r.users, 'users').to.be.an 'array'

        (expect r.eulas, 'eulas').to.be.an 'array'

        (expect r.settings, 'settings').to.have.keys \
          'cdrom_enabled'
        , 'disk_size'
        , 'live_installer_enabled'
        , 'memory_size'
        , 'pae_enabled'
        , 'public_clonable'
        , 'runlevel'
        , 'swap_size'
        , 'webyast_enabled'
        , 'xen_host_mode_enabled'
