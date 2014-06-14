fs        = require 'fs'
path      = require 'path'
eco       = require 'eco'
walk      = require 'walk'
moment    = require 'moment'
_         = require 'underscore'
{compile} = require './eco_util'

class EcoCompiler
  constructor: (options) ->
    @output_file = options.output_file
    @templates_cache = {}

  compile_file: (file_path) =>
    @_compile_file file_path, (error, compiled_template) =>
      return unless compiled_template?
      @_concatinate_templates()

  compile_directory: (directory) =>
    walker = walk.walk directory
    walker.on 'file', (root, fileStats, next) =>
      file_path = path.join root, fileStats.name
      @_compile_file file_path, next

    walker.on 'end', @_concatinate_templates

  _compile_file: (file_path, callback=->) =>
    return callback() unless _.isString file_path
    return callback() unless /\.eco$/.test file_path

    name = path.basename file_path, '.eco'
    compile file_path, 'JST', name, (error, compiled_template) =>
      throw error if error?

      @templates_cache[name] = compiled_template
      callback(error, compiled_template)

  _concatinate_templates: (callback=->) =>
    output = _.values(@templates_cache).join ' '

    fs.writeFile @output_file, output, =>
      console.log "#{moment().format 'hh:mm:ss'} - compiled #{@output_file}"
      callback()

module.exports = EcoCompiler
