<cfcomponent displayname="messageDAO" output="false" accessors="true">
	<cfproperty name="datasource" type="string">
	<cfproperty name="cacheTimeSpan" type="any">

	<cffunction name="init" access="public" output="false" returnType="dao">
		<cfargument name="datasource" type="string" required="false" default="most">
		<cfargument name="cacheTimeSpan" type="any" required="false" default="#createTimeSpan(0,1,0,0)#">

		<cfset this.setDatasource(arguments.datasource) />
		<cfset this.setCacheTimeSpan(arguments.cacheTimeSpan) />

		<cfreturn this />
	</cffunction>

	<cffunction name="getMessages" access="public" returnType="query" hint="Returns any messages available for users of the application">
		<cfargument name="uid" type="string" required="false" default="#session.uid#">

		<cfset var messages = queryNew("") />

		<cfstoredproc procedure="smart.dbo.usp_messages_select" datasource="most">
			<cfprocparam cfsqltype="cf_sql_varchar" value="#arguments.uid#">
			<cfprocresult name="messages">
		</cfstoredproc>

		<cfreturn messages />
	</cffunction>

	<cffunction name="getMessagesComponent" access="public" returnType="query" hint="Returns any messages available for users of the application">
		<cfargument name="uid" type="string" required="false" default="#session.uid#">

		<cfset var messages = queryNew("") />

		<cfstoredproc procedure="smart.dbo.usp_messages_select_component" datasource="most">
			<cfprocparam cfsqltype="cf_sql_varchar" value="#arguments.uid#">
			<cfprocresult resultset="2" name="messages">
		</cfstoredproc>

		<cfreturn messages />
	</cffunction>

	<cffunction name="getMessagesPortfolio" access="public" returnType="query" hint="Returns any messages available for users of the application">
		<cfargument name="uid" type="string" required="false" default="#session.uid#">

		<cfset var messages = queryNew("") />

		<cfstoredproc procedure="smart.dbo.usp_messages_select_portfolio" datasource="most">
			<cfprocparam cfsqltype="cf_sql_varchar" value="#arguments.uid#">
			<cfprocresult resultset="1" name="messages">
		</cfstoredproc>

		<cfreturn messages />
	</cffunction>

	<cffunction name="getMessagesDropdown" access="public" returnType="query" hint="Returns all (component share & shared portfolio) messages available for users of the application">
		<cfargument name="uid" type="string" required="false" default="#session.uid#">

		<cfset var query1 = getMessagesComponent(arguments.uid) />
		<cfset var query2 = getMessagesPortfolio(arguments.uid) />
		<!--- <cfset var query3 = getAnnouncements() /> --->

		<cfset var userShares = queryNew("") />

		<cfquery name="userShares" dbtype="query">
			select id, share_note, share_date, att_full_name, smart_msg, share_url, 'c' as type
			from query1
			union
			select id, message_text as share_note, insert_date as share_date, sender as att_full_name, 1 as smart_msg, share_url, type
			from query2
			order by share_date desc
		</cfquery>

		<cfreturn userShares />
	</cffunction>

	<cffunction name="getShareForModule" access="public" returnType="query" hint="Returns a component share message available for display on a module">
		<cfargument name="uid" type="string" required="false" default="#session.uid#">
		<cfargument name="pid" type="numeric" required="true">
		<cfargument name="cid" type="numeric" required="true">
		<cfargument name="filter" type="string" required="false" default="">
		<cfargument name="start_uid" type="string" required="false" default="">

		<cfset var share = queryNew("") />

		<cfstoredproc procedure="smart.dbo.usp_messages_select_component" datasource="most">
			<cfprocparam cfsqltype="cf_sql_varchar" value="#arguments.uid#" dbvarname="@uid">
			<cfif arguments.pid neq 0>
			<cfprocparam cfsqltype="cf_sql_integer" value="#arguments.pid#" dbvarname="@pid">
			<cfelse>
			<cfprocparam cfsqltype="cf_sql_integer" null="yes" dbvarname="@id">
			</cfif>
			<cfprocparam cfsqltype="cf_sql_integer" value="#arguments.cid#" dbvarname="@cid">
			<cfif arguments.filter eq "" or arguments.filter eq "undefined">
				<cfprocparam cfsqltype="cf_sql_varchar" value="" dbvarname="@filter">
			<cfelse>
				<cfprocparam cfsqltype="cf_sql_varchar" value="#arguments.filter#" dbvarname="@filter">
			</cfif>
			<cfif arguments.start_uid neq "">
				<cfprocparam cfsqltype="cf_sql_varchar" value="#arguments.start_uid#" dbvarname="@start_uid">
			<cfelse>
				<cfprocparam cfsqltype="cf_sql_varchar" value="" dbvarname="@start_uid">
			</cfif>
			<cfprocresult resultset="2" name="share">
		</cfstoredproc>

		<cfreturn share />
	</cffunction>

	<cffunction name="saveShare" access="public" returnType="numeric" hint="Saves a component share from one user to another">
		<cfargument name="fa" type="string" required="true">
		<cfargument name="share_uid" type="string" required="true">
		<cfargument name="component_id" type="numeric" required="true">
		<cfargument name="portfolio_id" type="numeric" required="false" default="#session.currentPortfolio#">
		<cfargument name="filter" type="string" required="false" default="">
		<cfargument name="start_uid" type="string" required="false" default="">
		<cfargument name="share_note" type="string" required="false" default="">
		<cfargument name="share_url" type="string" required="true">
		<cfargument name="smart" type="numeric" required="true">
		<cfargument name="q_mssg" type="numeric" required="true">
		<cfargument name="outlook" type="numeric" required="true">

		<cfset var success = 1 />

		<cftry>
			<!--- To support quick search parameters and future SSRS exchanges --->
			<cfstoredproc procedure="smart.dbo.usp_share_parameter_insert" datasource="#getDatasource()#">
				<cfprocparam cfsqltype="cf_sql_varchar" value="#session.uid#" dbvarname="@owner_uid">
				<cfprocparam cfsqltype="cf_sql_varchar" value="#arguments.share_uid#" dbvarname="@share_uid">
				<cfprocparam cfsqltype="cf_sql_varchar" value="#arguments.fa#" dbvarname="@fa">
				<cfprocparam type="in" cfsqltype="cf_sql_integer" dbvarname="@portfolio_id" value="#arguments.portfolio_id#">
				<cfprocparam cfsqltype="cf_sql_varchar" value="#arguments.start_uid#" dbvarname="@start_uid">
				<cfprocparam cfsqltype="cf_sql_varchar" value="#arguments.filter#" dbvarname="@filter">
				<cfprocparam cfsqltype="cf_sql_varchar" value="#arguments.disposition#" dbvarname="@disposition">
				<cfprocparam cfsqltype="cf_sql_varchar" value="#arguments.hier#" dbvarname="@hier">
				<cfprocparam cfsqltype="cf_sql_integer" value="#arguments.component_id#" dbvarname="@component_id">
				<cfif session.sctFilters.lstsis neq "">
				<cfprocparam type="in" cfsqltype="cf_sql_varchar" dbvarname="@si_list" value="#session.sctFilters.lstsis#">
				<cfelse>
				<cfprocparam type="in" cfsqltype="cf_sql_varchar" dbvarname="@si_list" null="yes">
				</cfif>
				<cfif not session.evtchain["pids"] eq "">
				<cfprocparam type="in" cfsqltype="cf_sql_varchar" dbvarname="@pid_list" value="#session.evtchain.pids#">
				<cfelseif session.sctFilters.lstpids neq "">
				<cfprocparam type="in" cfsqltype="cf_sql_varchar" dbvarname="@pid_list" value="#session.sctFilters.lstpids#">
				<cfelse>
				<cfprocparam type="in" cfsqltype="cf_sql_varchar" dbvarname="@pid_list" null="yes">
				</cfif>
				<cfif session.sctFilters.lstams neq "">
				<cfprocparam type="in" cfsqltype="cf_sql_varchar" dbvarname="@am_list" value="#session.sctFilters.lstams#">
				<cfelse>
				<cfprocparam type="in" cfsqltype="cf_sql_varchar" dbvarname="@am_list" null="yes">
				</cfif>
				<cfif session.sctFilters.lstpms neq "">
				<cfprocparam type="in" cfsqltype="cf_sql_varchar" dbvarname="@pm_list" value="#session.sctFilters.lstpms#">
				<cfelse>
				<cfprocparam type="in" cfsqltype="cf_sql_varchar" dbvarname="@pm_list" null="yes">
				</cfif>
				<cfif session.sctFilters.lstOwner neq "">
				 <cfprocparam type="in" cfsqltype="cf_sql_varchar" dbvarname="@contact_list" value="#session.sctFilters.lstOwner#">
				<cfelse>
				<cfprocparam type="in" cfsqltype="cf_sql_varchar" dbvarname="@contact_list" null="yes">
				</cfif>
				<cfif session.sctFilters.lstMots neq "">
			     <cfprocparam type="in" cfsqltype="cf_sql_varchar" dbvarname="@mots_list" value="#session.sctFilters.lstMots#">
				<cfelse>
				 <cfprocparam type="in" cfsqltype="cf_sql_varchar" dbvarname="@mots_list" null="yes">
				</cfif>
				<cfprocresult name="qShareParams">
			</cfstoredproc>

			<cfset theUrl = arguments.share_url & "&shareid=" & qShareParams.shareID />

			<cfstoredproc procedure="smart.dbo.usp_messages_insert_component" datasource="#getDatasource()#" returncode="true">
				<cfprocparam cfsqltype="cf_sql_varchar" value="#arguments.share_uid#" dbvarname="@share_uid">
				<cfprocparam cfsqltype="cf_sql_varchar" value="#session.uid#" dbvarname="@attuid">
				<cfprocparam cfsqltype="cf_sql_integer" value="#arguments.component_id#" dbvarname="@component_id">
				<cfprocparam cfsqltype="cf_sql_integer" value="#arguments.portfolio_id#" dbvarname="@portfolio_id">
				<cfprocparam cfsqltype="cf_sql_varchar" value="#arguments.filter#" dbvarname="@filter">
				<cfif arguments.start_uid neq "">
					<cfprocparam cfsqltype="cf_sql_varchar" value="#arguments.start_uid#" dbvarname="@start_uid">
				<cfelse>
					<cfprocparam cfsqltype="cf_sql_varchar" null="yes" dbvarname="@start_uid">
				</cfif>
				<cfprocparam cfsqltype="cf_sql_varchar" value="#arguments.share_note#" dbvarname="@share_note">
				<cfprocparam cfsqltype="cf_sql_varchar" value="#theUrl#" dbvarname="@share_url">
				<cfprocparam cfsqltype="cf_sql_bit" value="#arguments.smart#" dbvarname="@smart_msg">
				<cfprocparam cfsqltype="cf_sql_bit" value="#arguments.q_mssg#" dbvarname="@q_msg">
				<cfprocparam cfsqltype="cf_sql_bit" value="#arguments.outlook#" dbvarname="@outlook_msg">
			</cfstoredproc>

			<!--- <cfset success = cfstoredproc.StatusCode /> --->
			<cfset success = qShareParams.shareID />

			<cfcatch type="database">
				<cfset  success = 0 />
			</cfcatch>
		</cftry>

		<cfreturn success />

	</cffunction>

	<cffunction name="getComponentShare" access="public" returnType="query" output="false">
		<cfargument name="share_id" type="numeric" required="true">

			<cfquery name="qShare" datasource="#getDatasource()#">
				select share_id, owner_uid, share_uid, fa, portfolio_id, start_uid, filter, disposition, hier, component_id, si_list, pid_list, am_list, pm_list, owner_list, mots_list, insert_date
				from smart.dbo.tbl_share_parameters with(nolock)
				where share_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.share_id#">
			</cfquery>

		<cfreturn qShare />
	</cffunction>

	<cffunction name="removeShare" access="public" output="false" returnType="string" hint="Archives the share so it no longer displays">
		<cfargument name="share_uid" type="string" required="false" default="#session.uid#">
		<cfargument name="pid" type="numeric" required="true">
		<cfargument name="cid" type="numeric" required="true">
		<cfargument name="filter" type="string" required="false" default="">
		<cfargument name="start_uid" type="string" required="false" default="">
		<cfargument name="msg_id" type="numeric" required="false" default="0">

		<cfset var success = 1 />

		<cftry>
			<cfstoredproc procedure="smart.dbo.usp_messages_update_component" datasource="most" returncode="true">
				<cfprocparam cfsqltype="cf_sql_varchar" value="#arguments.share_uid#" dbvarname="@uid">
				<cfprocparam cfsqltype="cf_sql_integer" value="#arguments.pid#" dbvarname="@pid">
				<cfprocparam cfsqltype="cf_sql_integer" value="#arguments.cid#" dbvarname="@cid">
				<cfif arguments.filter eq "" or arguments.filter eq "undefined">
					<cfprocparam cfsqltype="cf_sql_varchar" value="" dbvarname="@filter">
				<cfelse>
					<cfprocparam cfsqltype="cf_sql_varchar" value="#arguments.filter#" dbvarname="@filter">
				</cfif>
				<cfif arguments.start_uid neq "">
					<cfprocparam cfsqltype="cf_sql_varchar" value="#arguments.start_uid#" dbvarname="@start_uid">
				<cfelse>
					<cfprocparam cfsqltype="cf_sql_varchar" null="yes" dbvarname="@start_uid">
				</cfif>
				<cfprocparam cfsqltype="cf_sql_integer" value="#arguments.msg_id#" dbvarname="@msgid">
			</cfstoredproc>

			<cfset success = cfstoredproc.StatusCode />

			<!--- Update Messages Portfolio based off msg_id --->
			<cfif val(arguments.msg_id)>
				<cfstoredproc procedure="smart.dbo.usp_messages_update_portfolio" datasource="most">
					<cfprocparam cfsqltype="cf_sql_integer" value="#arguments.msg_id#" dbvarname="@id">
				</cfstoredproc>
			</cfif>

 			<cfcatch type="any">
				<cfset success =  0 />
			</cfcatch>

		</cftry>

		<cfreturn success />
	</cffunction>

	<cffunction name="saveBanner" access="public" returnType="Numeric" output="true">
		<cfargument name="attuid" type="string" required="false" default="#session.uid#">
		<cfargument name="severity" type="string" required="false" default="">
		<cfargument name="msg_text" type="string" required="false" default="">
		<cfargument name="notes" type="string" required="false" default="">
		<cfargument name="msg_start_time" type="any" required="true">
		<cfargument name="msg_end_time" type="any" required="true">

		<cfset var success = 1 />
		<cftry>
			<cfstoredproc procedure="smart.dbo.usp_messages_update_banner" datasource="#getDatasource()#" returncode="yes">
				<cfprocparam type="in" cfsqltype="cf_sql_varchar" dbvarname="@attuid" value="#arguments.attuid#">
				<cfprocparam type="in" cfsqltype="cf_sql_integer" dbvarname="@module_id" value="0">
				<cfprocparam type="in" cfsqltype="cf_sql_integer" dbvarname="@component_id" value="0">
				<cfprocparam type="in" cfsqltype="cf_sql_varchar" dbvarname="@severity" value="#arguments.severity#">
				<cfprocparam type="in" cfsqltype="cf_sql_varchar" dbvarname="@msg_text" value="#arguments.msg_text#">
				<cfprocparam type="in" cfsqltype="cf_sql_varchar" dbvarname="@notes" value="#arguments.notes#">
				<cfprocparam type="in" cfsqltype="cf_sql_varchar" dbvarname="@msg_start_date" value="#arguments.msg_start_time#">
				<cfprocparam type="in" cfsqltype="cf_sql_varchar" dbvarname="@msg_end_date" value="#arguments.msg_end_time#">
			</cfstoredproc>

			<cfset success = cfstoredproc.StatusCode />

			<cfcatch type="any">
				<cfset success = 0 />
			</cfcatch>
		</cftry>

		<cfreturn success />
	</cffunction>

	<cffunction name="saveAnnouncement" access="public" returnType="Numeric" output="true">
		<cfargument name="attuid" type="string" required="false" default="#session.uid#">
		<cfargument name="msg_text" type="string" required="false" default="">
		<cfargument name="title" type="string" required="false" default="">
		<cfargument name="subtitle" type="string" required="true">
		<cfargument name="link" type="string" required="true">

		<cfset var success = 1 />
		<cftry>
			<cfstoredproc procedure="smart.dbo.usp_messages_insert_announcement" datasource="#getDatasource()#" returncode="yes">
				<cfprocparam type="in" cfsqltype="cf_sql_varchar" dbvarname="@attuid" value="#arguments.attuid#">
				<cfprocparam type="in" cfsqltype="cf_sql_varchar" dbvarname="@title" value="#arguments.title#">
				<cfprocparam type="in" cfsqltype="cf_sql_varchar" dbvarname="@subtitle" value="#arguments.subtitle#">
				<cfprocparam type="in" cfsqltype="cf_sql_varchar" dbvarname="@link" value="#arguments.link#">
				<cfprocparam type="in" cfsqltype="cf_sql_varchar" dbvarname="@msg_text" value="#arguments.msg_text#">
			</cfstoredproc>

			<cfset success = cfstoredproc.StatusCode />

			<cfcatch type="any">
				<cfset success = 0 />
			</cfcatch>
		</cftry>

		<cfreturn success />
	</cffunction>

	<cffunction name="deleteAnnounce" access="remote" returnType="string" returnFormat="plain" output="true">
		<cfargument name="id" type="numeric" required="true">

		<cfset var success = 0 />
		<cftry>
			<cfstoredproc procedure="smart.dbo.usp_messages_delete_announcement" datasource="most" returncode="yes">
				<cfprocparam type="in" cfsqltype="cf_sql_integer" dbvarname="@id" value="#arguments.id#">
			</cfstoredproc>

			<cfset success = cfstoredproc.StatusCode />

			<cfcatch type="any">
				<cfset success = 0 />
			</cfcatch>
		</cftry>

		<cfreturn success />
	</cffunction>

	<cffunction name="getNotification" access="public" returnType="query" output="false">

			<cfstoredproc procedure="smart.dbo.usp_messages_select_banner_history" datasource="#getDatasource()#">
				<cfprocparam type="in" cfsqltype="cf_sql_integer" dbvarname="@module_id" value="0">
				<cfprocparam type="in" cfsqltype="cf_sql_integer" dbvarname="@component_id" value="0">
				<cfprocparam type="in" cfsqltype="cf_sql_varchar" dbvarname="@id" value="0">
				<cfprocresult name="qNotification">
			</cfstoredproc>

		<cfreturn qNotification />
	</cffunction>

	<cffunction name="getBanner" access="public" returnType="query" output="false">

			<cfset qBanner = queryNew("empty") />

			<cfstoredproc procedure="smart.dbo.usp_messages_select_banner" datasource="#getDatasource()#">
				<cfprocparam type="in" cfsqltype="cf_sql_integer" dbvarname="@module_id" value="0">
				<cfprocparam type="in" cfsqltype="cf_sql_integer" dbvarname="@component_id" value="0">
				<cfprocresult name="qBanner">
			</cfstoredproc>

		<cfreturn qBanner />
	</cffunction>

	<cffunction name="getAnnouncements" access="public" returnType="query" output="false">

			<cfset qAnnounce = queryNew("empty") />

			<cfstoredproc procedure="smart.dbo.usp_messages_select_announcement" datasource="#getDatasource()#">
				<cfprocresult name="qAnnounce">
			</cfstoredproc>

		<cfreturn qAnnounce />
	</cffunction>

	<cffunction name="getAnnouncementHistory" access="public" returnType="query" output="false">

			<cfset qAnnounce = queryNew("empty") />

			<cfstoredproc procedure="smart.dbo.usp_messages_select_announcement_history" datasource="#getDatasource()#">
				<cfprocresult name="qAnnounce">
			</cfstoredproc>

		<cfreturn qAnnounce />
	</cffunction>

	<cffunction name="getAnnounceDetail" access="public" returnType="query" hint="Returns announcement based on id">
		<cfargument name="id" type="numeric" required="true">

		<cfset qAnnounce = queryNew("empty") />

			<cfstoredproc procedure="smart.dbo.usp_messages_select_announcement" datasource="#getDatasource()#">
				<cfif arguments.id eq 0>
					<cfprocparam type="in" cfsqltype="cf_sql_integer" null="yes">
				<cfelse>
					<cfprocparam type="in" cfsqltype="cf_sql_integer" value="#arguments.id#">
				</cfif>
				<cfprocresult name="qAnnounce">
			</cfstoredproc>

		<cfreturn qAnnounce />
	</cffunction>

</cfcomponent>