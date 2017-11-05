<cfcomponent displayname="AdminDAO" output="false"  accessors="true" hint="All data access objects for the Ent Group Admin features">
   <cfproperty name="datasource" type="string">
   <cfproperty name="cacheTimeSpan" type="any">

	<cffunction name="init" access="public" output="false" returntype="dao">
		<cfargument name="datasource" type="string" required="false" default="ReleaseIT">
		<cfargument name="cacheTimeSpan" type="any" required="false" default="#createTimeSpan(0,1,0,0)#">

		<cfset this.setDatasource(arguments.datasource) />
		<cfset this.setCacheTimeSpan(arguments.cacheTimeSpan) />

		<cfreturn this />
	</cffunction>

	<cffunction name="createCRMContact" access="public" output="false" returnType="string">
		<cfargument name="curDate" type="string" required="false" default="">
		<cfargument name="regarding" type="string" required="false" default="">
		<cfargument name="company" type="string" required="false" default="">
		<cfargument name="contactName" type="string" required="true">
		<cfargument name="callTo" type="string" required="true">
		<cfargument name="phone" type="string" required="true">
		<cfargument name="email" type="string" required="true">
		<cfargument name="notes" type="string" required="true">
		<cfargument name="duration" type="string" required="true">
		<cfargument name="result" type="string" required="true">

		<cfstoredproc procedure="dbo.createCRMContact" datasource="#this.getDatasource()#">
			<cfprocparam type="in" cfsqltype="cf_sql_timestamp" value="#arguments.curDate#">
			<cfprocparam type="in" cfsqltype="cf_sql_varchar" value="#arguments.regarding#">
			<cfprocparam type="in" cfsqltype="cf_sql_varchar" value="#arguments.company#">
			<cfprocparam type="in" cfsqltype="cf_sql_varchar" value="#arguments.contactName#">
			<cfprocparam type="in" cfsqltype="cf_sql_varchar" value="#arguments.callTo#">
			<cfprocparam type="in" cfsqltype="cf_sql_varchar" value="#arguments.phone#">
			<cfprocparam type="in" cfsqltype="cf_sql_varchar" value="#arguments.email#">
			<cfprocparam type="in" cfsqltype="cf_sql_varchar" value="#arguments.notes#">
			<cfprocparam type="in" cfsqltype="cf_sql_varchar" value="#arguments.duration#">
			<cfprocparam type="in" cfsqltype="cf_sql_varchar" value="#arguments.result#">
			<cfprocparam type="in" cfsqltype="cf_sql_varchar" value="#session.curUser#">
			<cfprocresult name="qInsert">
		</cfstoredproc>

		<cfif qInsert.newContactID NEQ 0>
			<cfreturn "1">
		<cfelse>
			<cfreturn "0">
		</cfif>

	</cffunction>

	<cffunction name="updateCRMContact" access="public" output="false" returnType="string">
		<cfargument name="id" type="numeric" required="true">
		<cfargument name="curDate" type="string" required="false" default="">
		<cfargument name="regarding" type="string" required="false" default="">
		<cfargument name="company" type="string" required="false" default="">
		<cfargument name="contactName" type="string" required="true">
		<cfargument name="callTo" type="string" required="true">
		<cfargument name="phone" type="string" required="true">
		<cfargument name="email" type="string" required="true">
		<cfargument name="notes" type="string" required="true">
		<cfargument name="duration" type="string" required="true">
		<cfargument name="result" type="string" required="true">

		<cfstoredproc procedure="dbo.updateCRMContact" datasource="#this.getDatasource()#">
			<cfprocparam type="in" cfsqltype="cf_sql_integer" value="#arguments.id#">
			<cfprocparam type="in" cfsqltype="cf_sql_timestamp" value="#arguments.curDate#">
			<cfprocparam type="in" cfsqltype="cf_sql_varchar" value="#arguments.regarding#">
			<cfprocparam type="in" cfsqltype="cf_sql_varchar" value="#arguments.company#">
			<cfprocparam type="in" cfsqltype="cf_sql_varchar" value="#arguments.contactName#">
			<cfprocparam type="in" cfsqltype="cf_sql_varchar" value="#arguments.callTo#">
			<cfprocparam type="in" cfsqltype="cf_sql_varchar" value="#arguments.phone#">
			<cfprocparam type="in" cfsqltype="cf_sql_varchar" value="#arguments.email#">
			<cfprocparam type="in" cfsqltype="cf_sql_varchar" value="#arguments.notes#">
			<cfprocparam type="in" cfsqltype="cf_sql_varchar" value="#arguments.duration#">
			<cfprocparam type="in" cfsqltype="cf_sql_varchar" value="#arguments.result#">
			<cfprocparam type="in" cfsqltype="cf_sql_varchar" value="#session.curUser#">
			<cfprocresult name="qUpdate">
		</cfstoredproc>

		<cfreturn qUpdate.success />

	</cffunction>

	<cffunction name="getCRMContacts" access="public" output="false" returnType="query">
		<cfargument name="contactID" type="string" required="false" default="0">
		<cfargument name="startDate" type="string" required="false" default="7/25/2017">
		<cfargument name="endDate" type="string" required="false" default="7/31/2017">

		<cfstoredproc procedure="dbo.getCRMContacts" datasource="#this.getDatasource()#">
			<cfprocparam type="in" cfsqltype="cf_sql_integer" value="#arguments.contactID#">
			<cfprocparam type="in" cfsqltype="cf_sql_date" value="#arguments.startDate#">
			<cfprocparam type="in" cfsqltype="cf_sql_date" value="#arguments.endDate#">
			<cfprocresult name="qContacts">
		</cfstoredproc>

		<cfreturn qContacts />

	</cffunction>

	<cffunction name="getCRMDetail" access="public" output="false" returnType="query">
		<cfargument name="contactID" type="string" required="true">

		<cfstoredproc procedure="dbo.getCRMDetail" datasource="#this.getDatasource()#">
			<cfprocparam type="in" cfsqltype="cf_sql_integer" value="#arguments.contactID#">
			<cfprocresult name="qContact">
		</cfstoredproc>

		<cfreturn qContact />

	</cffunction>

</cfcomponent>