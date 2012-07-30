sinon = require 'sinon'
tools = require '../tools'
studio = require '../../lib/hi/common'

describe 'High-level Admin API:', ->

  methods = '''
    about
    active_users
    job_history
    running_jobs
    summary
    health_check
  '''.split /\s+/

  describe 'method presence', ->

    admin =

    beforeEach () ->
      admin = studio.session admin:
        url: 'http://susestudio.com/api/admin'
        user: 'rneuhauser'
        key: 'ELaM8usq3Ryb'

    for meth in methods

      do (meth) ->
        it "has #{meth}() method", (done) ->
          (expect admin, 'admin').to.have.property(meth)
            .that.is.a('function')
          done()

  describe 'argument passing', ->

    for meth in methods

      do (meth) ->
        describe "#{meth}()", ->

          it "uses GET /#{meth}", (done) ->
            apimpl = sinon.stub().callsArg(2)

            admin = studio.session { admin:
              url: 'http://susestudio.com/api/admin'
              user: 'rneuhauser'
              key: 'ELaM8usq3Ryb'
            }
            , (a) -> apimpl a...

            admin[meth] (err, r) ->
              no_error err
              (expect apimpl.calledWith 'GET', "/#{meth}").to.be.true
              done()

