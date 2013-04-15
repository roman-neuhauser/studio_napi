common = require './common'

asis = common.asis
as_array = common.as_array
to_array = common.to_array

stringize = (xo, name) ->
  xo[name] = '' unless xo[name]?.length
  xo

appliance = (xo) ->
    to_array xo.appliance, 'build'
    xo

template_set = (ts) ->
  ts.description = undefined unless ts.description.length
  ts.templates = ts.template || []
  delete ts.template
  ts

transforms =
  'GET /account':
    response: (sig, xo, done) ->
      output = (xo) ->
        to_array xo, 'openid_url'
      done undefined, account:
        output xo.account

  'GET /api_version':
    response: (sig, xo, done) ->
      done undefined, xo

  'GET /appliances':
    response: (sig, xo, done) ->
      output = (xo) ->
        xo = as_array xo.appliance
        for a in xo
          to_array a, 'build'
        xo
      done undefined, appliances:
        output xo.appliances

  'POST /appliances':
    response: (sig, xo, done) ->
      done undefined, appliance xo

  'GET /appliances/:app':
    response: (sig, xo, done) ->
      done undefined, appliance xo

  'DELETE /appliances/:app':
    response: (sig, xo, done) ->
      done undefined, success: true

  'GET /appliances/:app/configuration':
    response: (sig, xo, done) ->
      output = (xo) ->
        to_array xo, 'tag'
        xo.firewall.open_ports = as_array xo.firewall.open_port
        delete xo.firewall.open_port
        to_array xo, 'user'
        to_array xo, 'eula'
        to_array xo, 'database'
        if 'databases' of xo
          for d in xo.databases
            to_array d, 'user'
        to_array xo, 'autostart'
        if xo.settings.pae_enabled not instanceof String
          xo.settings.pae_enabled = 'false'
        if xo.lvm.volumes
          xo.lvm.volumes = as_array xo.lvm.volumes.volume
        if xo.slms
          for p in 'gpg_key_name server_host vendor'.split ' '
            stringize xo.slms, p
        xo
      done undefined, configuration:
        output xo.configuration

  'GET /appliances/:app/configuration/logo':
    response:
      on

  'PUT /appliances/:app/configuration':
    request:
      input: (ji) ->
        xml = require './xml'
        xml.builder ji, (tag) ->
          tag 'configuration', (tag) ->
            tag 'id'
            tag 'name'
            tag 'version'
            tag 'type'
            tag 'locale', (tag) ->
              tag 'keyboard_layout'
              tag 'language'
              tag 'timezone', (tag) ->
                tag 'location'
            tag 'network', (tag) ->
              tag 'type'
            tag 'firewall', (tag, ji) ->
              tag 'enabled'
              tag 'open_port', port for port in ji.open_ports
            tag 'users', (tag, ji) ->
              for user in ji
                tag 'user', user, (tag) ->
                  tag 'uid'
                  tag 'name'
                  tag 'password'
                  tag 'group'
                  tag 'shell'
                  tag 'homedir'
              count: ji.length
            tag 'eulas', (tag, ji) ->
              tag 'eula', eula for eula in ji
              count: ji.length
            tag 'settings', (tag) ->
              tag 'memory_size'
              tag 'disk_size'
              tag 'swap_size'
              tag 'pae_enabled'
              tag 'xen_host_mode_enabled'
              tag 'cdrom_enabled'
              tag 'webyast_enabled'
              tag 'live_installer_enabled'
              tag 'public_clonable'
              tag 'runlevel'
            tag 'lvm', (tag) ->
              tag 'enabled'
            tag 'scripts', (tag) ->
              tag 'build', (tag, ji) ->
                tag 'enabled'
                tag 'script' if ji.enabled is 'true'
              tag 'boot', (tag, ji) ->
                tag 'enabled'
                tag 'script' if ji.enabled is 'true'
              tag 'autoyast', (tag, ji) ->
                tag 'enabled'
                tag 'script' if ji.enabled is 'true'

    response:
      root: 'success'
      output: -> true

  'GET /appliances/:app/gpg_keys':
    response: (sig, xo, done) ->
      output = (xo) ->
        as_array xo.gpg_key
      done undefined, gpg_keys:
        output xo.gpg_keys

  'GET /appliances/:app/gpg_key/:key':
    response: (sig, xo, done) ->
      done undefined, xo

  'GET /appliances/:app/repositories':
    response: (sig, xo, done) ->
      output = (xo) ->
        as_array xo.repository
      done undefined, repositories:
        output xo.repositories

  'GET /appliances/:app/sharing':
    response: (sig, xo, done) ->
      output = (xo) ->
        xo.read_users = as_array xo.read_users.username
        xo
      done undefined, appliance:
        output xo.appliance

  'GET /appliances/:app/software':
    response: (sig, xo, done) ->
      output = (xo) ->
        fix = (p) ->
          if p['#'] then { name: p['#'], version: p['@'].version }
          else { name: p }

        packages = (fix(p) for p in xo.package)
        packages.sort (l, r) ->
          l.name.localeCompare r.name
        xo.pattern.sort (l, r) ->
          l.localeCompare r

        {
          appliance_id: xo['@'].appliance_id
          patterns: xo.pattern
          packages: packages
        }

      done undefined, software:
        output xo.software

  'GET /appliances/:app/status':
    response: (sig, xo, done) ->
      output = (xo) ->
        xo.issues = as_array xo.issues.issue
        xo
      done undefined, status:
        output xo.status

  'GET /builds':
    response: (sig, xo, done) ->
      output = (xo) ->
        xo = as_array xo.build
        xo
      done undefined, builds:
        output xo.builds

  'GET /builds/:bld':
    response: (sig, xo, done) ->
      output = (xo) ->
        xo.profile.steps = xo.profile.steps.step
        xo
      done undefined, build:
        output xo.build

  'GET /files':
    response: (sig, xo, done) ->
      output = (xo) ->
        as_array xo.file
      done undefined, files:
        output xo.files

  'GET /files/:file':
    response: (sig, xo, done) ->
      done undefined, xo

  'GET /repositories':
    response: (sig, xo, done) ->
      output = (xo) ->
        as_array xo.repository
      done undefined, repositories:
        output xo.repositories

  'GET /repositories/:repo':
    response: (sig, xo, done) ->
      done undefined, xo

  'GET /rpms':
    response: (sig, xo, done) ->
      output = (xo) ->
        xo.base_system = xo['@'].base_system
        delete xo['@']
        xo.rpms = as_array xo.rpm
        for r in xo.rpms
          r.base_system = xo.base_system
        delete xo.rpm
        xo
      done undefined, rpms:
        output xo.rpms

  'GET /rpms/:rpm':
    response: (sig, xo, done) ->
      done undefined, xo

  'GET /running_builds':
    response: (sig, xo, done) ->
      output = (xo) ->
        as_array xo.running_build
      done undefined, running_builds:
        output xo.running_builds

  'GET /running_builds/:bld':
    response: (sig, xo, done) ->
      done undefined, xo

  'GET /template_sets':
    response: (sig, xo, done) ->
      output = (xo) ->
        xo = as_array xo.template_set
        for ts in xo
          template_set ts
        xo
      done undefined, template_sets:
        output xo.template_sets

  'GET /template_sets/:set':
    response: (sig, xo, done) ->
      done undefined, template_set:
        template_set xo.template_set

  'POST /testdrives':
    response: (sig, xo, done) ->
      done undefined, xo

  'GET /testdrives':
    response: (sig, xo, done) ->
      output = (xo) ->
        as_array xo.testdrive
      done undefined, testdrives:
        output xo.testdrives

  'GET /gallery/appliances':
    response: (sig, xo, done) ->
      output = (apps) ->
        for app in apps
          stringize app, 'homepage'
          stringize app, 'description'
        apps
      done undefined, gallery: appliances:
        output xo.gallery.appliances.appliance

  'GET /gallery/appliances/:app':
    response: (sig, xo, done) ->
      output = (app) ->
        old = as_array app.formats.format
        formats = {}
        for f in old
          formats[f['#']] = f['@'].md5
        app.formats = formats
        app.configuration.accounts = app.configuration.accounts.account
        '
          based_on
          description
          homepage
          id
          name
          publisher
          release_notes
          username
          version
        '.trim().split(/\s+/).forEach (p) -> stringize app, p
        app.locale = {
          keyboard_layout: app.keyboard_layout
          language: app.language
          timezone: app.timezone
        }
        delete app.keyboard_layout
        delete app.language
        delete app.timezone
        app.firewall.open_ports = as_array app.firewall.open_port
        delete app.firewall.open_port
        app
      done undefined, gallery: appliance:
        output xo.gallery.appliance

  'GET /gallery/appliances/:app/comments':
    response: (sig, xo, done) ->
      output = (app) ->
        app.comments = as_array app.comments.comment
        app
      done undefined, gallery: appliance:
        output xo.gallery.appliance

  'GET /gallery/appliances/:app/rating':
    response: (sig, xo, done) ->
      done undefined, xo

  'GET /gallery/appliances/:app/software':
    response: (sig, xo, done) ->
      output = (app) ->
        repos = {}
        old = as_array app.repositories.repository
        for r in old
          repos[r['#']] = r['@']

        rv =
          id: app.id
          repositories: repos

        for prop in ['selected_software', 'installed_software']
          sw = app[prop]
          rv[prop] = {}

          for t in ['pattern', 'package']
            old = as_array sw[t]
            fix = {}
            for p, i in old
              fix[p['#']] =
                version: p['@'].version
                from: p['@'].repository
            rv[prop]["#{t}s"] = fix

        rv

      done undefined, gallery: appliance:
        output xo.gallery.appliance

  'GET /gallery/appliances/:app/testdrive':
    response: (sig, xo, done) ->
      done undefined, xo

  'GET /gallery/appliances/:app/versions':
    response: (sig, xo, done) ->
      output = (app) ->
        to_array app, 'version'
      done undefined, gallery: appliance:
        output xo.gallery.appliance

exports.transforms = transforms
exports.api = common.api transforms

