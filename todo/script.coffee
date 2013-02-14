jQuery ->


    class Item extends Backbone.Model
        defaults:
            content: 'Default Item'
            date: moment().format('L')
            editMode: true
            dateEditMode: true
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
            content_edit_html = """
                <input type="text" class="content_input" value="#{@model.get 'content'}">
                <span class="date">#{@model.get 'date'}</span>
                """

            date_edit_html = """
                <span class="content">#{@model.get 'content'}</span>
                <input type="text" class="date_input" value="#{@model.get 'date'}">
                """

            final_html = """
                <span class="content">#{@model.get 'content'}</span>
                <span class="date">#{@model.get 'date'}</span>
                <a href="#" class="done">done</a> """

            html =
                if @model.get 'editMode' then content_edit_html
                else if @model.get 'dateEditMode' then date_edit_html
                else final_html

            $(@el).html html

            if @model.get 'done'
                $(@el).addClass("done")

            $(@el).find("input").focus()
            @

        unrender: ->
            $(@el).remove()

        remove: ->
            @model.destroy()

        enableEdit: (e) ->
            if $(e.target).hasClass('content')
                @model.set 'editMode': true
            else if $(e.target).hasClass('date')
                @model.set 'dateEditMode': true

        keyPress: (e) ->
            e.preventDefault()
            return if e.keyCode isnt 13 and e.keyCode isnt 9
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
            'keypress input[type=text]': 'keyPress'
            'blur input[type=text]': 'blur'
            'dblclick .content': 'enableEdit'
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

        renderItem: (item) ->
            item_view = new ItemView model: item
            html = item_view.el
            console.log html
            $("#list>ul").append html
            item_view.render()

        events: ->
            'click .add': 'addItem'

    list_view = new ListView
