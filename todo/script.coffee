jQuery ->


    class Item extends Backbone.Model
        defaults:
            content: 'Default Item'
            date: moment().format('L')
            editMode: true
            dateEditMode: true
            done: false
            initialized: false

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
            content_edit_html = """
                <div class="item_container editing">
                <div class="todo">
                    <input type="text" class="content_input" value="#{@model.get 'content'}">
                </div>
                <div class="control">
                    <span class="date">#{@model.get 'date'}</span>
                    <a href="#" class="remove">remove</a>
                </div>
                </div>
                """

            date_edit_html = """
                <div class="item_container editing">
                <div class="todo">
                    <span class="content">#{@model.get 'content'}</span>
                </div>
                <div class="control">
                    <input type="text" class="date_input" value="#{@model.get 'date'}">
                    <a href="#" class="remove">remove</a>
                </div>
                </div>
                """

            done_html = if not @model.get 'done' then '<a href="#" class="done">done</a>' else ""

            final_html = """
                <div class="item_container">
                <div class="todo">
                    <span class="content">#{@model.get 'content'}</span>
                </div>
                <div class="control">
                    <span class="date">#{@model.get 'date'}</span>
                    #{done_html}
                    <a href="#" class="remove">remove</a>
                </div>
                </div>
                """

            html =
                if @model.get 'editMode' then content_edit_html
                else if @model.get 'dateEditMode' then date_edit_html
                else final_html

            if not @model.get 'initialized'
                $(@el).hide()

            $(@el).html html

            if not @model.get 'initialized'
                $(@el).slideDown(600)

            @model.set 'initialized':true

            if @model.get 'done'
                $(@el).addClass("done")

            $(@el).find("input").focus()
            @

        unrender: ->
            $(@el).slideUp 800, ->
                $(@el).remove()

        remove: ->
            @model.destroy()

        enableEdit: (e) ->
            if $(e.target).hasClass('content')
                @model.set 'editMode': true
            else if $(e.target).hasClass('date')
                @model.set 'dateEditMode': true

        keyPress: (e) ->
            return if e.keyCode isnt 13
            @saveEdit(e)

        markDone: (e) ->
            @model.set 'done': true


        blur: (e) ->
            @saveEdit(e)
        saveEdit: (e) ->
            val=$(e.target).val()
            if val != ''
                if $(e.target).hasClass('content_input')
                    @model.set 'content': val, 'editMode': false
                else if $(e.target).hasClass('date_input')
                    if moment(val).isValid()
                        @model.set 'date': moment(val).format('L'), 'dateEditMode': false

        events: ->
            'click a.done': 'markDone'
            'click a.remove': 'remove'
            'keypress input[type=text]': 'keyPress'
            'blur input[type=text]': 'blur'
            'dblclick .todo': 'enableEdit'
            'dblclick .date': 'enableEdit'


    class ListView extends Backbone.View
        el: $ 'body'
        initialize: ->
            _.bindAll @

            @collection = new TodoList
            @collection.bind 'add', @renderItem

        addItem: ->
            item = new Item
            @collection.add item

        cleanItems: ->
            lastitem=@collection.length
            console.log lastitem
            while lastitem > 0
                model = @collection.models[lastitem-1]
                lastitem -= 1
                if model.get 'done'
                    model.destroy()

        renderItem: (item) ->
            item_view = new ItemView model: item
            html = item_view.el
            console.log html
            $("#list>ul").append html
            item_view.render()

        events: ->
            'click .add': 'addItem'
            'click .clean': 'cleanItems'

    list_view = new ListView
