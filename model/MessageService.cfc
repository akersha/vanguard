<cfcomponent displayname="messageService" output="false" accessors="true">

	<cffunction name="init" access="public" output="false" returnType="service">
		<cfset objMessage = createObject("component","devgear.model.message").init()>

		<cfreturn this />
	</cffunction>

	<cffunction name="getMessages" access="remote" returnType="query" hint="Returns any messages available for users of the application">
		<cfargument name="uid" type="string" required="false" default="#session.uid#">

		<cfset var objMessage = createObject("component","devgear.model.message").init()>
		<cfset var messages = objMessage.getMessages(arguments.uid) />

		<cfreturn messages />
	</cffunction>

	<cffunction name="getAnnouncements" access="public" returnType="query" hint="Returns any messages available for users of the application">

		<cfset var objMessage = createObject("component","devgear.model.message").init()>
		<cfset var messages = objMessage.getAnnouncements() />

		<cfreturn messages />
	</cffunction>

	<cffunction name="getAnnounceDetail" access="public" returnType="query" hint="Returns announcement based on id">
		<cfargument name="id" type="numeric" required="true">

		<cfset var objMessage = createObject("component","devgear.model.message").init()>
		<cfset var message = objMessage.getAnnounceDetail( arguments.id ) />

		<cfreturn message />
	</cffunction>

	<cffunction name="getMessagesDropdown" access="remote" returnType="string" returnFormat="plain" hint="Returns all (component share & shared portfolio) messages available for users of the application">
		<cfargument name="uid" type="string" required="false" default="#session.uid#">
		<cfargument name="ignoreMsg" type="string" required="false" default="">

		<cfset var objMessage = createObject("component","devgear.model.message").init()>
		<cfset var objFormatter = createObject("component", "devgear.model.utils.format").init() />
		<cfset var userShares = objMessage.getMessagesDropdown(arguments.uid) />
		<cfset var userAnnounce = objMessage.getAnnouncements() />
		<cfset var messages = "" />

		<cfsavecontent variable="messages">
			<cfif userAnnounce.recordCount>
				<cfoutput query="userAnnounce">
					<cfif listFind(arguments.ignoreMsg, id) eq 0>
					<li class="message">
					<!--- check for links going outside of devgear --->
						<cfif link contains "http://" or link contains "https://">
                       	    <span class="sillyLink" onclick="javascript:devgearv2.outLink('#link#')">#title#</span><br>
                            <span class="help-block">#dateformat(insert_date, "mm/dd")# from: devgear Team</span>
                        <cfelse>
                            <a href="index.cfm?fa=notifyDetail&anc=#id#&id=#id####monthasstring(month(insert_date))##id#" data-id="#id#" data-type="#type#">#title#</a><br>
                            <span class="help-block">#dateformat(insert_date, "mm/dd")# from: devgear Team</span>
                        </cfif>
					</li>
	                </cfif>
				</cfoutput>
			</cfif>
			<cfif userShares.recordCount>
				<cfoutput query="userShares">
					<cfif userShares.devgear_msg eq 1>
	              	  	<li class="message">
		              	  	<span class="help-block">
                            <a href="<cfif share_url neq ''><cfif type eq 's'>#share_url##id#<cfelse>#share_url#</cfif><cfelse>javascript:void(0)</cfif>" data-id="#id#" data-type="#type#">
	              	  	  #left(share_note, 100)#</a> by #objFormatter.capName(att_full_name)#. &nbsp;
                          Go to <a href="index.cfm?fa=portfolio.admin" style="font-style:italic">Manage Portfolios</a> to access and set preferences
			              	  	<!---#dateformat(share_date, "mm/dd")# from: #objFormatter.capName(att_full_name)#---></span>

						</li>
	                </cfif>
				</cfoutput>
			</cfif>
			<!--- removed/relocated ss2191 <a class="btn btn-default" href="index.cfm?fa=notifications" role="button">All Messages</a>
            <a class="btn btn-default" href="index.cfm?fa=notifyDetail&id=0" role="button">Announcements</a>
            <cfif session.developer>
            <a class="btn btn-default" href="index.cfm?fa=notifyAdmin" role="button">Banner Admin</a>
            </cfif>--->
		</cfsavecontent>

		<cfreturn messages />
	</cffunction>

	<cffunction name="saveBanner" access="remote" returnType="void" output="true">
		<cftry>
			<cfset var objMessage = createObject("component","devgear.model.message").init() />
			<cfset var success = 0 />
			<cfset var messageStruct = {} />

			<cfparam name="request.messagetype" type="string" default="Banner">

			<cfset messageStruct.severity = request.severity />
			<cfset messageStruct.msg_text = request.bannerMessage />
			<cfset messageStruct.notes = request.bannerNote />
			<cfset messageStruct.msg_start_time = "" />
			<cfset messageStruct.msg_end_time = "" />

			<cfif start_time_ampm eq "PM">
				<cfset request.start_time_hour = request.start_time_hour + 12 />
			</cfif>
			<cfif end_time_ampm eq "PM">
				<cfset request.end_time_hour = request.end_time_hour + 12 />
			</cfif>
			<cfset messageStruct.msg_start_time = request.startDate & " " & request.start_time_hour & ":" & request.start_time_min  />
			<cfset messageStruct.msg_end_time = request.endDate & " " & request.end_time_hour & ":" & request.end_time_min />

			<cfset success = objMessage.saveBanner( argumentCollection=messageStruct ) />

			<cflocation url="# Application.config['webroot'] #index.cfm?fa=notifyAdmin&success=#success#" addtoken="no">

			<cfcatch type="any">
				<cfoutput>#cfcatch.message#<br>#cfcatch.detail#</cfoutput>
			</cfcatch>

		</cftry>
	</cffunction>

	<cffunction name="saveAnnouncement" access="remote" returnType="void" output="true">
		<cftry>
			<cfset var objMessage = createObject("component","devgear.model.message").init() />
			<cfset var success = 0 />
			<cfset var messageStruct = {} />

			<cfset messageStruct.msg_text = request.msg_text />
			<cfset messageStruct.title = request.title />
			<cfset messageStruct.subtitle = request.subtitle />
			<cfset messageStruct.link = request.link />

			<cfset success = objMessage.saveAnnouncement( argumentCollection=messageStruct ) />

			<cflocation url="#Application.config['webroot']#index.cfm?fa=announcement&success=#success#" addtoken="no">

			<cfcatch type="any">
				<cfoutput>#cfcatch.message#<br>#cfcatch.detail#</cfoutput>
			</cfcatch>

		</cftry>
	</cffunction>

	<cffunction name="createMessage" access="remote" returnType="string" returnFormat="plain" output="false">
		<cfargument name="mailTo" type="string" required="true">
		<cfargument name="mailFrom" type="string" required="true">
		<cfargument name="mailSubject" type="string" required="true">
		<cfargument name="mailBody" type="string" required="true">

		<cfset var success = 1 />
		<cftry>
			<cfset newMail = sendMail( mailTo: arguments.mailTo, mailFrom: arguments.mailFrom, mailSubject: arguments.mailSubject,mailBody: arguments.mailBody ) />
			<cfcatch type="any">
				<cfset success =  0 />
			</cfcatch>
		</cftry>

		<cfreturn success />
	</cffunction>

	<cffunction name="sendMail" access="public" output="false" returnType="void">
		<cfargument name="mailTo" type="string" required="true">
		<cfargument name="mailFrom" type="string" required="true">
		<cfargument name="mailSubject" type="string" required="true">
		<cfargument name="mailBody" type="string" required="true">
		<cfargument name="mailType" type="string" required="false" default="html">
		<cfargument name="mailCC" type="string" required="false" default="">
		<cfargument name="mailBCC" type="string" required="false" default="">
		<cfargument name="mailAttach" type="string" required="false" default="">
		<cfargument name="mailAttachMimeType" type="string" required="false" default="">
<!--- server="aspmx.l.google.com" --->
<cfmail from="#arguments.mailFrom#"
	to="#arguments.mailTo#"
	cc="#arguments.mailCC#"
	bcc="#arguments.mailBCC#"
	subject="#arguments.mailSubject#"
	type="#arguments.mailType#"
	port="587"
	username="mailadmin@vanguardshield.com"
	password="Vanguard2013!"
	server="mail01-p2.ezhostingserver.com"
	>
	<cfif arguments.mailAttach neq "">
		<cfmailparam file="#arguments.mailAttach#" type="#arguments.mailAttachMimeType#" disposition="attachment">
	</cfif>
	<p>&nbsp;</p>
	#arguments.mailBody#
</cfmail>

		<cfreturn />
	</cffunction>

</cfcomponent>