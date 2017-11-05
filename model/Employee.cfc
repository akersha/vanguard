<cfcomponent displayname="EmployeeDAO" hint="Employee DAO methods" output="false" accessors="true">
	<cfproperty name="datasource" type="string">
	<cfproperty name="cacheTimeSpan" type="any">

    <cffunction name="init" access="public" output="false" returntype="Employee">
		<cfargument name="datasource" type="string" required="false" default="most">
		<cfargument name="cacheTimeSpan" type="any" required="false" default="#createTimeSpan(0,1,0,0)#">

		<cfset this.setDatasource(arguments.datasource) />
		<cfset this.setCacheTimeSpan(arguments.cacheTimeSpan) />

        <cfreturn this />
    </cffunction>

	<cffunction name="isDeveloper" returntype="boolean" access="public" output="false" hint="Test if current user is a developer.">
		<cfargument name="UID" type="string" required="true" hint="UID of the user to verify.">

		<cfset var ret = true>

		<cfif ListFindNoCase(Application.config.developers,arguments.uid) EQ 0>
			<cfset ret = false>
		</cfif>

		<cfreturn ret>
	</cffunction>

	<cffunction name="isCRM" returntype="boolean" access="public" output="false" hint="Test if current user can use the CRM tool.">
		<cfargument name="email" type="string" required="true" hint="email of the user to verify.">
		<cfargument name="mypass" type="string" required="true" hint="password of the user to verify.">

		<cfset var ret = false>

		<cfreturn ret>
	</cffunction>


</cfcomponent>