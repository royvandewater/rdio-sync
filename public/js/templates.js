(function() {
  this.JST || (this.JST = {});
  this.JST["home"] = function(__obj) {
  if (!__obj) __obj = {};
  var __out = [], __capture = function(callback) {
    var out = __out, result;
    __out = [];
    callback.call(this);
    result = __out.join('');
    __out = out;
    return __safe(result);
  }, __sanitize = function(value) {
    if (value && value.ecoSafe) {
      return value;
    } else if (typeof value !== 'undefined' && value != null) {
      return __escape(value);
    } else {
      return '';
    }
  }, __safe, __objSafe = __obj.safe, __escape = __obj.escape;
  __safe = __obj.safe = function(value) {
    if (value && value.ecoSafe) {
      return value;
    } else {
      if (!(typeof value !== 'undefined' && value != null)) value = '';
      var result = new String(value);
      result.ecoSafe = true;
      return result;
    }
  };
  if (!__escape) {
    __escape = __obj.escape = function(value) {
      return ('' + value)
        .replace(/&/g, '&amp;')
        .replace(/</g, '&lt;')
        .replace(/>/g, '&gt;')
        .replace(/"/g, '&quot;');
    };
  }
  (function() {
    (function() {
      __out.push('<div class="jumbotron">\n  <h1>Auto sync your best Rdio music!</h1>\n  <p class="lead">Reduce mobile data usage and ensure you\'re never caught without good music again.</p>\n  <form action="accounts" class="form-signin" method="POST">\n    <input type="submit" value="Login with Rdio" class="btn btn-large btn-primary">\n  </form>\n</div>\n\n<hr>\n\n<div class="row marketing">\n  <div class="col-xs-12 col-md-6">\n    <h4>Automatically Sync</h4>\n    <p>Sink will detect your top played songs and automatically mark them for \'sync to mobile\'</p>\n\n    <h4>Choose Your Level of Syncitude</h4>\n    <p>Once logged in, your account manage page will let you configure how many songs will auto sync to your account</p>\n\n    <h4>The Magic Begins at Midnight</h4>\n    <p>You can sync manually at any time, but the real magic is the automatic one that occurs every night at midnight</p>\n  </div>\n\n  <div class="col-xs-12 col-md-6">\n    <h4>Reduce Your Mobile Data Usage</h4>\n    <p>Take a look at your mobile data usage. Most of it\'s Rdio, and most of it is from streaming the same few songs over and over again. Why not cache them on your phone?</p>\n\n    <h4>Don\'t Be Without Good Music</h4>\n    <p>Life\'s to short to spend it in silence. Let Sink manage which songs sync and you\'ll be sure to have kick ass tunes, even in the middle of nowhere</p>\n  </div>\n</div>\n\n');
    
    }).call(this);
    
  }).call(__obj);
  __obj.safe = __objSafe, __obj.escape = __escape;
  return __out.join('');
};
}).call(this); (function() {
  this.JST || (this.JST = {});
  this.JST["show"] = function(__obj) {
  if (!__obj) __obj = {};
  var __out = [], __capture = function(callback) {
    var out = __out, result;
    __out = [];
    callback.call(this);
    result = __out.join('');
    __out = out;
    return __safe(result);
  }, __sanitize = function(value) {
    if (value && value.ecoSafe) {
      return value;
    } else if (typeof value !== 'undefined' && value != null) {
      return __escape(value);
    } else {
      return '';
    }
  }, __safe, __objSafe = __obj.safe, __escape = __obj.escape;
  __safe = __obj.safe = function(value) {
    if (value && value.ecoSafe) {
      return value;
    } else {
      if (!(typeof value !== 'undefined' && value != null)) value = '';
      var result = new String(value);
      result.ecoSafe = true;
      return result;
    }
  };
  if (!__escape) {
    __escape = __obj.escape = function(value) {
      return ('' + value)
        .replace(/&/g, '&amp;')
        .replace(/</g, '&lt;')
        .replace(/>/g, '&gt;')
        .replace(/"/g, '&quot;');
    };
  }
  (function() {
    (function() {
      __out.push('<!DOCTYPE html>\n<html>\n<head>\n  <title>Sink</title>\n  <meta charset="utf-8">\n  <meta http-equiv="X-UA-Compatible" content="IE=edge">\n  <meta name="viewport" content="width=device-width, initial-scale=1">\n  <link rel="stylesheet" type="text/css" href="//cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/3.1.1/css/bootstrap.min.css">\n  <link rel="stylesheet" type="text/css" href="/styles.css">\n</head>\n<body>\n\n<div class="container">\n  <div id="navigation">\n    <div class="masthead">\n      <ul class="nav nav-pills pull-right">\n        <li><a href="/">Home</a></li>\n        <li></li>\n      </ul>\n      <h3>\n        <a href="/" class="brand muted">Sink</a>\n      </h3>\n    </div>\n  </div>\n\n  <hr>\n\n  <h3>Sync Settings</h3>\n\n  <p>Manage what syncs to account: <strong>');
    
      __out.push(__sanitize(this.username));
    
      __out.push('</strong></p>\n\n  <hr>\n\n  <form class="form-horizontal">\n    <div class="form-group">\n      <label class="control-label col-lg-2" for="number-of-tracks-');
    
      __out.push(__sanitize(this.cid));
    
      __out.push('">Number of tracks:</label>\n      <div class="col-lg-10">\n        <input type="number" id="number-of-tracks-');
    
      __out.push(__sanitize(this.cid));
    
      __out.push('" class="number-of-tracks form-control" value="');
    
      __out.push(__sanitize(this.number_of_tracks_to_sync));
    
      __out.push('">\n      </div>\n    </div>\n\n    <div class="form-group">\n      <label class="control-label col-lg-2" for="sync-type-');
    
      __out.push(__sanitize(this.cid));
    
      __out.push('">Sync your:</label>\n      <div class="col-lg-10">\n        <select id="sync-type-');
    
      __out.push(__sanitize(this.cid));
    
      __out.push('" class="sync-type form-control">\n          <option value="playCount">Most played tracks</option>\n          <option value="dateAdded">Most recently added tracks</option>\n          <option value="both">Half and Half</option>\n        </select>\n      </div>\n    </div>\n\n    <div class="form-group">\n      <div class="col-lg-offset-2 col-lg-10">\n        <label class="checkbox">\n          <input type="checkbox" class="auto-sync" ');
    
      if (this.auto_sync) {
        __out.push(__sanitize('checked="checked"'));
      }
    
      __out.push('>Auto Sync\n          <br>\n          <span class="label label-danger">Read Warning Below</span>\n        </label>\n      </div>\n    </div>\n\n    <div class="form-group">\n      <div class=\'control-label col-lg-2\'>\n        ');
    
      if (this.loading) {
        __out.push('\n            <img src="/ajax-loader.gif" alt="loading">\n        ');
      }
    
      __out.push('\n      </div>\n      <div class="col-lg-10">\n        <button type="submit" class="btn btn-primary">Save</button>\n        <a href="#" class="sync btn btn-danger">Sync</a>\n      </div>\n    </div>\n  </form>\n\n  <div class="alert alert-danger">\n    <h4>Important!</h4>\n    Pressing sync will wipe out all tracks currently marked for offline use and replace them\n    with your most played tracks, limited by the number of tracks you indicated. There is no way\n    to undo this action.\n    <br><br>\n    Auto Sync means that Sink will perform this action every night at midnight.\n  </div>\n\n  <div class="footer">\n    <p>© Sink 2013</p>\n  </div>\n</div>\n\n<script type="text/javascript" src="//cdnjs.cloudflare.com/ajax/libs/jquery/2.1.1/jquery.min.js"></script>\n<script type="text/javascript" src="//cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/3.1.1/js/bootstrap.min.js"></script>\n</body>\n</html>\n\n');
    
    }).call(this);
    
  }).call(__obj);
  __obj.safe = __objSafe, __obj.escape = __escape;
  return __out.join('');
};
}).call(this);