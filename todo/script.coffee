jQuery ->


    class Item extends Backbone.Model
        defaults:
            content: 'Default Item'
            date: '2012-1-1'
            editMode: true
            done: false

    class TodoList extends Backbone.Collection
        model: Item

    class ItemView extends Backbone.View
        tagName: 'li'
        initialize: ->
            _.bindAll @

            # model is defined outside
            @model.bind 'change', @render
            @model.bind 'remove', @unrender

        render: ->
            inputBox = """<input type="text" name="fname" value="#{@model.get 'content'}">"""
            text = """<span class="itemcontent">#{@model.get 'content'}</span>
                <a href="#" class="done">done</a> """
            html = if @model.get 'editMode' then inputBox else text

            $(@el).html html

            if @model.get 'done'
                $(@el).addClass("done")

            if @model.get 'editMode'
                $(@el).find("input").focus()
            @

        unrender: ->
            $(@el).remove()

        remove: ->
            @model.destroy()

        enableEdit: (e) ->
            @model.set 'editMode': true

        keyPress: (e) ->
            return if e.keyCode isnt 13
            val=$(e.target).val()
            if val != ''
                @model.set 'content': val, 'editMode': false

        markDone: (e) ->
            @model.set 'done': true


        blur: (e) ->
            val=$(e.target).val()
            if val != ''
                @model.set 'content': val, 'editMode': false

        events: ->
            'click .edit': 'enableEdit'
            'click a.done': 'markDone'
            'keypress input[type=text]': 'keyPress'
            'blur input[type=text]': 'blur'
            'dblclick ': 'enableEdit'



    class ListView extends Backbone.View
        el: $ 'body'
        initialize: ->
            _.bindAll @

            @collection = new TodoList
            @collection.bind 'add', @renderItem

        addItem: ->
            item = new Item
            @collection.add item

        renderItem: (item) ->
            item_view = new ItemView model: item
            html = item_view.render().el
            console.log html
            $("#list>ul").append html

        events: ->
            'click .add': 'addItem'

    list_view = new ListView
