moment = require 'moment'

class SessionsController
  destroy: (request, response) =>
    response.cookies.set 'rdio_key', null, expires: moment().subtract('minutes', 1).toDate(), httpOnly: false
    response.send null, 204

module.exports = SessionsController
