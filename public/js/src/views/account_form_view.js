// Generated by CoffeeScript 1.7.1
(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  window.AccountFormView = (function(_super) {
    __extends(AccountFormView, _super);

    function AccountFormView() {
      this.values = __bind(this.values, this);
      this.submit = __bind(this.submit, this);
      this.render = __bind(this.render, this);
      this.context = __bind(this.context, this);
      this.initialize = __bind(this.initialize, this);
      return AccountFormView.__super__.constructor.apply(this, arguments);
    }

    AccountFormView.prototype.template = JST['account_form'];

    AccountFormView.prototype.initialize = function() {
      return this.listenTo(this.model, 'change', this.render);
    };

    AccountFormView.prototype.context = function() {
      return {
        model: this.model.toJSON()
      };
    };

    AccountFormView.prototype.render = function() {
      return this.$el.html(this.template(this.context()));
    };

    AccountFormView.prototype.events = {
      'submit form': 'submit'
    };

    AccountFormView.prototype.submit = function($event) {
      $event.preventDefault();
      $event.stopPropagation();
      this.model.set(this.values());
      return this.model.save();
    };

    AccountFormView.prototype.values = function() {
      return {
        number_of_tracks_to_sync: this.$('number-of-tracks').val(),
        sync_type: this.$('sync_type').val(),
        auto_sync: this.$('auto_sync').val()
      };
    };

    return AccountFormView;

  })(Backbone.View);

}).call(this);

//# sourceMappingURL=account_form_view.map
