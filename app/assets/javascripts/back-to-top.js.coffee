$ ->
  DS = window.DS ||= {}

  DS.scrolltotop =
    setting:
      startline: 100
      scrollto: 0
      scrollduration: 1000
      fadeduration: [500, 100]

    controlattrs:
      offsetx: 5
      offsety: 5

    anchorkeyword: "#top"
    state:
      isvisible: false
      shouldvisible: false

    scrollup: ->
      #if control is positioned using JavaScript
      @$control.css opacity: 0  unless @cssfixedsupport #hide control immediately after clicking it
      dest = (if isNaN(@setting.scrollto) then @setting.scrollto else parseInt(@setting.scrollto))
      if typeof dest is "string" and jQuery("#" + dest).length is 1 #check element set by string exists
        dest = jQuery("#" + dest).offset().top
      else
        dest = 0
      @$body.animate
        scrollTop: dest
      , @setting.scrollduration

    keepfixed: ->
      $window = jQuery(window)
      controlx = $window.scrollLeft() + $window.width() - @$control.width() - @controlattrs.offsetx
      controly = $window.scrollTop() + $window.height() - @$control.height() - @controlattrs.offsety
      @$control.css
        left: controlx + "px"
        top: controly + "px"

    togglecontrol: ->
      scrolltop = jQuery(window).scrollTop()
      @keepfixed()  unless @cssfixedsupport
      @state.shouldvisible = (if (scrolltop >= @setting.startline) then true else false)
      if @state.shouldvisible and not @state.isvisible
        @$control.stop().animate
          opacity: 1
        , @setting.fadeduration[0]
        @state.isvisible = true
      else if @state.shouldvisible is false and @state.isvisible
        @$control.stop().animate
          opacity: 0
        , @setting.fadeduration[1]
        @state.isvisible = false

    init: (img_path) ->
      jQuery(document).ready ($) ->
        inserted_img = "<img src='#{img_path}' style='width:51px; height:42px' />"
        mainobj = DS.scrolltotop
        iebrws = document.all
        mainobj.cssfixedsupport = not iebrws or iebrws and document.compatMode is "CSS1Compat" and window.XMLHttpRequest #not IE or IE7+ browsers in standards mode
        mainobj.$body = (if (window.opera) then ((if document.compatMode is "CSS1Compat" then $("html") else $("body"))) else $("html,body"))
        mainobj.$control = $("<div id=\"topcontrol\">" + inserted_img + "</div>").css(
          position: (if mainobj.cssfixedsupport then "fixed" else "absolute")
          bottom: mainobj.controlattrs.offsety
          right: mainobj.controlattrs.offsetx
          opacity: 0
          cursor: "pointer"
        ).attr(title: "Scroll Back to Top").click(->
          mainobj.scrollup()
          false
        ).appendTo("body")
        #loose check for IE6 and below, plus whether control contains any text
        mainobj.$control.css width: mainobj.$control.width()  if document.all and not window.XMLHttpRequest and mainobj.$control.text() isnt "" #IE6- seems to require an explicit width on a DIV containing text
        mainobj.togglecontrol()
        $("a[href=\"" + mainobj.anchorkeyword + "\"]").click ->
          mainobj.scrollup()
          false

        $(window).bind "scroll resize", (e) ->
          mainobj.togglecontrol()