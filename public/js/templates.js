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
}).call(this);