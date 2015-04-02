express               = require 'express'
morgan                = require 'morgan'
body_parser           = require 'body-parser'
errorhandler          = require 'errorhandler'
http                  = require 'http'
path                  = require 'path'
orm                   = require 'orm'
cors                  = require 'cors'
cookies               = require 'cookies'
Account               = require './models/account'
AccountsController    = require './controllers/accounts_controller'
AccountsApiController = require './controllers/api/v1/accounts_controller'
SessionsController    = require './controllers/sessions_controller'
Config                = require '../config'


MYSQL_CONNECT_STRING = process.env.MYSQL_CONNECT_STRING ? "mysql://root:@localhost/rdio_sync"
console.log "MYSQL_CONNECT_STRING:", MYSQL_CONNECT_STRING

global.RDIO_TOKEN = [process.env.RDIO_KEY, process.env.RDIO_SECRET]
console.log "using RDIO_TOKEN:", JSON.stringify(global.RDIO_TOKEN)

app = express()

app.use morgan(format: 'dev')
app.use body_parser()
app.use express.static path.join(__dirname, '../public')
app.use cookies.express 'rdio_key'
app.use cors origin: Config.CLIENT_URL, credentials: true

# development only
app.use errorhandler() if 'development' == app.get('env')

orm.connect MYSQL_CONNECT_STRING, (err, database) ->
  throw err if err?
  AccountTable = database.define 'accounts', Account.schema

  database.sync (error) ->
    server = http.Server(app)

    # Instantiate controllers
    accounts_controller     = new AccountsController account_table: AccountTable
    accounts_api_controller = new AccountsApiController account_table: AccountTable
    sessions_controller     = new SessionsController

    # Register URLs
    app.get  '/', (request, response) -> response.send status: 'online'

    app.get  '/accounts', accounts_controller.create
    app.post '/accounts', accounts_controller.create
    app.get  '/accounts/:account_id/login', accounts_controller.login

    app.delete '/sessions', sessions_controller.destroy

    app.get  '/api/v1/account', accounts_api_controller.show
    app.put  '/api/v1/account', accounts_api_controller.update

    port = process.env.PORT ? 3004
    server.listen port, ->
      console.log "Express server listening on port #{server.address().port}"
