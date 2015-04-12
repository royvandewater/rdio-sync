orm     = require 'orm'
Account = require './models/account'
Config  = require '../config'

class Command
  establishDB: (callback=->) =>
    orm.connect Config.MYSQL_CONNECT_STRING, (err, database) ->
      return callback error if error?
      Account.table = database.define 'accounts', Account.schema

      database.sync callback

  run: =>
    @establishDB (error) =>
      throw error if error?

      global.RDIO_TOKEN = [process.env.RDIO_KEY, process.env.RDIO_SECRET]
      console.log "using RDIO_TOKEN:", JSON.stringify(global.RDIO_TOKEN)
      console.log "MYSQL_CONNECT_STRING:", Config.MYSQL_CONNECT_STRING
      Account.sync_all (error) =>
        console.error error if error?
        process.exit 0

command = new Command()
command.run()
