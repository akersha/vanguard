contact = {
		sendMessage : function(){
			vanguard.sendEmail();
		},
		debugAlert : function(){
			alert('You made it.');
		}
}

//EVENTS
$('#contactSend').click( function(){
	contact.sendMessage();
});

$('#alert-close').click( function(){
	vanguard.closeAlert('alert-error');
});