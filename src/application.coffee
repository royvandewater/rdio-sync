express         = require 'express'
morgan          = require 'morgan'
body_parser     = require 'body-parser'
errorhandler    = require 'errorhandler'
http            = require 'http'
path            = require 'path'
orm             = require 'orm'
Account            = require './models/account'
AccountsController    = require './controllers/accounts_controller'
AccountsApiController = require './controllers/api/v1/accounts_controller'

global.RDIO_TOKEN = [process.env['RDIO_KEY'], process.env['RDIO_SECRET']]

app = express()

app.use morgan 'dev'
app.use body_parser()
app.use express.static path.join(__dirname, '../public')

# development only
app.use errorhandler() if 'development' == app.get('env')


# Instantiate controllers

orm.connect "mysql://root:@localhost/rdio_sync", (err, database) ->
  throw err if err?
  AccountTable = database.define 'accounts', Account.schema

  database.sync ->
    accounts_controller     = new AccountsController account_table: AccountTable
    accounts_api_controller = new AccountsApiController account_table: AccountTable

    # Register URLs
    app.get  '/', (request, response) ->
      response.sendfile path.join(__dirname, '../public/index.html')

    app.post '/accounts', accounts_controller.create
    app.get  '/accounts/:account_id/login', accounts_controller.login

    app.get  '/api/v1/accounts/:account_id', accounts_api_controller.show

    app.use (req, res) ->
      return res.send 404 unless req.method == 'GET'
      res.sendfile path.join(__dirname, '../public/index.html')

    server = app.listen 3003, ->
      console.log "Express server listening on port #{server.address().port}"
