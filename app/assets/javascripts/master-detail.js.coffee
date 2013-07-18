TA = window.TA ||= {}

class TA.MasterDetail
  constructor: (@selector) ->
    that = @
    $(@selector).find("[data-master]").on('click', ->
      that.changeViewTo($(@).data('master'))
    )
    $(@selector).find("[data-detail]:first").removeClass("hidden")
    $(@selector).find("[data-master]:first").addClass("btn-primary")

  changeViewTo: (id) ->
    $(@selector).find("[data-detail]").addClass("hidden")
    $(@selector).find("[data-master]").removeClass("btn-primary")

    $(@selector).find("[data-detail=#{id}]").removeClass("hidden")
    $(@selector).find("[data-master=#{id}]").addClass("btn-primary")
