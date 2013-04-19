{parse, transform} = require './setup'

describe 'XML -> POJO xforms, user: GET /gallery/appliances', ->

  it 'lists all appliances of the current user', (done) ->
    parse 'tests/user/GET_gallery_appliances.xml', (err, r) ->
      no_error err
      transform 'GET /gallery/appliances', r, async done, (e, r) ->
        no_error e
        contains r, gallery: { appliances: [
          {
            id: "22"
            name: "Matt's Amazing JeOS"
            publisher: "Matt Barringer"
            username: "mbarringer"
            homepage: "http://susestudio.com"
            description: "THIS IS AN AWESOME JEOS APPLIANCE DOWNLOAD"
            ratings: "2"
            average_rating: "3.0"
            comments: "2"
            based_on: "11.3"
            date: "2010-11-03 13:57:02 UTC"
          }
          {
            id: "25"
            name: "The Greatest JeOS EVER"
            publisher: "SUSE Studio Team"
            username: "steam"
            homepage: ""
            description: ""
            ratings: "0"
            average_rating: "0.0"
            comments: "0"
            based_on: "11.3"
            date: "2010-10-15 11:28:00 UTC"
          }
          {
            id: "20"
            name: "Matt's KDE 4 desktop"
            publisher: "Matt Barringer"
            username: "mbarringer"
            homepage: "http://kde.org"
            description: "This is a KDE 4 descktop"
            ratings: "0"
            average_rating: "0.0"
            comments: "2"
            based_on: "11.3"
            date: "2010-10-07 14:01:04 UTC"
          }
          {
            id: "24"
            name: "LAMP Server"
            publisher: "Matt Barringer"
            username: "mbarringer"
            homepage: "http://susestudio.com"
            description: """This is a LAMP server.

      It provides Linux, Apache, MySQL, and Perl."""
            ratings: "0"
            average_rating: "0.0"
            comments: "0"
            based_on: "11.3"
            date: "2010-10-14 14:09:05 UTC"
          }
        ] }

