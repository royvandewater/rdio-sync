express               = require 'express'
morgan                = require 'morgan'
body_parser           = require 'body-parser'
errorhandler          = require 'errorhandler'
http                  = require 'http'
socketio              = require 'socket.io'
path                  = require 'path'
orm                   = require 'orm'
Cookies               = require 'cookies'
Account               = require './models/account'
AccountsController    = require './controllers/accounts_controller'
AccountsApiController = require './controllers/api/v1/accounts_controller'

global.RDIO_TOKEN = [process.env.RDIO_KEY, process.env.RDIO_SECRET]
console.log "using RDIO_TOKEN:", JSON.stringify(global.RDIO_TOKEN)

app = express()

app.use morgan(format: 'dev')
app.use body_parser()
app.use express.static path.join(__dirname, '../public')
app.use Cookies.express 'rdio_key'

# development only
app.use errorhandler() if 'development' == app.get('env')


orm.connect "mysql://root:@localhost/rdio_sync", (err, database) ->
  throw err if err?
  AccountTable = database.define 'accounts', Account.schema

  database.sync (error) ->
    server = http.Server(app)
    io     = socketio server

    # Instantiate controllers
    accounts_controller     = new AccountsController account_table: AccountTable, io: io
    accounts_api_controller = new AccountsApiController account_table: AccountTable, io: io

    # Register URLs
    app.get  '/', (request, response) ->
      response.sendfile path.join(__dirname, '../public/index.html')

    app.post '/accounts', accounts_controller.create
    app.get  '/accounts/:account_id/login', accounts_controller.login

    app.get  '/api/v1/account', accounts_api_controller.show
    app.put  '/api/v1/account', accounts_api_controller.update

    app.use (req, res) ->
      return res.send 404 unless req.method == 'GET'
      res.sendfile path.join(__dirname, '../public/index.html')

    port = process.env.PORT ? 3004
    server.listen process, ->
      console.log "Express server listening on port #{server.address().port}"
