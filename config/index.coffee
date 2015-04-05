environment = process.env.NODE_ENV ? 'development'
EnvironmentConfig = require "./#{environment}.coffee"

class Config extends EnvironmentConfig
  @getMysqlConnectString: ->
    mysqlConnectString = process.env.MYSQL_CONNECT_STRING ? "mysql://root:@localhost/rdio_sync"

    unless process.env.MYSQL_PORT_3306_TCP_ADDR && process.env.MYSQL_PORT_3306_TCP_PORT
      return mysqlConnectString

    user = 'root'
    host = process.env.MYSQL_PORT_3306_TCP_ADDR
    port = process.env.MYSQL_PORT_3306_TCP_PORT
    password = process.env.MYSQL_ENV_MYSQL_ROOT_PASSWORD

    "mysql://#{user}:#{password}@#{host}:#{port}/rdio_sync"

Config.MYSQL_CONNECT_STRING = Config.getMysqlConnectString()

module.exports = Config
