# Setup loader
window.App =
  _loaders: {}
  onLoad: (selectors..., callback) ->
    for s in selectors
      @_loaders[s] ||= []
      @_loaders[s].push callback
  invokeLoad: ->
    action = $('body').data 'action'
    callback.call(this) for callback in @_loaders[action] if @_loaders[action]?

$(document).on 'turbolinks:load', -> App.invokeLoad()

