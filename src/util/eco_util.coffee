fs  = require 'fs'
eco = require 'eco'

repeat = (string, count) ->
  Array(count + 1).join string

indent = (string, width) ->
  space = repeat " ", width
  lines = (space + line for line in string.split "\n")
  lines.join "\n"

trim = (string) ->
  string
    .replace(/^\s+/, "")
    .replace(/\s+$/, "")

specialCharacters =
  '\\': '\\\\'
  '\b': '\\b'
  '\f': '\\f'
  '\n': '\\n'
  '\r': '\\r'
  '\t': '\\t'

inspectString = (string) ->
  contents = string.replace /[\x00-\x1f\\]/g, (character) ->
    if character of specialCharacters
      specialCharacters[character]
    else
      code = character.charCodeAt(0).toString(16)
      code = "0#{code}" if code.length is 1
      "\\u00#{code}"
  "'" + contents.replace(/'/g, '\\\'') + "'"


exports.compile = (infile, identifier, name, callback) ->
  fs.readFile infile, "utf8", (err, source) ->
    return callback err if err
    template = indent eco.precompile(source), 2

    callback null, """
      (function() {
        this.#{identifier} || (this.#{identifier} = {});
        this.#{identifier}[#{JSON.stringify name}] = #{template.slice 2};
      }).call(this);
    """
