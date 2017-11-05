<cfif structKeyExists(session, "curUser")>
<div class="row">
	<div class="col-md-12">
		<ol class="breadcrumb">

			<cfoutput>
			<li>Welcome #session.curUser#</li>
			</cfoutput>

		</ol>
	</div>
</div>
</cfif>