#!./node_modules/coffee-script/bin/coffee

config = require './config'
async = require 'async'
_ = require 'lodash'
bs = require 'nodestalker'

class Forward
  constructor: (@rule)->
    [@from, @to] = @parseRule(@rule)
    console.log "Forwarding #{@rule}"

  parseRule: (rule)->
    [from, to] = _.map _.map(rule.split('->', 2), _.trim), (dns)->
      [server, tube] = dns.split('/', 2)
      client: bs.Client(server)
      tube: tube

  run: ()=>
    from_client = @from.client
    to_client = @to.client
    from_tube = @from.tube
    to_tube = @to.tube

    from_client.watch(from_tube).onSuccess (data)->
      to_client.use(to_tube).onSuccess (toData)->
        resJob = ->
          from_client.reserve().onSuccess (job)->
            console.log "Reserved #{from_tube}", job.id

            to_client.put(job.data).onSuccess (fwdData)->
              console.log "Forwarded #{from_tube} -> #{to_tube}", fwdData

              from_client.deleteJob(job.id).onSuccess (delMsg)->
                console.log "Deleted #{from_tube}", job.id
                resJob()
            true
          true
        resJob()
      true

forwarders = _.map config.get('rules'), (ruleLine)-> new Forward(ruleLine)

async.parallel _.map(forwarders, 'run'), (err, results)->
  if err?
    console.error(err)
    process.exit(1)

  console.log results