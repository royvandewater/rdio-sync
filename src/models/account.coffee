_ = require 'underscore'

class exports.Account
  constructor: (attributes, options={}) ->
    @table = new Account.table()
    @set(attributes ? {})

  fetch: (callback=->) =>
    Account.table.get @id, (error, @table) =>
      callback error, this

  get: (attribute) =>
    @table[attribute]

  save: (callback=->) =>
    @table.save (error, table) =>
      @id = @table.id
      callback error, this

  set: (attributes) =>
    @id = attributes.id if attributes.id?
    _.each attributes, (value, key) =>
      @table[key] = value

exports.schema =
  username: String
