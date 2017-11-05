<!--- Render the CRM view --->

<cfif cgi.QUERY_STRING contains "id=">
	<cfset Application.Body.render(controller: "crm.detail") />
<cfelseif cgi.QUERY_STRING contains "edit=">
	<cfset Application.Body.render(controller: "crm.update") />
<cfelse>
	<cfset Application.Body.render(controller: "crm") />
</cfif>
