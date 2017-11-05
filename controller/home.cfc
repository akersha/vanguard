<cfcomponent displayname="home" output="false">

	<cffunction name="init" access="public" output="false" returntype="struct">
		<cftry>
			<cfset local.homeStruct = structNew() />
			<cfset local.homeStruct["curModule"] = "Home" />

		 	<cfcatch type="any">
				<cfthrow type="Application"
					message="Unable to retrieve home view"
					detail="Please check that the server is running. If this error persists, contact Vanguard at 603-767-0870">
			</cfcatch>
		</cftry>

		<cfreturn local.homeStruct />
	</cffunction>

</cfcomponent>