<!--- HEADER --->
<nav class="navbar navbar-inverse" role="navigation">
 <div class="container-fluid">
   <div class="navbar-header">
     <button type="button" class="navbar-toggle" data-toggle="collapse" data-target="#myNavbar">
       <span class="icon-bar"></span>
       <span class="icon-bar"></span>
       <span class="icon-bar"></span>
     </button>
	<cfoutput>
     <a class="navbar-brand" style="color:##FFF" href="#application.config['environmenturi']#"><img src="../images/vanguard_shield_logo.png" width="196" height="50" border="0" alt="VanguardShield.com"></a>
	</cfoutput>
   </div>
   <div class="collapse navbar-collapse" id="myNavbar">
     <ul class="nav navbar-nav navbar-right">
		<cfoutput>
		<li <cfif attributes.controller eq "home" or attributes.controller eq "">class="active"</cfif>>#Application.WebApp.ActionLink("Home", "")#</li>
		<li <cfif attributes.controller eq "team">class="active"</cfif>>#Application.WebApp.ActionLink("Team", "team")#</li>
		<li <cfif attributes.controller eq "testimonials">class="active"</cfif>>#Application.WebApp.ActionLink("Testimonials", "testimonials")#</li>
		<li <cfif attributes.controller eq "services">class="active"</cfif>>#Application.WebApp.ActionLink("Services", "services")#</li>
		<li <cfif attributes.controller eq "contact">class="active"</cfif>>#Application.WebApp.ActionLink("Contact", "contact")#</li>
		</cfoutput>
     </ul>
   </div>
 </div>
</nav>

<div class="alert alert-warning alert-dismissible" role="alert" id="alert-error" style="display:none;">
  <button type="button" class="close" data-dismiss="alert" aria-label="Close" id="alert-close"><span aria-hidden="true">&times;</span></button>
  <span id="alert-text"></span>
</div>

