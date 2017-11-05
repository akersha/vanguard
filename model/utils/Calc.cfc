<cfcomponent displayname="CalcService" hint="Common Application methods." output="false">

     <cffunction name="init" access="public" output="false" returntype="Calc">
             <cfreturn this />
     </cffunction>

	<cffunction name="createXls" access="remote" output="false" returntype="void">
		<cfargument name="exportQuery" type="query" required="true">
		<cfargument name="password" type="string" required="false" default="password">

		<cfspreadsheet action="write" filename = "filepath" overwrite = "true" password = "#arguments.password#" query = "#arguments.exportQuery#" />
	</cffunction>

	<cffunction name="createXlsDownload" access="remote" output="true" returntype="void">

		<cfargument name="exportQuery" type="query" required="true">
		<cfargument name="columnList" type="string" required="true">
		<cfargument name="columnOverride" type="string" required="false" default="">
		<cfargument name="columnDataTypes" type="string" required="false" default="">
		<cfargument name="fileName" type="string" required="false" default="temp.xls">

		<cfset objFormatSvc = createObject("component", "smart.model.utils.format") />

		<cfset var ds = arguments.exportQuery />
		<cfset var columnHeaders = arguments.columnList />
		<cfset var tdLinkStyle = "" />
		<cfset var tdColorStyle = "" />

		<cfif arguments.columnOverride NEQ "">
			<cfset columnHeaders = arguments.columnOverride />
		</cfif>

	<!--- Loop over query and build the content
	1. The use of the columnHeaders var allows for custom presentation column names
	2. The try/catch inside the output of the column data allows for NULL values otherwise the column would error as not being defined
	--->
	<cfsavecontent variable="xlsReport">
	<table border="1"style="background-color:##000040;color:##fff;width:100%;">
	<tr><td><a href="https://www.e-access.att.com/community/entgroup" title="EntGroup home page"><img src="http://essedev.web.att.com/entgroup/images/DETS_logo-sm.png" height="24" width="178" border="0"></a></td><td>&nbsp;</td></tr>
	<tr style="background-color:##000040;color:##fff;"><td>Report: #arguments.fileName#</td><td>Report date: #dateFormat(Now(), 'yyyy-mm-dd')#</td></tr>
	</table>
	<table width="100%" border="1">
	<tr>
	<cfloop list="#columnHeaders#" index="col"><td valign="top" style="background-color:##000040;color:##fff;vertical-align:top;">#col#</td></cfloop>
	</tr>
	<cfoutput query="ds">
	<tr style="background-color:<cfif currentrow MOD 2 EQ 1>##fff<cfelse>##eee</cfif>;">
	<!--- Conditionals for styling the TD --->
		<cfloop list="#arguments.columnList#" index="col">
		<cfset tdLinkStyle = "" />
		<cfset tdColorStyle = "" />
		<cfif col eq "kintana" or col eq "prism_id" or col eq "cr_id">
		<cfset tdLinkStyle = ' color:blue;text-decoration:underline;' />
		</cfif>
		<cfif col eq "health" or col eq "jeopardy">
		<cfswitch expression="#ds[col][currentrow]#">
		<cfcase value="r, red">
			<cfset tdColorStyle = ' bgcolor="ff0000" ' />
		</cfcase>
		<cfcase value="y, yellow">
			<cfset tdColorStyle = ' bgcolor="ffff00" ' />
		</cfcase>
		<cfcase value="g, green">
			<cfset tdColorStyle = ' bgcolor="00b050" ' />
		</cfcase>
		</cfswitch>
		</cfif>
		<!--- //End style conditionals --->
		<td valign="top" style="vertical-align:top;#tdLinkStyle#"#tdColorStyle#>
		<cftry>
		<cfswitch expression = "#col#">
		<cfdefaultcase>#ds[col][currentrow]#</cfdefaultcase>
		<cfcase value = "kintana"><a href="http://myprism.cingular.net/ittools/project/resources/cfm/projectView.cfm?activeTab=project&kintana=#ds[col][currentrow]#">#ds[col][currentrow]#</a></cfcase>
		<cfcase value = "prism_id"><a href="http://myprism.cingular.net/ittools/project/resources/cfm/projectView.cfm?activeTab=project&kintana=#ds[col][currentrow]#">#ds[col][currentrow]#</a></cfcase>
		<cfcase value = "cr_id"><a href="http://intranet.att.com/oneattcr/crSummary.cfm?crid=#ds[col][currentrow]#">#ds[col][currentrow]#</a></cfcase>
		<cfcase value = "apm,lpm,tower_vp,am_name,pm_name,program_manager,pm_lvl_1_name,pm_lvl_2_name,pm_lvl_3_name,pm_lvl_4_name,pm_supv_name,si_owner_name,contact_name,pm_lvl1_name,pm_lvl2_name,pm_lvl3_name,pm_lvl4_name,ed_name,dir_name,originator_name,sponsoring_officer_name,sponsor_officer_name">#objFormatSvc.capname(ds[col][currentrow])#</cfcase>
		<cfcase value="requested_release_date_1,requested_release_date_2,commit_release_date">#dateFormat(ds[col][currentrow], "yymm")#</cfcase>
		<cfcase value="total_mde,budget_totals,vp_mde,dde_1,dde_2">#numberFormat(ds[col][currentrow], "$999,999,999.99")#</cfcase>
		</cfswitch>
		<cfcatch type="any">&nbsp;</cfcatch>
		</cftry></td>
		</cfloop>
	</tr>
	</cfoutput>
	</table>
	</cfsavecontent>

		<cfheader name="Content-Disposition" value="attachment; filename=#arguments.fileName#">
				<cfcontent type="application/vnd.msexcel" reset="yes">
				#xlsReport#
				<cfabort>

	</cffunction>

	<cffunction name="columnTotals"
	returntype="any"
	access="public"
	output="false"
	hint="Returns a structure containing key/values for column/totals in a query">
	<cfargument name="TheQuery" type="query" required="true" hint="The query to be totaled.">
	<cfargument name="Columns" type="string" required="true" hint="A comma delimited list of query columns to be totaled.">
	   <cfargument name="ShowNulls" type="boolean" default="false" hint="optional. Set true to return null values as null, false to return null values as 0">

	<cfset var ret = {}>
	<!--- Do a listCompare here for insurance purposes --->
	<cfset var rest = listCompare(columns,thequery.columnlist)>
	<cfset var x = "">
	<cfset var y = "">

	   <cfloop list="#columns#" index="x">
		<cfif arguments.shownulls>
	           <cfset ret[x] = "">
	           <cfloop list="#Evaluate("ValueList(thequery." & x & ")")#" index="y">
	               <cfif y NEQ "">
	                   <cfif ret[x] EQ "">
	                       <cfset ret[x] = y>
	                   <cfelse>
	                       <cfset ret[x] += y>
	                   </cfif>
	               </cfif>
	           </cfloop>
	       <cfelse>
	           <cfset ret[x] = ArraySum(ListToArray(Evaluate("ValueList(thequery." & x & ")")))>
	       </cfif>
	</cfloop>

	<cfreturn ret>
	</cffunction>

	<!---
	 * This UDF calculates the total of a column from a query.
	 * Version 2 by Raymond Camden
	 *
	 * @param qryColumn 	 The name and column of the query, i.e. foo.total (Required)
	 * @return Returns a number.
	 * @author Scott Barber (charlesbarber@hotmail.com)
	 * @version 2, May 13, 2003
	 */
	 --->
	<cffunction name="columnTotal"
	returntype="numeric"
	access="public"
	output="false"
	hint="Returns the sum of a numeric column from a query.">
	<cfargument name="QueryColumn" type="string" required="true" hint="Query and column name in query.column format.">

	<cfset var ret = 0>
	<cftry>
		<cfset ret = arraySum(listToArray(Evaluate("ValueList(" & QueryColumn & ")")))>
		<cfcatch type="any">
			<cfthrow message="columnTotal Error: Supplied column has non-numeric values or does not exist in query.">
		</cfcatch>
	</cftry>

	<cfreturn ret>
	</cffunction>

	<!---
	 * Case-sensitive function for removing duplicate entries in a list.
	 * Based on dedupe by Raymond Camden
	 *
	 * @param list 	 The list to be modified.
	 * @return Returns a list.
	 * @author Jeff Howden (jeff@members.evolt.org)
	 * @version 1, March 21, 2002
	 --->
	<cffunction name="listDistinct"
		returntype="string"
		access="public"
		output="false"
		hint="Returns distinct values from a given list.">
		<cfargument name="TheList" type="string" required="true" hint="The List with potential duplicated values.">
		<cfargument name="Delimiter" type="string" required="true" default="," hint="Default delimiter is a comma, which can be overriden with this second argument.">

		<cfscript>
		var distinctValues = "";
		var totalValues = 0;
		var i = 0;
		var currentElement = "";


		// If the user specifies their own delimiter, use that one instead
		if (arrayLen(arguments) GT 1) delimiter = arguments[2];

		totalValues = listLen( theList, delimiter );

		// Loops over each element in the original list and appends the current
		// element if it does not already exist in the distinct values list
		for (i=1; i LTE totalValues; i=i+1) {
			currentElement = listGetAt(theList, i, delimiter);
			if (not listFind(distinctValues, currentElement, delimiter) ) {
				distinctValues = listAppend(distinctValues, currentElement, delimiter);
			}
		}

		return distinctValues;
		</cfscript>
	</cffunction>

	<cffunction name="queryToArray" access="public" output="no" returntype="array" description="Converts a query to an array object.  Commonly used when you want to return query results in ajax">

       <cfargument name="query" type="query" required="yes" hint="query to convert to an array">

       <cfset local.columns = arguments.query.getColumnNames()>
       <cfset local.queryArray = ArrayNew(1)>

       <cfloop query="arguments.query">
          <cfset local.row = StructNew()>
          <cfloop index="i" from="1" to="#ArrayLen(columns)#">
                   <cfset row[LCase(columns[i])] = arguments.query[columns[i]][arguments.query.CurrentRow]>
          </cfloop>
          <cfset ArrayAppend(queryArray, row)>
       </cfloop>

       <cfreturn queryArray>

    </cffunction>

</cfcomponent>