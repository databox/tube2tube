config = require 'nconf'
path = require 'path'

env = process.env.NODE_ENV || 'development'

config.use 'file', file: path.join(__dirname, "./config/#{env}.json")

module.exports = exports = config