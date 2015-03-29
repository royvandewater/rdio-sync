orm     = require 'orm'
Account = require './models/account'

class Command
  establishDB: (callback=->) =>
    orm.connect "mysql://root:@localhost/rdio_sync", (err, database) ->
      return callback error if error?
      Account.table = database.define 'accounts', Account.schema

      database.sync callback

  run: =>
    @establishDB (error) =>
      throw error if error?

      global.RDIO_TOKEN = [process.env.RDIO_KEY, process.env.RDIO_SECRET]
      Account.sync_all (error) =>
        console.error error if error?
        process.exit 0

command = new Command()
command.run()
