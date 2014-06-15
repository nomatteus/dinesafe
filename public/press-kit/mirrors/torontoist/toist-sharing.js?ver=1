jQuery(document).ready(function($){

	var data = {
		action:	'toist_sharing_counts',
		nonce:	toistSharing.nonce,
		url: toistSharing.url,
		postID: toistSharing.post_id
	};
	
	var parents = $(".social-media-buttons");
	var pinterest = parents.children(".pinterest");
	var gplus = parents.children(".gplus");
	var facebook = parents.children(".facebook");
	var twitter = parents.children(".twitter");
	
	var popup_spec = "location=0,menubar=0,status=0,toolbar=0,left=50,top=50";
	var pinterest_spec = "height=333,width=783,";
	var gplus_spec = "height=341,width=482,";
	var facebook_spec = "height=217,width=521,";
	var twitter_spec = "height=300,width=498,";
		
	$.ajax({
		type: "POST",
		url: toistSharing.target,
		data: data,
		dataType: "json",
		success: function(res){			
			if(res.pinterest){addCount(pinterest,res.pinterest);}
			if(res.gplus && res.gplus != '0'){addCount(gplus,res.gplus);}
			if(res.facebook){addCount(facebook,res.facebook);}
			if(res.twitter){addCount(twitter,res.twitter);}
		}
	});
	
	function addCount(els,count){
		els.each(function(i,el){
			var $el = $(el);
			num = $el.children(".count").length;
			if(num > 1){
				$el.children(".count").remove();
			}
			if(num != 1){
				$('<span class="count"></span>').text(count).appendTo($el);
			}else{
				$el.children(".count").text(count);
			}
		});
	}
	
	//new windows
	parents.on("click","a.social",function(ev){
		var $this = $(this);
		if($this.hasClass("email")) return true;
		ev.preventDefault();
		ev.stopPropagation();
		
		var spec = popup_spec;
		if($this.hasClass("pinterest")) spec = pinterest_spec+spec;
		if($this.hasClass("gplus")) spec = gplus_spec+spec;
		if($this.hasClass("facebook")) spec = facebook_spec+spec;
		if($this.hasClass("twitter")) spec = twitter_spec+spec;
		
		var target = ev.currentTarget.href;
		window.open(target,'sharingIsCaring',spec);
		});
	
	

});
