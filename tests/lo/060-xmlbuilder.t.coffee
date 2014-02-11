expect = (require 'chai').expect

xml = require './lib-lo-xml'

describe 'XML builder:', ->

  it 'calls the second argument with two arguments', ->
    result = xml.builder {}, ->
      (expect arguments.length, 'number of arguments').to.equal 2
      null

  it 'gives the function a function', ->
    xml.builder {}, (tag, ji) ->
      (expect (typeof tag), 'typeof first arg').to.equal 'function'
      null

  it 'gives the function the javascript object to transform', ->
    data = { foo: 'bar' }
    result = xml.builder data, (tag, ji) ->
      (expect ji, 'second arg').to.equal data
      null

  describe 'tag function:', ->

    ###
    xml.builder data, (tag) ->
      tag name

    xml.builder data, (tag) ->
      tag name, attrs

    xml.builder data, (tag) ->
      tag name, value

    xml.builder data, (tag) ->
      tag name, data, (tag) ->
        @append text
        attrs

    xml.builder data, (tag) ->
      tag name, data, (tag) ->
        tag name
        tag name
        attrs
    ###

    describe 'discerns tag contents:', ->

      data = rofl: 'lmao'

      it 'emits a tag named after the first argument', ->
        result = xml.builder data, (tag) ->
          tag 'rofl'
        (expect result, 'xml.builder result').to.match \
          ///<rofl>.*</rofl>///

      it 'uses a property from the javascript object', ->
        result = xml.builder data, (tag) ->
          tag 'rofl'
        (expect result, 'xml.builder result').to.equal \
          '<rofl>lmao</rofl>'

      it 'uses empty string for a missing property', ->
        result = xml.builder rofl: 'lmao', (tag) ->
          tag 'wtf'
        (expect result, 'xml.builder result').to.equal \
          '<wtf/>'

    describe 'uses provided value for tag contents:', ->

      it 'emits a tag named after the first argument', ->
        result = xml.builder {}, (tag) ->
          tag 'rofl', 'lmao'
        (expect result, 'xml.builder result').to.match \
          ///<rofl>.*</rofl>///

      describe 'second argument, scalar:', ->

        it 'uses the second argument for tag contents', ->
          result = xml.builder {}, (tag) ->
            tag 'rofl', 'lmao'
          (expect result, 'xml.builder result').to.equal \
            '<rofl>lmao</rofl>'

      describe 'second argument, function:', ->

        it 'uses the second argument for tag contents', ->
          result = xml.builder {}, (tag) ->
            tag 'omg', (tag) ->
              tag 'wtf', (tag) ->
                tag 'orly', 'srsly'
                tag 'rofl', 'lmao'
          (expect result, 'xml.builder result').to.equal \
            '<omg><wtf><orly>srsly</orly><rofl>lmao</rofl></wtf></omg>'

    describe 'setting attributes:', ->

      describe 'for empty tag', ->

        it 'embeds attributes', ->
          result = xml.builder rofl: 'lmao', (tag) ->
            tag 'foo', bar: 'qux'
          (expect result, 'xml.builder result').to.equal \
            '<foo bar="qux"/>'

        it 'sets attributes of current tag', ->
          result = xml.builder rofl: 'lmao', (tag) ->
            tag 'rofl', (tag) ->
              foo: 'bar', baz: 'qux'
          (expect result, 'xml.builder result').to.equal \
            '<rofl foo="bar" baz="qux"/>'

      describe 'for tag with text', ->

        it 'embeds attributes', ->
          result = xml.builder rofl: 'lmao', (tag) ->
            tag 'rofl', omg: 'wtf'
          (expect result, 'xml.builder result').to.equal \
            '<rofl omg="wtf">lmao</rofl>'

        it 'sets attributes of current tag', ->
          result = xml.builder rofl: 'lmao', (tag) ->
            tag 'rofl', (tag, ji) ->
              @append ji
              foo: 'bar', baz: 'qux'
          (expect result, 'xml.builder result').to.equal \
            '<rofl foo="bar" baz="qux">lmao</rofl>'

      describe 'nesting', ->

        it 'works', ->
          result = xml.builder {}, (tag) ->
            tag 'rofl', (tag) ->
              tag 'omg', (tag) ->
                @append 'wtf'
                foo: 'qux', baz: 'bar'
              @append 'lmao'
              foo: 'bar', baz: 'qux'
          (expect result, 'xml.builder result').to.equal \
            '<rofl foo="bar" baz="qux">'            +
              '<omg foo="qux" baz="bar">wtf</omg>'  +
              'lmao'                                +
            '</rofl>'

  describe 'tag callback behavior:', ->

      it 'gives nested call a subtree of the javascript object', ->
        input = foo: bar: baz: 'qux'
        xml.builder input, (tag, ji) ->
          tag 'foo', (tag, ji) ->
            (expect ji, 'foo subtree').to.equal input.foo
            null
            tag 'bar', (tag, ji) ->
              (expect ji, 'foo.bar subtree').to.equal input.foo.bar
              null
              tag 'baz', (tag, ji) ->
                (expect ji, 'foo.bar.baz subtree').to.equal input.foo.bar.baz
                null

  describe '@CDATA:', ->

    it 'wraps argument', ->
      input = 'hello <[]>][<! world'
      output = xml.builder {}, (tag) ->
        tag 'x', @CDATA input
      (expect output, 'xml.builder result').to.equal \
        "<x><![CDATA[#{input}]]></x>"

    it 'produces multiple CDATA sections if needed', ->
      input = 'end of CDATA is -> "]]>" <- that'
      output = xml.builder {}, (tag) ->
        tag 'x', @CDATA input
      (expect output, 'xml.builder result').to.equal \
        '<x><![CDATA[end of CDATA is -> "]]]]><![CDATA[>" <- that]]></x>'

  it 'works', ->
    data =
      configuration:
        id: 42
        name: 'fubar'
        version: '1.2.3'
        locale:
          keyboard_layout: 'english-us'
          language: 'POSIX'
          timezone:
            location: 'UTC'
        network:
          type: 'dhcp'
        firewall:
          enabled: 'false'
          open_ports: [ 'ssh', 'http' ]
        users: [
          { uid: 0, name: 'root' }
          { uid: 1, name: 'leaf' }
        ]
        scripts:
          build:
            enabled: 'true'
            script: """
            [[ -z "" ]]> /dev/null </dev/null && exit
            """

    output = xml.builder data, (tag) ->
      tag 'configuration', (tag) ->
        tag 'id'
        tag 'name'
        tag 'version'
        tag 'locale', (tag) ->
          tag 'language'
          tag 'timezone', (tag) ->
            tag 'location'
        tag 'firewall', (tag, ji) ->
          tag 'enabled'
          tag 'open_port', port for port in ji.open_ports
        tag 'users', (tag, users) ->
          for user in users
            tag 'user', user, (tag) ->
              tag 'uid'
              tag 'name'
          count: users.length
        tag 'scripts', (tag) ->
          tag 'build', (tag, ji) ->
            tag 'enabled'
            tag 'script', @CDATA ji.script

    (expect output, 'xml output').to.equal \
      '<configuration>'                 +
        '<id>42</id>'                   +
        '<name>fubar</name>'            +
        '<version>1.2.3</version>'      +
        '<locale>'                      +
          '<language>POSIX</language>'  +
          '<timezone>'                  +
            '<location>UTC</location>'  +
          '</timezone>'                 +
        '</locale>'                     +
        '<firewall>'                    +
          '<enabled>false</enabled>'    +
          '<open_port>ssh</open_port>'  +
          '<open_port>http</open_port>' +
        '</firewall>'                   +
        '<users count="2">'             +
          '<user>'                      +
            '<uid>0</uid>'              +
            '<name>root</name>'         +
          '</user>'                     +
          '<user>'                      +
            '<uid>1</uid>'              +
            '<name>leaf</name>'         +
          '</user>'                     +
        '</users>'                      +
        '<scripts>'                     +
          '<build>'                     +
            '<enabled>true</enabled>'   +
            '<script>'                  +
              '<![CDATA[[[ -z "" ]]]]>' +
              '<![CDATA[> /dev/null </dev/null && exit]]>' +
            '</script>'                 +
          '</build>'                    +
        '</scripts>'                    +
      '</configuration>'
