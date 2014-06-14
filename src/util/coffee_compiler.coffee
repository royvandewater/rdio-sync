{spawn}      = require 'child_process'
_            = require 'underscore'
mapcat       = require 'mapcat'
moment       = require 'moment'
path         = require 'path'
walk         = require 'walk'


class CoffeeCompiler
  constructor: (options) ->
    {@map_output_file, @javascript_output_file} = options
    @map_file_list = []

  compile_file: (file_path) =>
    @_compile_file file_path, (error, map_file_name) =>
      return unless map_file_name?
      @_concatinate_javascript()

  compile_directory: (directory) =>
    walker = walk.walk directory
    walker.on 'file', (root, fileStats, next) =>
      file_path = path.join root, fileStats.name
      @_compile_file file_path, next

    walker.on 'end', @_concatinate_javascript

  _compile_file: (file_path, callback=->) =>
    return callback() unless _.isString file_path
    return callback() unless /\.coffee$/.test file_path

    compiler = spawn 'coffee', ['--compile', '--map', file_path]
    compiler.on 'close', =>
      map_file_dir  = path.dirname file_path
      map_file_name = "#{path.basename(file_path, '.coffee')}.map"
      map_file_path = path.join map_file_dir, map_file_name

      @map_file_list = _.union @map_file_list, [map_file_path]
      callback(null, map_file_name)

  _concatinate_javascript: =>
    mapcat.cat @map_file_list, @javascript_output_file, @map_output_file
    console.log "#{moment().format 'hh:mm:ss'} - compiled #{@javascript_output_file}"

module.exports = CoffeeCompiler
