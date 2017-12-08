# Setup sign up tooltips
App.onLoad 'users.new', 'users.create', ->
  $('.has-tooltip').tooltip
    position:
      my: 'top+15'
      at: 'bottom'
      collision: 'none'
  .off('mouseover mouseout')

# Slide error messages in
App.onLoad 'users.create', ->
  $('.form-error').hide().slideDown()

