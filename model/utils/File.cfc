<cfcomponent displayname="FileService" hint="Methods relevant to file creation, editing and logging." output="false">

        <cffunction name="init" access="public" output="false" returntype="File">
                <cfreturn this />
        </cffunction>

		<cffunction name="logRequest" returntype="void" access="public" output="false" displayname="Logs requests to the database">
			<cfargument name="CGIStruct" type="struct" required="true" hint="The CGI structure from the server.">
			<cfargument name="Start" type="string" required="true" hint="The time page execution began as expressed by GetTickCount()">

			<cfset var end_time = GetTickCount()>
			<cfset var elapsed = 0>

			<cfset elapsed = end_time - arguments.start>

			<cfquery name="qInsertRequest" datasource="most">
			insert into
	        	eit_internal.dbo.tbl_portal_request_log
	        (
				attuid
				,ip_address
	            ,web_page
				,query_string
				,elapsed
	            ,request_method
	            ,browser
				,insert_date
			)
			values (
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#client.cur_user#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.cgistruct.remote_addr#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.cgistruct.script_name#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.cgistruct.query_string#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#elapsed#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.cgistruct.request_method#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#left(arguments.cgistruct.http_user_agent,75)#">,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
			)
			</cfquery>

			<cfreturn>
		</cffunction>

		<!--- Returns a directory listing of files older than X of a chosen interval --->
		<cffunction name="findOldFiles"
			returntype="query"
			access="public"
			output="false"
			hint="Returns a directory listing of files older than X of a chosen interval.">
			<cfargument name="directory" type="string" required="true" default="#GetDirectoryFromPath(GetBaseTemplatePath())#" hint="Absolute directory path.">
			<cfargument name="age" type="numeric" required="true" default="1" hint="Number of date parts in history.">
			<cfargument name="datepart" type="string" required="true" default="d" hint="ColdFusion compatible date part. See CF docs on DateAdd or any date function for examples of valid date parts.">
			<cfargument name="filter" type="string" required="true" default="*.*" hint="Filename filter. Wildcards like * are allowed.">
			<cfargument name="recurse" type="boolean" required="true" default="false" hint="Search sub-folders or no.">

			<cfset var rs = "">
			<cfset var ret = "">
			<cfset var neg_age = "">
			<cfset var diff = "">

			<cfif age LT 1>
				<cfthrow message="FindOldFiles Error: Parameter AGE must be a number greater than 0">
			</cfif>

			<cfset neg_age = "-#age#">

			<cfset rs = dirList(directory,filter,recurse)>
			<cfset ret = QueryNew(rs.ColumnList)>

			<!--- <br> --->

			<cfoutput query="rs">
				<cfif DateDiff(datepart,datelastmodified,Now()) GTE age>
					<cfscript>
						QueryAddRow(ret);
						for(x=1; x LTE ListLen(rs.ColumnList); x = x + 1) {
							col = ListGetAt(rs.ColumnList,x);
							QuerySetCell(ret,col,Evaluate(col));
						}
					</cfscript>
				</cfif>
			</cfoutput>

			<cfreturn ret>
		</cffunction>

</cfcomponent>