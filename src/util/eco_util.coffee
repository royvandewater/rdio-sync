fs     = require 'fs'
eco    = require 'eco'
Walk   = require 'walk'
moment = require 'moment'

repeat = repeat = (string, count) ->
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


compile = (infile, identifier, name, callback) ->
  fs.readFile infile, "utf8", (err, source) ->
    return callback err if err
    template = indent eco.precompile(source), 2

    callback null, """
      (function() {
        this.#{identifier} || (this.#{identifier} = {});
        this.#{identifier}[#{JSON.stringify name}] = #{template.slice 2};
      }).call(this);
    """

exports.create_compiler = (source_dir, output_file) ->
  return (callback=->) ->
    output = ''
    walker = Walk.walk source_dir
    walker.on 'file', (root, fileStats, next) =>
      return next() unless /\.eco$/.test fileStats.name
      path = "#{root}#{fileStats.name}"
      name = fileStats.name[0...-4]
      compile path, 'JST', name, (error, compiled_template) =>
        output += compiled_template
        next()

    walker.on 'end', =>
      fs.writeFile output_file, output, =>
        console.log "#{moment().format 'hh:mm:ss'} - compiled #{output_file}"
        callback?()


