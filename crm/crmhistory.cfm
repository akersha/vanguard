<cfparam name="request.contactID" default="0">
<cfparam name="request.startDate" default="4/25/2017">
<cfparam name="request.endDate" default="12/31/2017">

<cfset variables.objAdminSvc = createObject("component", "model.admin.service").init() />
<cfset variables.xmlContacts = variables.objAdminSvc.getCRMContacts(request.contactID, request.startDate, request.endDate) />

<cfset xmlDoc = xmlParse(variables.xmlContacts, false) />


<div class="table-responsive table-condensed table-hover">
  <table class="table">
    <thead>
		<th>Date</th><th>Subject</th><th>Company</th><th>Contact</th><th>Via</th><th>Duration</th><th>&nbsp;</th>
	</thead>
	<tbody>

<cfloop index="intContact" from="1" to="#ArrayLen( xmlDoc.contacts.XmlChildren )#" step="1">
	<cfset contact = xmlDoc.contacts[ "contact" ][ intContact ] />

	<cfset id = contact.contactid.XmlText />
	<cfset date = contact.date.XmlText />
	<cfset regarding = contact.regarding.XmlText />
	<cfset company = contact.company.XmlText />
	<cfset contactname = contact.name.XmlText />
	<cfset callto = contact.callto.XmlText />
	<cfset phone = contact.phone.XmlText />
	<cfset email = contact.email.XmlText />
	<cfset duration = contact.duration.XmlText />
	<cfset result = contact.result.XmlText />

	<cfoutput>
	<tr <cfif result eq "favorable">class='success'</cfif>>
		<td>#dateFormat(date, "mm/dd/yyyy")#</td>
		<td>#regarding#</td>
		<td>#company#</td>
		<td>#contactname#</td>
		<td><i class="<cfif callto EQ 'phone'>glyphicon glyphicon-user<cfelseif callto EQ 'in person'>glyphicon glyphicon-phone-alt<cfelse>glyphicon glyphicon-envelope</cfif>"></i></td>
		<td>#duration#</td>
		<td><a href="/crm/?id=#id#"><i class="glyphicon glyphicon-info-sign"></i></a></td>
	</tr>
	</cfoutput>

</cfloop>

	</tbody>
  </table>
</div>