<cfcomponent displayname="bio" output="false">

	<cffunction name="init" access="public" output="false" returntype="struct">
		<cftry>
			<cfset local.bioStruct = structNew() />
			<cfset local.bioStruct["curModule"] = "bio" />

		 	<cfcatch type="any">
				<cfthrow type="Application"
					message="Unable to retrieve Biography view"
					detail="Please check that the server is running. If this error persists, contact Vanguard at 603-767-0870">
			</cfcatch>
		</cftry>

		<cfreturn local.bioStruct />
	</cffunction>

</cfcomponent>