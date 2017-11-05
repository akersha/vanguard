<cfcomponent displayname="EmployeeService" hint="Employee utility (non-DAO) methods" output="false" accessors="true">

	<cffunction name="init" output="false" returntype="EmployeeService" access="public">
		<cfreturn this />
	</cffunction>

	<cffunction name="isDeveloper" returntype="boolean" access="remote" output="false" hint="Test if current user is a developer.">
		<cfargument name="UID" type="string" required="true" hint="UID of the user to verify.">

		<cfset var ret = true>

		<cfif ListFindNoCase(Application.config.developers,arguments.uid) EQ 0>
			<cfset ret = false>
		</cfif>

		<cfreturn ret>
	</cffunction>

	<cffunction name="isCRM" returntype="string" returnFormat="plain" access="remote" output="false" hint="Test if current user is a developer.">

		<cfset var ret = "0" />

		<cfif ListFindNoCase(Application.config.lstCRM,request.email) NEQ 0 AND request.myPass EQ "Vanguard2013!">
			<cflock scope="session" timeout="3">
				<cfset session.curUser = request.email />
			</cflock>
			<cfset ret = "1" />
		</cfif>

		<cfreturn ret>
	</cffunction>

	<cffunction name="findUserCookie" returntype="string" 	access="public" output="false" hint="Returns the ATTUID of a user cookie.  A blank string is returned if the cookie is not found or does not return a valid ATTUID.">
			<cfset var ret = "">
			<!--- If the user has already picked up an Authorization Portal cookie, return --->
			<cfif structKeyExists(cookie, "ATT_AUTH_UID")>
				<cfset ret = UCase(cookie["ATT_AUTH_UID"])>

			<cfelse>

				<cfif StructKeyExists(cookie,application.config.cookie_uid)>
					<cfif cookie[application.config.cookie_uid] NEQ "">
						<cfif NOT this.isAttuid(cookie[application.config.cookie_uid]) AND cookie[application.config.cookie_uid] NEQ "SERVER">
							<cfset ret = "">
							<!--- Destroy the cookie since it's invalid --->
							<cfcookie name="#application.config.cookie_uid#" expires="now" value="">
						<cfelse>
							<cfset ret = UCase(cookie[application.config.cookie_uid])>
						</cfif>
					</cfif>
				</cfif>

			</cfif>

		<cfreturn ret>
	</cffunction>

	<cffunction name="setUserCookie" returntype="void" access="public" output="false" hint="Sets a user session cookie.">
			<cfargument name="attUid" type="string" required="true" hint="The ATTUID to set as a cookie.">

			<cfset var encrypted = "">

			<cfif NOT isAttuid(arguments.attuid)>
				<cfthrow message="setUserCookie ERROR: #arguments.attuid# does not appear to be a valid ATTUID!">
				<cfabort>
			</cfif>

			<!--- Valid for one day --->
			<cftry>
				<cfset oneDay = DateAdd("d", 1,now()) />

				<cfcookie name="#Application.config.cookie_uid#" value="#UCase(arguments.attuid)#" expires="#oneDay#">

				<cfcatch type="any">
					<cfthrow message="setUserCookie ERROR: #cfcatch.message#">
				</cfcatch>
			</cftry>
		<cfreturn>
	</cffunction>

</cfcomponent>