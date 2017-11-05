<cfcomponent displayname="FormatService" hint="Methods to format strings and urls" output="false">

        <cffunction name="init" access="public" output="false" returntype="format">
                <cfreturn this />
        </cffunction>

		<cffunction name="stripHTML" hint="Replace all html commands in a string and see if there is any real content left" returntype="string">
		<!---
		/**
		 * Removes HTML from the string.
		 * v2 - Mod by Steve Bryant to find trailing, half done HTML.
		 * v4 mod by James Moberg - empties out script/style blocks
		 *
		 * @param string      String to be modified. (Required)
		 * @return Returns a string.
		 * @author Raymond Camden (ray@camdenfamily.com)
		 * @version 4, October 4, 2010
		 */
		 --->
	<cfargument name="str" type="string">

	    <cfset str = reReplaceNoCase(str, "<*style.*?>(.*?)</style>","","all")>
	    <cfset str = reReplaceNoCase(str, "<*script.*?>(.*?)</script>","","all")>

	     <cfset str = reReplaceNoCase(str, "<.*?>","","all")>
	    <!--- get partial html in front --->
	     <cfset str = reReplaceNoCase(str, "^.*?>","")>
	    <!--- get partial html at end --->
	    <cfset  str = reReplaceNoCase(str, "<.*$","")>
	    <cfreturn str>
	</cffunction>

		<!--- Return a 10 digit number formatted as a phone number --->
		<cffunction name="phoneFormat"
			returntype="string"
			access="public"
			output="false"
			hint="Returns a 10 digit telephone number formatted as (NPA)NNX-LINE">
			<cfargument name="Phone" type="string" required="true" hint="Ten digit phone number to be formatted.">

			<cfset var ret = phone>

			<cfif Len(phone) EQ 10>
				<cfset ret = '(' & Left(phone,3) & ')' & Mid(phone,4,3) & '-' & Right(phone,4)>
			</cfif>

			<cfreturn ret>
		</cffunction>

		<cffunction name="phoneURL"
			returntype="string"
			access="public"
			output="false"
			hint="Given an ATTUID, returns a URL link to that person's entry in the Phone website.">
			<cfargument name="UID" type="string" required="true" hint="An individual ATTUID.">

			<cfreturn 'http://webphone.att.com/cgi-bin/webphones.pl?id=' & UID>
		</cffunction>

		<cffunction name="nSPhoneURL"
			returntype="string"
			access="public"
			output="false"
			hint="Given an ATTUID, returns a URL link to that person's entry in the Network Services implementation of the Phone website.">
			<cfargument name="UID" type="string" required="true" hint="An individual ATTUID.">

			<cfreturn "http://nsweb1.sbc.com/nsphone/search.cfm?submit=SUBMIT&sbcuid_in=" & UID>
		</cffunction>

		<cffunction name="pctFormat"
			returntype="string"
			access="public"
			output="false"
			hint="Formats a number to the specified number of decimal places.  Useful for percentages.">
			<cfargument name="ThisAmount" type="numeric" required="true" hint="The number of hours.">
			<cfargument name="Resolution" type="numeric" required="true" default="1" hint="The number of places to display after the decimal point.">

			<cfscript>
			var new_mask = "999.";
			var mask_loop = "";

			for(mask_loop=1; mask_loop LTE Resolution; mask_loop=mask_loop+1) {
				new_mask = new_mask & '9';
			}

			return NumberFormat(ThisAmount, new_mask);
			</cfscript>
		</cffunction>

		<cffunction name="capName"
			returntype="string"
			access="public"
			output="false"
			hint="Correctly capitalizes a proper name.">
			<cfargument name="Name" type="string" required="true" hint="The name to capitalize. Can be both first and last name combined (middle name too).">

			<cfset var loc = StructNew()>
			<cfset loc.name = LCase(arguments.name)>
			<cfset loc.ret = "">
			<cfset loc.prior = "">

			<!--- Capitalize letters after spaces, dashes and left parenthesis --->
			<cfloop from="1" to="#Len(arguments.name)#" index="loc.x">
				<cfset loc.current = Mid(loc.name,loc.x,1)>
				<cfif loc.x EQ 1 OR REFind("[[:space:]\-\(]",loc.prior)>
					<cfset loc.ret = loc.ret & UCase(loc.current)>
				<cfelse>
					<cfset loc.ret = loc.ret & loc.current>
				</cfif>

				<cfset loc.prior = loc.current>
			</cfloop>

			<cfset loc.ret = Trim(loc.ret)>

			<!--- Look for generational suffixes and capitalize them --->
			<cfset loc.spot = REFindNoCase("[[:space:]](ii|iii|iv|v|vi|vii|viii|ix|x)$",loc.ret)>
			<cfif loc.spot NEQ 0>
				<cfset loc.ret = Left(loc.ret,loc.spot) & UCase(Right(loc.ret,Len(loc.ret) - loc.spot))>
			</cfif>

			<!--- search for Irish people --->
			<cfif Len(loc.ret) GT 3>
				<cfif REFindNoCase("^mc[abcdefghijklmnpqrstvw]",loc.ret) NEQ 0>
					<cfset loc.ret = Left(loc.ret,2) & UCase(Mid(loc.ret,3,1)) & Mid(loc.ret,4,Len(loc.ret))>
				<cfelseif REFindNoCase("^mac[dfglmnstvw]",loc.ret) NEQ 0>
					<cfset loc.ret = Left(loc.ret,3) & UCase(Mid(loc.ret,4,1)) & Mid(loc.ret,5,Len(loc.ret))>
				<!--- This one's for that punk Mark DeGroot! --->
				<cfelseif REFindNoCase("^deg[r]",loc.ret) NEQ 0>
					<cfset loc.ret = Left(loc.ret,2) & UCase(Mid(loc.ret,3,1)) & Mid(loc.ret,4,Len(loc.ret))>
				</cfif>
			</cfif>
			<cfif Len(loc.ret) GT 3>
				<cfset loc.spot = REFindNoCase("[[:space:]](mc)[abcdefghijklmnpqrstvw]",loc.ret)>
				<cfif loc.spot GT 0>
					<cfset loc.ret = Left(loc.ret,loc.spot - 1) & Mid(loc.ret,loc.spot,3) & UCase(Mid(loc.ret,loc.spot + 3,1)) & Mid(loc.ret,loc.spot + 4,Len(loc.ret))>
				</cfif>

				<cfset loc.spot = REFindNoCase("[[:space:]](mac)[dfglmnstvw]",loc.ret)>
				<cfif loc.spot GT 0>
					<cfset loc.ret = Left(loc.ret,loc.spot - 1) & Mid(loc.ret,loc.spot,4) & UCase(Mid(loc.ret,loc.spot + 4,1)) & Mid(loc.ret,loc.spot + 5,Len(loc.ret))>
				</cfif>

				<cfset loc.spot = REFindNoCase("[[:space:]](degr)",loc.ret)>
				<cfif loc.spot GT 0>
					<cfset loc.ret = Left(loc.ret,loc.spot - 1) & Mid(loc.ret,loc.spot,3) & UCase(Mid(loc.ret,loc.spot + 3,1)) & Mid(loc.ret,loc.spot + 4,Len(loc.ret))>
				</cfif>
			</cfif>

			<cfreturn loc.ret>
		</cffunction>


		<cffunction name="capFirst"
			returntype="string"
			access="public"
			output="false"
			hint="Capitalizes the first character in a string. This only capitalizes the first character.  See capName if you want to capitalize a person's name.">
			<cfargument name="String" type="string" required="true" hint="The string to capitalize.">

			<cfreturn UCase(Left(String,1)) & LCase(Right(String,Len(String)-1))>
		</cffunction>

		<cffunction name="longFormat" returntype="string" 	access="public" output="false" hint="Format a number with thousands comma separators.">
			<cfargument name="Number" type="numeric" required="true" hint="The number to format.">

			<cfreturn NumberFormat(arguments.number, '999,999,999,999,999')>
		</cffunction>


<!--- converted from a custom tag, sortArrows will return a set of clickable <th> tags
for use in changing the order of returned rows in a CFQUERY --->
<cffunction name="sortArrows"
	returntype="string"
	access="public"
	output="false"
	hint="Returns a series of &lt;th&gt; tags with clickable columns used for sorting data returned from a &lt;cfquery&gt;. Two variables are added to the URL: order_by = The column to order by.  order = The order (asc or desc).">
	<cfargument name="cat_names" type="string" required="true" hint="A list of reader friendly column names. Must match the length and order of the cat_cols argument.">
	<cfargument name="cat_cols" type="string" required="true" hint="A list of column names from the query. Must match the length and order of the cat_names argument.">
	<cfargument name="querystring" type="string" required="true" default="" hint="An optional URL query string to append to the order_by and order URL variables created by this function.">
	<cfargument name="url_script" type="string" required="true" default="#CGI.SCRIPT_NAME#" hint="Target URL. Defaults to current script name.">

	<cfset var x = 0>
	<cfset var cur_ord = ''>
	<cfset var selected = ''>
	<cfset var class = ''>
	<cfset var enc_parms = '&'>
	<cfset var ret = "">
	<cfset var ThisCat = "">

	<!--- These are set as global variables --->
	<cfparam name="url.order_by" default="">
	<cfparam name="url.order" default="asc">

	<cfloop list="#cat_cols#" index="ThisCat">
		<cfset x = x + 1>
		<cfset cur_ord = 'asc'>
		<cfset selected = ''>
		<cfset class = ''>
		<cfif url.order_by EQ ThisCat>
			<cfset selected = 'y'>
		</cfif>
		<cfif selected NEQ ''>
			<cfset class = 'sort_up'>
			<cfset cur_ord = 'desc'>
			<cfif order EQ 'desc'>
				<cfset class = 'sort_down'>
				<cfset cur_ord = 'asc'>
			</cfif>
		</cfif>

		<cfset ret = ret & '<th class="#class#" nowrap><a href="#url_script#?order_by=#ThisCat#&order=#cur_ord#&#querystring#" TITLE="Sort by #ListGetAt(cat_names,x)#">#ListGetAt(cat_names,x)#</a></th>'>
	</cfloop>

	<cfreturn ret>
</cffunction>


<cffunction name="QURL"
	returntype="string"
	access="public"
	output="false"
	hint="Given an ATTUID, returns a link to start a Q conversation with that user. The link displays an image of the user's current Q presence.">
	<cfargument name="UID" type="string" required="true" hint="An individual ATTUID.">

	<cfreturn '<a href="qto://talk/#arguments.uid#" title="Click to open a Q conversation with #uid#."><img border="0" src="http://presence.q.att.com/presence/#arguments.uid#.gif" width="16" height="16"></a>'>
</cffunction>

<cffunction name="UIDToEmail" returntype="string" access="public" output="false" hint="Given a list of User IDs, returns a string of comma del">
	<cfargument name="UIDList" type="string" required="true" hint="One or more comma delimited User IDs (ATTUID).">
	<cfargument name="Delimiter" type="string" required="true" default="," hint="The delimiter to use between e-mail addresses.">

	<cfreturn ListChangeDelims(arguments.uidlist,"@att.com#arguments.delimiter#") & "@att.com">
</cffunction>

</cfcomponent>