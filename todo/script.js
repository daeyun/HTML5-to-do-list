// Generated by CoffeeScript 1.4.0
(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  jQuery(function() {
    var Item, ItemView, ListView, TodoList, list_view;
    Item = (function(_super) {

      __extends(Item, _super);

      function Item() {
        return Item.__super__.constructor.apply(this, arguments);
      }

      Item.prototype.defaults = {
        content: 'Default Item',
        date: moment().format('L'),
        editMode: true,
        dateEditMode: true,
        done: false
      };

      return Item;

    })(Backbone.Model);
    TodoList = (function(_super) {

      __extends(TodoList, _super);

      function TodoList() {
        return TodoList.__super__.constructor.apply(this, arguments);
      }

      TodoList.prototype.model = Item;

      return TodoList;

    })(Backbone.Collection);
    ItemView = (function(_super) {

      __extends(ItemView, _super);

      function ItemView() {
        return ItemView.__super__.constructor.apply(this, arguments);
      }

      ItemView.prototype.tagName = 'li';

      ItemView.prototype.initialize = function() {
        _.bindAll(this);
        this.model.bind('change', this.render);
        return this.model.bind('remove', this.unrender);
      };

      ItemView.prototype.render = function() {
        var content_edit_html, date_edit_html, final_html, html;
        content_edit_html = "<input type=\"text\" class=\"content_input\" value=\"" + (this.model.get('content')) + "\">\n<span class=\"date\">" + (this.model.get('date')) + "</span>";
        date_edit_html = "<span class=\"content\">" + (this.model.get('content')) + "</span>\n<input type=\"text\" class=\"date_input\" value=\"" + (this.model.get('date')) + "\">";
        final_html = "<span class=\"content\">" + (this.model.get('content')) + "</span>\n<span class=\"date\">" + (this.model.get('date')) + "</span>\n<a href=\"#\" class=\"done\">done</a> ";
        html = this.model.get('editMode') ? content_edit_html : this.model.get('dateEditMode') ? date_edit_html : final_html;
        $(this.el).html(html);
        if (this.model.get('done')) {
          $(this.el).addClass("done");
        }
        $(this.el).find("input").focus();
        return this;
      };

      ItemView.prototype.unrender = function() {
        return $(this.el).remove();
      };

      ItemView.prototype.remove = function() {
        return this.model.destroy();
      };

      ItemView.prototype.enableEdit = function(e) {
        if ($(e.target).hasClass('content')) {
          return this.model.set({
            'editMode': true
          });
        } else if ($(e.target).hasClass('date')) {
          return this.model.set({
            'dateEditMode': true
          });
        }
      };

      ItemView.prototype.keyPress = function(e) {
        e.preventDefault();
        if (e.keyCode !== 13 && e.keyCode !== 9) {
          return;
        }
        return this.saveEdit(e);
      };

      ItemView.prototype.markDone = function(e) {
        return this.model.set({
          'done': true
        });
      };

      ItemView.prototype.blur = function(e) {
        return this.saveEdit(e);
      };

      ItemView.prototype.saveEdit = function(e) {
        var val;
        val = $(e.target).val();
        if (val !== '') {
          if ($(e.target).hasClass('content_input')) {
            return this.model.set({
              'content': val,
              'editMode': false
            });
          } else if ($(e.target).hasClass('date_input')) {
            if (moment(val).isValid()) {
              return this.model.set({
                'date': moment(val).format('L'),
                'dateEditMode': false
              });
            }
          }
        }
      };

      ItemView.prototype.events = function() {
        return {
          'click a.done': 'markDone',
          'keypress input[type=text]': 'keyPress',
          'blur input[type=text]': 'blur',
          'dblclick .content': 'enableEdit',
          'dblclick .date': 'enableEdit'
        };
      };

      return ItemView;

    })(Backbone.View);
    ListView = (function(_super) {

      __extends(ListView, _super);

      function ListView() {
        return ListView.__super__.constructor.apply(this, arguments);
      }

      ListView.prototype.el = $('body');

      ListView.prototype.initialize = function() {
        _.bindAll(this);
        this.collection = new TodoList;
        return this.collection.bind('add', this.renderItem);
      };

      ListView.prototype.addItem = function() {
        var item;
        item = new Item;
        return this.collection.add(item);
      };

      ListView.prototype.cleanItems = function() {
        var lastitem, model, _results;
        lastitem = this.collection.length;
        console.log(lastitem);
        _results = [];
        while (lastitem > 0) {
          model = this.collection.models[lastitem - 1];
          lastitem -= 1;
          if (model.get('done')) {
            _results.push(model.destroy());
          } else {
            _results.push(void 0);
          }
        }
        return _results;
      };

      ListView.prototype.renderItem = function(item) {
        var html, item_view;
        item_view = new ItemView({
          model: item
        });
        html = item_view.el;
        console.log(html);
        $("#list>ul").append(html);
        return item_view.render();
      };

      ListView.prototype.events = function() {
        return {
          'click .add': 'addItem',
          'click .clean': 'cleanItems'
        };
      };

      return ListView;

    })(Backbone.View);
    return list_view = new ListView;
  });

}).call(this);
