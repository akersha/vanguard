crm={
		validForm: function(contactName, notes, duration){
			var strError = "Please check the following fields:\n";
			var intErrors = 0;
			
			if(contactName.replace(" ", "") == "" || contactName.length <= 3){
				intErrors++;
				strError += "Contact name\n"
			}
			if(notes.replace(" ", "") == "" || notes.length <= 3){
				intErrors++;
				strError += "Notes\n"
			}
			if(duration.replace(" ", "") == "" || duration.length < 2){
				intErrors++;
				strError += "Duration\n"
			}
			if(intErrors > 0){
				alert(strError);
				return false;
			}else return true
		},
		backToDetail: function(id){
			location.replace('/crm/?id=' + id);
		}
}

//EVENTS
window.setTimeout( function(){
	$('#breadcrumbs').toggle("slow");
}, 3500);

$( function() {
	$( "#tabs" ).tabs({
	  beforeLoad: function( event, ui ) {
	    ui.jqXHR.fail(function() {
	      ui.panel.html(
	        "Couldn't load this tab. We'll try to fix this as soon as possible." );
	    });
	  }
	});
});

$("#crmSubmit").click( function(){
	var curDate = $('#datepicker').val();
	var curHours = $('#hours').val();
	var curMinutes = $('#minutes').val();
	var ampm = $('#ampm').val();
	var regarding = $('#regarding').val();
	var company = $('#company').val();
	var contactName = $('#name').val();
	var notes = $('#notes').val();
	var duration = $('#duration').val();
	var callTo = $('#callTo').val();
	var phone = $('#phone').val();
	var email = $('#email').val();
	var result = $('#result').val();
	
	curDate = curDate + ' ' + curHours + ':' + curMinutes + ' ' + ampm;

	isValid = crm.validForm(contactName,notes,duration);
	if(isValid){
		var request = $.ajax({
			url: "../model/admin/service.cfc",
			type: "POST",
			data: { method: 'createCRMContact', 
				curDate: curDate,
				regarding: regarding, 
				company: company,
				contactName: contactName,
				notes: notes,
				callTo: callTo,
				phone: phone,
				email: email,
				duration: duration,
				result: result
			},
			dataType: "html"
		});
		request.done(function( data ) {
			if(data != "0"){
				location.href="/crm/?inserted=" + data;
			}else return false
		});
		request.fail(function( jqXHR, textStatus ) {
			alert( "Record insert failed !" );
		});
	}else{
		alert( "Missing or invalid form values !" );
	}
});

$("#crmUpdate").click( function(){
	var id = $('#contactID').val();
	var curDate = $('#datepicker').val();
	var curHours = $('#hours').val();
	var curMinutes = $('#minutes').val();
	var ampm = $('#ampm').val();
	var regarding = $('#regarding').val();
	var company = $('#company').val();
	var contactName = $('#name').val();
	var notes = $('#notes').val();
	var duration = $('#duration').val();
	var callTo = $('#callTo').val();
	var phone = $('#phone').val();
	var email = $('#email').val();
	var result = $('#result').val();
	
	curDate = curDate + ' ' + curHours + ':' + curMinutes + ' ' + ampm;

	isValid = crm.validForm(contactName,notes,duration);
	if(isValid){
		var request = $.ajax({
			url: "../model/admin/service.cfc",
			type: "POST",
			data: { method: 'updateCRMContact', 
				id: id,
				curDate: curDate,
				regarding: regarding, 
				company: company,
				contactName: contactName,
				notes: notes,
				callTo: callTo,
				phone: phone,
				email: email,
				duration: duration,
				result: result
			},
			dataType: "html"
		});
		request.done(function( data ) {
			if(data != "0"){
				location.href="/crm/?updated=" + data;
			}else return false
		});
		request.fail(function( jqXHR, textStatus ) {
			alert( "Record update failed !" );
		});
	}else{
		alert( "Missing or invalid form values !" );
	}
});
