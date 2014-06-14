fs     = require 'fs'
path   = require 'path'
eco    = require 'eco'
Walk   = require 'walk'
moment = require 'moment'
_      = require 'underscore'

class EcoCompiler
  constructor: (@output_file) ->
    @templates_cache = {}

  compile_file: (file_path) =>
    @_compile_file file_path, (error, compiled_template) =>
      return unless compiled_template?
      @concate_templates()

  _compile_file: (file_path, callback=->) =>
    return callback() unless _.isString file_path
    return callback() unless /\.eco$/.test file_path

    name = path.basename file_path, '.eco'
    compile file_path, 'JST', name, (error, compiled_template) =>
      throw error if error?

      @templates_cache[name] = compiled_template
      callback(error, compiled_template)

  compile_directory: (directory) =>
    walker = Walk.walk directory
    walker.on 'file', (root, fileStats, next) =>
      file_path = "#{root}/#{fileStats.name}"
      @_compile_file file_path, next

    walker.on 'end', @concate_templates

  concate_templates: (callback=->) =>
    output = _.values(@templates_cache).join ' '

    fs.writeFile @output_file, output, =>
      console.log "#{moment().format 'hh:mm:ss'} - compiled #{@output_file}"
      callback()

module.exports = EcoCompiler


compile_file = (filename, callback=->) ->
  return callback() unless /\.eco$/.test fileStats.name
  file_path = "#{root}#{fileStats.name}"
  name = fileStats.name[0...-4]
  compile file_path, 'JST', name, callback

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

