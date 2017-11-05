<cfcomponent displayname="AdminService" output="false"  accessors="true" hint="Service class for the Ent Group Admin features">

	 <cffunction name="init" access="public" output="false" returntype="service">
		<cfreturn this />
	</cffunction>

	<cffunction name="createCRMContact" access="remote" output="false" returnType="string" returnformat="plain">

		<cfset newContactID = Application.objAdmin.createCRMContact(
			curDate: request.curDate,
			regarding: request.regarding,
			company: request.company,
			contactName: request.contactName,
			callTo: request.callTo,
			phone: request.phone,
			email: request.email,
			notes: request.notes,
			duration: request.duration,
			result: request.result
		) />

		<cfif newContactID NEQ 0>
			<cfreturn "1">
		<cfelse>
			<cfreturn "0">
		</cfif>

	</cffunction>

	<cffunction name="updateCRMContact" access="remote" output="false" returnType="string" returnformat="plain">

		<cfset success = Application.objAdmin.updateCRMContact(
			id: request.id,
			curDate: request.curDate,
			regarding: request.regarding,
			company: request.company,
			contactName: request.contactName,
			callTo: request.callTo,
			phone: request.phone,
			email: request.email,
			notes: request.notes,
			duration: request.duration,
			result: request.result
		) />

		<cfreturn success />

	</cffunction>

	<cffunction name="getCRMContacts" access="remote" output="false" returnType="xml" returnformat="plain">

		<cfset qContacts = Application.objAdmin.getCRMContacts(
			contactID: request.contactID,
			startDate: request.startDate,
			endDate: request.endDate
		) />

		<cfset tempxml = "" />
		<cfset tempxml = tempxml & "<?xml version = '1.0'?><contacts>" />
		<cfloop query="qContacts">
		<cfset tempxml = tempxml & "<contact><contactid>" & xmlFormat(id) & "</contactid>" />
		<cfset tempxml = tempxml & "<date>" & xmlFormat(insertDate) & "</date>" />
		<cfset tempxml = tempxml & "<regarding>" & xmlFormat(regarding) & "</regarding>" />
		<cfset tempxml = tempxml & "<company>" & xmlFormat(company) & "</company>" />
		<cfset tempxml = tempxml & "<name>" & xmlFormat(contactname) & "</name>" />
		<cfset tempxml = tempxml & "<callto>" & xmlFormat(callto) & "</callto>" />
		<cfset tempxml = tempxml & "<phone>" & xmlFormat(phone) & "</phone>" />
		<cfset tempxml = tempxml & "<email>" & xmlFormat(email) & "</email>" />
		<cfset tempxml = tempxml & "<duration>" & xmlFormat(duration) & "</duration>" />
		<cfset tempxml = tempxml & "<result>" & xmlFormat(result) & "</result></contact>" />
		</cfloop>
		<cfset tempxml = tempxml & "</contacts>" />

		<cfreturn tempxml />

	</cffunction>

	<cffunction name="getCRMForEdit" access="remote" output="false" returnType="query">
		<cfargument name="contactID" type="numeric" required="true">

		<cfset qContact = Application.objAdmin.getCRMDetail( contactID: arguments.contactID ) />

		<cfreturn qContact />

	</cffunction>

	<cffunction name="getCRMDetail" access="remote" output="false" returnType="xml" returnformat="plain">
		<cfargument name="contactID" type="numeric" required="true">

		<cfset qContact = Application.objAdmin.getCRMDetail( contactID: arguments.contactID ) />

		<cfset tempxml = "" />
		<cfset tempxml = tempxml & "<?xml version = '1.0'?><contacts>" />
		<cfloop query="qContact">
		<cfset tempxml = tempxml & "<contact><contactid>" & xmlFormat(id) & "</contactid>" />
		<cfset tempxml = tempxml & "<date>" & xmlFormat(insertDate) & "</date>" />
		<cfset tempxml = tempxml & "<regarding>" & xmlFormat(regarding) & "</regarding>" />
		<cfset tempxml = tempxml & "<company>" & xmlFormat(company) & "</company>" />
		<cfset tempxml = tempxml & "<name>" & xmlFormat(contactname) & "</name>" />
		<cfset tempxml = tempxml & "<callto>" & xmlFormat(callto) & "</callto>" />
		<cfset tempxml = tempxml & "<phone>" & xmlFormat(phone) & "</phone>" />
		<cfset tempxml = tempxml & "<email>" & xmlFormat(email) & "</email>" />
		<cfset tempxml = tempxml & "<duration>" & xmlFormat(duration) & "</duration>" />
		<cfset tempxml = tempxml & "<result>" & xmlFormat(result) & "</result>" />
		<cfset tempxml = tempxml & "<notes>" & xmlFormat(notes) & "</notes></contact>" />
		</cfloop>
		<cfset tempxml = tempxml & "</contacts>" />

		<cfreturn tempxml />

	</cffunction>

</cfcomponent>