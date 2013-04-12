tools = require '../../tools'
user = require '../lib-lo-user'
xml = require '../lib-lo-xml'

exports.transform = xml.to_js user.transforms

exports.parse = tools.parseXML
