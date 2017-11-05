auth={
		//METHODS
		
		validForm: function(email, myPass){
			var strError = "Credentials not found !"
			var intErrors = 0;
			
			if(email.replace(" ", "") == ""){
				intErrors++;
			}
			if(myPass.replace(" ", "") == ""){
				intErrors++;
			}
			if(intErrors > 0){
				alert("Please enter valid credentials");
				return false;
			}else return true
		}
}

//EVENTS
$('#authSubmit').click( function(){
	var email = $("#email").val();
	var myPass = $("#myPass").val();
	
	var isValid = auth.validForm(email, myPass);
	if(isValid){
		var request = $.ajax({
			url: "../model/employeeservice.cfc",
			type: "GET",
			data: { method: 'isCRM', email: email, myPass: myPass},
			dataType: "html"
		});
		request.done(function( data ) {
			if(data === "1"){
				location.href="/crm";
			}else{
				alert("Please enter valid credentials");
				return false
			}
		});
		request.fail(function( jqXHR, textStatus ) {
			alert( "Authentication failed !" );
		});
	}else{
		alert( "Authentication failed !" );
	}
	
});