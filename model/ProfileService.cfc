<cfcomponent displayname="ProfileService" hint="Service layer for all profile methods" output="false">

	<cffunction name="init" displayname="init" output="false" access="public" returnType="ProfileService">

		<cfreturn this />
	</cffunction>

	<cffunction name="get" output="false" returnType="query" access="public" hint="retrieve's' a user's profile">
		<cfargument type="numeric" name="itemID" required="false" default=0>
		<cfargument type="string" name="attuid" required="true">

		<cfset local = {} />
		<cfset local.objData = createObject("component", "vanguard.model.profile").init() />

		<cfset local.objProfile = objData.get(
			itemID: arguments.itemID,
			attuid: arguments.attuid
		) />

		<cfreturn local.objProfile />

	</cffunction>

	<cffunction name="itemDelete" output="false" returnType="void" access="remote" hint="removes an item from a user's profile">
		<cfargument type="numeric" name="itemID" required="true">
		<cfargument type="string" name="attuid" required="true">

		<cfset local = {} />
		<cfset local.objData = createObject("component", "vanguard.model.profile").init() />

		<cfset local.objData.itemDelete(
			itemID: arguments.itemID,
			attuid: arguments.attuid
		) />

		<cfreturn />

	</cffunction>

	<cffunction name="insert" output="false" returnType="string" returnFormat="plain" access="remote" hint="inserts an item in a user's profile">
		<cfargument type="string" name="attuid" required="true">
		<cfargument type="numeric" name="software_type_id" required="true">
		<cfargument type="string" name="name" required="true">
		<cfargument type="string" name="version_no" required="true">
		<cfargument type="string" name="theUrl" required-="false" default="">

		<cfset var local = {} />
		<cfset local.objData = createObject("component", "vanguard.model.profile").init() />

		<cftry>
			<cfset local.objData.insert(
				attuid: arguments.attuid,
				software_type_id: arguments.software_type_id,
				name: arguments.name,
				version_no: arguments.version_no,
				theUrl: arguments.theUrl
			) />

			<cfset local.success = "1" />

			<cfcatch type="any">
				<cfset  local.success = "0" />
			</cfcatch>
		</cftry>

		<cfreturn  local.success />

	</cffunction>

	<cffunction name="update" output="false" returnType="string" returnFormat="plain" access="remote" hint="updates an item in a user's profile">
		<cfargument type="numeric" name="itemID" required="true">
		<cfargument type="numeric" name="software_type_id" required="true">
		<cfargument type="string" name="name" required="true">
		<cfargument type="string" name="version_no" required="true">
		<cfargument type="string" name="theUrl" required-="false" default="">

		<cfset var local = {} />
		<cfset local.objData = createObject("component", "vanguard.model.profile").init() />

		<cftry>
			<cfset local.objData.update(
				itemID: arguments.itemID,
				software_type_id: arguments.software_type_id,
				name: arguments.name,
				version_no: arguments.version_no,
				theUrl: arguments.theUrl
			) />

			<cfset local.success = "1" />

			<cfcatch type="any">
				<cfset  local.success = "0" />
			</cfcatch>
		</cftry>

		<cfreturn  local.success />

	</cffunction>

</cfcomponent>