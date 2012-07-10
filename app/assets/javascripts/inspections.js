$(function() {
  console.log($("span").length);
});
$(".status").hover((function() {
  console.log(this);
  $(this).children(".details").show();
}), function() {
  console.log("bob");
  $(this).children(".details").hide();
});

