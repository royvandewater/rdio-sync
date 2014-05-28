class exports.Account
  constructor: (attributes, options={}) ->
    @table = new options.table attributes

  save: (callback=->) =>
    @table.save (error) =>
      throw error if error?
      @id = @table.id
      callback()

exports.schema = {}
