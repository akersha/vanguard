<cfcomponent displayname="Profile" hint="Service layer for all profile methods" output="false">

	<cffunction name="init" displayname="init" output="false" access="public" returnType="Profile">

		<cfreturn this />
	</cffunction>

	<cffunction name="get" output="false" returnType="query" access="public" hint="retrieve's' a user's profile">
		<cfargument type="numeric" name="itemID" required="false" default=0>
		<cfargument type="string" name="attuid" required="true">

		<cfset objProfile = queryNew("empty") />

		<cfstoredproc procedure="bc_load.dbo.usp_devg_select_all" datasource="#Application.config['dsnmost']#">
			<cfif arguments.itemID neq 0>
				<cfprocparam cfsqltype="cf_sql_integer" value="#arguments.itemID#">
			<cfelse>
				<cfprocparam cfsqltype="cf_sql_integer" null="yes">
			</cfif>
			<cfprocparam cfsqltype="cf_sql_varchar" value="#arguments.attuid#">
			<cfprocresult name="objProfile">
		</cfstoredproc>

		<cfreturn objProfile />

	</cffunction>

	<cffunction name="itemDelete" output="false" returnType="void" access="public" hint="removes an item from a user's profile">
		<cfargument type="numeric" name="itemID" required="true">
		<cfargument type="string" name="attuid" required="true">

		<cfstoredproc procedure="bc_load.dbo.usp_devg_delete_master" datasource="#Application.config['dsnmost']#">
			<cfprocparam cfsqltype="cf_sql_varchar" value="#arguments.attuid#">
			<cfprocparam cfsqltype="cf_sql_integer" value="#arguments.itemID#">
		</cfstoredproc>

		<cfreturn />

	</cffunction>

	<cffunction name="insert" output="false" returnType="void" access="public" hint="inserts an item in a user's profile">
		<cfargument type="string" name="attuid" required="true">
		<cfargument type="numeric" name="software_type_id" required="true">
		<cfargument type="string" name="name" required="true">
		<cfargument type="string" name="version_no" required="true">
		<cfargument type="string" name="theUrl" required-="false" default="">

		<cfstoredproc procedure="bc_load.dbo.usp_devg_insert_master" datasource="#Application.config['dsnmost']#">
			<cfprocparam cfsqltype="cf_sql_varchar" value="#arguments.attuid#">
			<cfprocparam cfsqltype="cf_sql_integer" value="#arguments.software_type_id#">
			<cfprocparam cfsqltype="cf_sql_varchar" value="#arguments.name#">
			<cfprocparam cfsqltype="cf_sql_varchar" value="#arguments.version_no#">
			<cfprocparam cfsqltype="cf_sql_varchar" value="#arguments.theUrl#">
		</cfstoredproc>

	</cffunction>

	<cffunction name="update" output="false" returnType="void" access="public" hint="updates an item in a user's profile">
		<cfargument type="numeric" name="itemID" required="true">
		<cfargument type="numeric" name="software_type_id" required="true">
		<cfargument type="string" name="name" required="true">
		<cfargument type="string" name="version_no" required="true">
		<cfargument type="string" name="theUrl" required-="false" default="">

		<cfstoredproc procedure="bc_load.dbo.usp_devg_update_master" datasource="#Application.config['dsnmost']#">
			<cfprocparam cfsqltype="cf_sql_integer" value="#arguments.itemID#">
			<cfprocparam cfsqltype="cf_sql_varchar" value="#arguments.software_type_id#">
			<cfprocparam cfsqltype="cf_sql_varchar" value="#arguments.name#">
			<cfprocparam cfsqltype="cf_sql_varchar" value="#arguments.version_no#">
			<cfprocparam cfsqltype="cf_sql_varchar" value="#arguments.theUrl#">
		</cfstoredproc>

	</cffunction>

</cfcomponent>