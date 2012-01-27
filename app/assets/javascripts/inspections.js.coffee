# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
	console.log($("span").length)
	$(".status").hover (->
		console.log(this)
		$(this).children(".details").show()
	), ->
		console.log("bob")
		$(this).children(".details").hide()

