{spawn}      = require 'child_process'
fs           = require 'fs'
CoffeeScript = require 'coffee-script'
mapcat       = require 'mapcat'
Walk         = require 'walk'
_            = require 'underscore'

exports.compile_dir = (options={}) ->
  coffee_args = _.clone ['--compile', '--map']
  coffee_args.push options.directory
  compiler = spawn 'coffee', coffee_args
  compiler.on 'close', ->
    concatinate_javascript options

exports.create_compiler = (options={}) ->
  return (callback=->) ->
    new_options = _.defaults({
      done: ->
        options.done?()
        callback?()
    }, options);

    exports.compile_dir new_options

concatinate_javascript = (options={}) ->
  map_files = []
  walker = Walk.walk options.directory
  walker.on 'file', (root, file_stats, next) ->
    return next() unless /\.map$/.test file_stats.name
    map_files.push "#{root}/#{file_stats.name}"
    next()

  walker.on 'end', ->
    mapcat.cat map_files, options.javascript, options.map_file
    options.done?()

