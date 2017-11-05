<cfcomponent displayname="contact" output="false">

	<cffunction name="init" access="public" output="false" returntype="struct">
		<cftry>
			<cfset local.teamStruct = structNew() />
			<cfset local.teamStruct["curModule"] = "Contact" />

		 	<cfcatch type="any">
				<cfthrow type="Application"
					message="Unable to retrieve contact view"
					detail="Please check that the server is running. If this error persists, contact Vanguard at 603-767-0870">
			</cfcatch>
		</cftry>

		<cfreturn local.teamStruct />
	</cffunction>

</cfcomponent>