fs = require 'fs'
clone = require 'clone'
xml = require '../lib-lo-xml'
user = require '../lib-lo-user'
tools = require '../../tools'

endpoint = 'PUT /appliances/:app/configuration'
jsonfile = 'tests/user/PUT_appliance_configuration.json'
xmlfile  = 'tests/user/PUT_appliance_configuration.xml'

# the regexp-based tests are just preliminary checks,
# i keep them because the deep.equal later on is
# unintelligible when if fails.

describe "POJO -> XML xforms, user: #{endpoint}", ->

  j2x = xml.from_js user.transforms
  x2j = xml.to_js   user.transforms

  it 'gives information about the account', (done) ->
    tools.parseJSON jsonfile, (err, jsobj) ->
      no_error err
      xmlstr = j2x endpoint, jsobj
      (expect xmlstr, 'xml result').to.match /^<configuration>/
      (expect xmlstr, 'xml result').to.match /<\/configuration>$/
      (expect xmlstr, 'xml result').to.match /<id>892<\/id>/
      (expect xmlstr, 'xml result').to.match /<id>892<\/id>/
      (expect xmlstr, 'xml result').to.match /<name>Roman's JeOS<\/name>/
      (expect xmlstr, 'xml result').to.match /<version>0.0.6<\/version>/
      (expect xmlstr, 'xml result').to.match /<type>oemstick<\/type>/
      (expect xmlstr, 'xml result').to.match /<users count="1">/
      (expect xmlstr, 'xml result').to.match ///
        <user>
          <uid>0</uid>
          <name>root</name>
          <password>linux</password>
          <group>root</group>
          <shell>/bin/bash</shell>
          <homedir>/root</homedir>
        </user>
      ///
      xml.parse xmlstr, (err, xmltree) ->
        no_error err
        x2j (endpoint.replace 'PUT', 'GET'), xmltree, (err, jsobj2) ->
          no_error err
          (expect jsobj2, 'roundtrip result').to.deep.equal jsobj
          do done

