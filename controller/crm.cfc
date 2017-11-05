<cfcomponent displayname="crm" output="false">

	<cffunction name="init" access="public" output="false" returntype="struct">
		<cftry>
			<cfparam name="request.contactID" default="0">
			<cfset local.crmStruct = structNew() />
			<cfset local.crmStruct["curModule"] = "CRM" />

		 	<cfcatch type="any">
				<cfthrow type="Application"
					message="Unable to retrieve CRM view"
					detail="Please check that the server is running. If this error persists, contact Vanguard at mailadmin@vanguardshield.com">
			</cfcatch>
		</cftry>

		<cfreturn local.crmStruct />
	</cffunction>

</cfcomponent>