<cfinclude template="_footer.cfm">

		<!--- DEBUG OUTPUT ONLY --->
		<cfif StructKeyExists(request,"debug")>
	    <h3>Application</h3><cfdump var="#application#"><br />
	    <h3>Session</h3><cfdump var="#session#"><br />
	    <h3>Request</h3><cfdump var="#request#"><br />
	    <h3>CGI</h3><cfdump var="#cgi#"><br />
	    <h3>URL</h3><cfdump var="#url#"><cfabort>
	    </cfif>

	</body>
</html>