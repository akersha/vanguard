<cfcomponent displayname="auth" output="false">

	<cffunction name="init" access="public" output="false" returntype="struct">
		<cftry>
			<cfset local.authStruct = structNew() />
			<cfset local.authStruct["curModule"] = "Authentication" />

		 	<cfcatch type="any">
				<cfthrow type="Application"
					message="Unable to retrieve login view"
					detail="Please check that the server is running. If this error persists, contact Vanguard at 603-767-0870">
			</cfcatch>
		</cftry>

		<cfreturn local.authStruct />
	</cffunction>

</cfcomponent>