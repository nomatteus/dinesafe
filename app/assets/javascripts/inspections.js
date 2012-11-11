$(function() {
  $(".status").bind("mouseover", function() {
    $(this).children(".details").show();
  }).bind("mouseout", function() {
    $(this).children(".details").hide();
  });

});