# Define custom language select menu
$.widget 'custom.languageselectmenu', $.ui.selectmenu,
  _renderButtonItem: (item) ->
    $ '<img>', src: item.element.data('image'), class: "ui-selectmenu-text language-icon"
  _renderItem: (ul, item) ->
    $('<li>').append(
      $('<div>', text: item.label).append(
        $ '<img>', src: item.element.data('image'), class: "language-icon"
    )).appendTo(ul)

App.onLoad 'all', ->
  # Setup language select
  $('.page-language-form > select').languageselectmenu
    classes:
      'ui-selectmenu-button': 'ui-languageselect-button'
      'ui-selectmenu-menu': 'ui-languageselect-menu'
    position: { my: "right top", at: "right bottom+20" }
    change: -> $(".page-language-form").submit()
  $('.page-language-form > input[type="submit"]').hide()
