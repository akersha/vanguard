vanguard = {
	 ActionLink : function(theController, theMethod, theAttrs){
		 	var controller = "";
		 	var method = "";
		 	var attrs = "";
		 	
		 	if( !(theController == null) && theController != ""){
		 		controller = "/" + theController;
		 	}
		 	if( !(theMethod == null) && theMethod != ""){
		 		method = "/" + theMethod;
		 	}
		 	if( !(theAttrs == null) && theAttrs != ""){
		 		attrs = "/" + theAttrs;
		 	}
            location.assign = controller + method + attrs;
    },
    outLink : function( mUrl){
		 	newWin = window.open( mUrl, 'Out_link',  'location=yes,status=yes,titlebar=yes,fullscreen=no,scrollbars=yes,menubar=no,resizable=yes,toolbar=yes,height=768,width=1024');
    },
    toggleDiv : function(trig, elem){
		var oElem = document.getElementById(elem);
		var oTrig = document.getElementById(trig);
		if (oElem.style.display == 'block'){
			oElem.style.display = 'none';
			oTrig.className = 'trigger';
		}else{
			oElem.style.display = 'block';
			oTrig.className += ' active';	
		}
	},
	isDate : function(strDate){
		var dateFormat = new RegExp('[0-9]{2}/[0-9]{2}/[0-9]{4}');
		return dateFormat.test(strDate);
	},
	sendEmail : function (){
		var _mailBody = document.querySelector("#fullName").value + ' is asking ... ' + document.querySelector("#comments").value;
		
		var _from = document.querySelector("#email").value;
		
		var _url = '../model/messageservice.cfc';
		
		var request = $.ajax({
			url: _url,
			data:{
				method:'createMessage',
				mailTo: 'alex.kersha@gmail.com,waynebchr@vanguardshield.com,rjrusso@vanguardshield.com', 
				mailFrom: _from, 
				mailSubject: 'A message from a client', 
				mailBody: _mailBody
			},
			type: "POST",
			dataType: "html"
		});
		request.done(function(data )  {
			if ( data === '1'){
				$("#alert-text").html("<br>Message sent successfully.");
				$('#alert-error').show();
			}else{
				$('#alert-text').html('<br>Outlook failed to send the notification. Please call us at 603-767-0870');
				$('#alert-error').show();
				return false;
			}
		});
		request.fail(function(data, response, jqXHR) {
			$("#alert-text").html("<br>Notification failed.");
			$('#alert-error').show();
			return false;
		});
	},
	setCookie : function (name,value,expires,path,theDomain,secure) {
		value = escape(value);
		var theCookie = name + "=" + value +
		((expires) ? "; expires=" + expires.toGMTString() : "") +
		((path) ? "; path=" + path : "") +
		((theDomain) ? "; domain=" + theDomain : "") +
		((secure) ? "; secure" : "");
		document.cookie = theCookie;
	},
	getCookie : function(cname) {
	    var name = cname + "=";
	    var ca = document.cookie.split(';');
	    for(var i=0; i<ca.length; i++) {
	        var c = ca[i];
	        while (c.charAt(0)==' ') c = c.substring(1);
	        if (c.indexOf(name) != -1) return c.substring(name.length,c.length);
	    }
	    return "";
	},
	closeAlert : function(whichDiv){
		try{
		$('#'+ whichDiv).hide();
		}catch(e){console.log(e)}
	},
	init : function(){
		var isiPad = function(){
			return (navigator.platform.indexOf("iPad") != -1);
		};

		var isiPhone = function(){
		    return (
				(navigator.platform.indexOf("iPhone") != -1) || 
				(navigator.platform.indexOf("iPod") != -1)
		    );
		};

		// Burger Menu
		var burgerMenu = function() {

			$('body').on('click', '.js-fh5co-nav-toggle', function(event){

				if ( $('#navbar').is(':visible') ) {
					$(this).removeClass('active');	
				} else {
					$(this).addClass('active');	
				}
				event.preventDefault();
			});
		};
	}
}

vanguard.init();
