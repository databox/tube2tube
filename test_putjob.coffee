#!./node_modules/coffee-script/bin/coffee

console.log process.argv

server = process.argv[2]
tubeName = process.argv[3]
payload = process.argv[4]

bs = require 'nodestalker'
client = bs.Client server
async = require 'async'

putToTube = (client, tube, payload)->
  client.use(tube).onSuccess (data)->
    console.log data
    client.put(payload).onSuccess (data)->
      console.log data
      client.disconnect()
      process.exit(0)



putToTube client, tubeName, payload

