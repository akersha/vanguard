<cfcomponent displayname="Config" output="false" accessors="true">

	<cfproperty name="datasource" type="string">
	<cfproperty name="cacheTimeSpan" type="any">

	<cffunction name="init" output="false" access="public" returnType="Config">
		<cfargument name="datasource" type="string" required="false" default="most">
		<cfargument name="cacheTimeSpan" type="any" required="false" default="#createTimeSpan(0,1,0,0)#">

		<cfset this.setDatasource(arguments.datasource) />
		<cfset this.setCacheTimeSpan(arguments.cacheTimeSpan) />

		<cfreturn this />
	</cffunction>

	<cffunction name="getAppConfig" access="public" output="false" returnType="query">

		<cfstoredproc procedure="dbo.usp_constant_select" datasource="most">
			<cfprocresult name="qryAppConfig">
		</cfstoredproc>

		<cfreturn qryAppConfig />

	</cffunction>

</cfcomponent>
