TA = window.TA ||= {}

class TA.MasterDetail
  constructor: (@selector) ->
    that = @
    $(@selector).find("[data-master]").on('click', ->
      that.changeViewTo($(@).data('master'))
    )
    $(@selector).find("[data-detail]:first").removeClass("hidden")

  changeViewTo: (id) ->
    $(@selector).find("[data-detail]").addClass("hidden")
    $(@selector).find("[data-detail=#{id}]").removeClass("hidden")
