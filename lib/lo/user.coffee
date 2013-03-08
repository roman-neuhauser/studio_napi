common = require './common'

asis = common.asis
as_array = common.as_array
to_array = common.to_array

appliance =
  root: 'appliance'
  output: (xo) ->
    to_array xo, 'build'
    xo

template_set = (ts) ->
  ts.description = undefined unless ts.description.length
  ts.templates = ts.template || []
  delete ts.template
  ts

transforms =
  'GET /account':
    root: 'account'
    output: (xo) ->
      to_array xo, 'openid_url'
      xo

  'GET /api_version':
    root: 'version'
    output: asis

  'GET /appliances':
    root: 'appliances'
    output: (xo) ->
      xo = as_array xo.appliance
      for a in xo
        to_array a, 'build'
      xo

  'POST /appliances':
    appliance

  'GET /appliances/:app':
    appliance

  'DELETE /appliances/:app':
    root: 'success'
    output: -> true

  'GET /appliances/:app/configuration':
    root: 'configuration'
    output: (xo) ->
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
      xo

  'GET /appliances/:app/gpg_keys':
    root: 'gpg_keys'
    output: (xo) ->
      as_array xo.gpg_key

  'GET /appliances/:app/gpg_key/:key':
    root: 'gpg_key'
    output: asis

  'GET /appliances/:app/repositories':
    root: 'repositories'
    output: (xo) ->
      as_array xo.repository

  'GET /appliances/:app/sharing':
    root: 'appliance'
    output: (xo) ->
      xo.read_users = as_array xo.read_users.username
      xo

  'GET /appliances/:app/software':
    root: 'software'
    output: (xo) ->
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

  'GET /appliances/:app/status':
    root: 'status'
    output: (xo) ->
      xo.issues = as_array xo.issues.issue
      xo

  'GET /builds':
    root: 'builds'
    output: (xo) ->
      xo = as_array xo.build
      xo

  'GET /builds/:bld':
    root: 'build'
    output: (xo) ->
      xo.profile.steps = xo.profile.steps.step
      xo

  'GET /files':
    root: 'files'
    output: (xo) ->
      as_array xo.file

  'GET /files/:file':
    root: 'file'
    output: asis

  'GET /repositories':
    root: 'repositories'
    output: (xo) ->
      as_array xo.repository

  'GET /repositories/:repo':
    root: 'repository'
    output: asis

  'GET /rpms':
    root: 'rpms'
    output: (xo) ->
      xo.base_system = xo['@'].base_system
      delete xo['@']
      xo.rpms = as_array xo.rpm
      for r in xo.rpms
        r.base_system = xo.base_system
      delete xo.rpm
      xo

  'GET /rpms/:rpm':
    root: 'rpm'
    output: asis

  'GET /running_builds':
    root: 'running_builds'
    output: (xo) ->
      as_array xo.running_build

  'GET /running_builds/:bld':
    root: 'running_build'
    output: asis

  'GET /template_sets':
    root: 'template_sets'
    output: (xo) ->
      xo = as_array xo.template_set
      for ts in xo
        template_set ts
      xo

  'GET /template_sets/:set':
    root: 'template_set'
    output: template_set

  'POST /testdrives':
    root: 'testdrive'
    output: asis

  'GET /testdrives':
    root: 'testdrives'
    output: (xo) ->
      as_array xo.testdrive


exports.api = common.api transforms
exports.transform = common.transform transforms

