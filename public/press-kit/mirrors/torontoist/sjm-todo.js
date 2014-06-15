 jQuery(document).ready(function($)
 {
	$(".todo-items .expand").bind("click", function()
	{       
		$(this)
		.toggleClass("open")
		.closest(".todo_container")
		.find(".collapse")
		.toggleClass("closed");
	});

	$(".todo-items .expand:first").trigger("click");
 });