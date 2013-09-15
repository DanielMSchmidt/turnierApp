$ ->
	adjustModals = () ->
		if $(window).width() > 700
			$(".modal-body").addClass("row-fluid")
			console.log("added class to modal")
		else
			$(".modal-body").removeClass("row-fluid")
			console.log("deleted class from modal")

	adjustModals()
	$(window).resize(adjustModals)