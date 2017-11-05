<cfcomponent displayname="ErrorService" hint="handles logging and display of error messages" output="false" extends="ApplicationService" accessors="true">
	<cfproperty name="datasource" type="string">

        <cffunction name="init" access="public" output="false" returnType="ErrorService">
			<cfargument name="datasource" type="string" required="false" default="most">

			<cfset this.setDatasource(arguments.datasource) />
            <cfreturn this />

        </cffunction>

        <cffunction name="logError" displayname="logError" hint="writes error message to log" access="public" output="false" returntype="void">
                <cfargument name="method" displayName="method" type="string" hint="the name of the method generating the error" required="true" />

                <cfset xmlError = xmlParse(genError(arguments.method, "xml"))>

                <cfif fileExists("C:\inetpub\wwwroot\smart\logs\error.log")>
                        <cffile action = "append"
                            file = "C:\inetpub\wwwroot\smart\logs\error.log"
                            output = "#now()#|#xmlError.xmlRoot.XmlAttributes.errorNumber#|#xmlError.xmlRoot.XmlAttributes.errorMethod#|#xmlError.xmlRoot.XmlAttributes.errorMessage#">
                <cfelse>
                                <cffile action = "write"
                            file = "C:\inetpub\wwwroot\smart\logs\error.log"
                            output = "#now()#|#xmlError.xmlRoot.XmlAttributes.errorNumber#|#xmlError.xmlRoot.XmlAttributes.errorMethod#|#xmlError.xmlRoot.XmlAttributes.errorMessage#">
                </cfif>

                <cfreturn />
        </cffunction>

        <cffunction name="screenError" displayname="dspScreenError" hint="Displays alert or error message on screen" access="public" output="true" returntype="void">
                <cfargument name="alertNum" displayName="alertNum" type="string" hint="the unique identifier" required="true" />

                <cfset xmlError = xmlParse(genAlert(arguments.alertNum, "xml"))>

                <cfoutput>
                        <div class="ui-state-error error-#xmlError.xmlRoot.XmlChildren[4].xmlText#">
                                <span class="error-text">An error occurred  in #xmlError.xmlRoot.XmlChildren[3].xmlText# !</span><br />
                                <span class="error-number">#xmlError.xmlRoot.XmlChildren[1].xmlText#</span> - <span class="error-message">#xmlError.xmlRoot.XmlChildren[2].xmlText#</span>
                        </div>
                </cfoutput>

                <cfreturn />
        </cffunction>

		<cffunction name="screenAlert" displayname="dspScreenAlert" hint="Displays alert  on screen" access="public" output="true" returntype="void">
                <cfargument name="alertNum" displayName="alertNum" type="string" hint="the unique identifier" required="true" />

                <cfset xmlAlert = xmlParse(genAlert(arguments.alertNum, "xml"))>
                <cfoutput>
                        <div class="ui-state-highlight">
                                <span class="alert-text">#xmlAlert.xmlRoot.XmlChildren[2].xmlText#</span>
                        </div>
                </cfoutput>

                <cfreturn />
        </cffunction>

        <cffunction name="consoleError" displayname="consoleError" hint="Displays an alert or error message to the console. Only for Firefox debugging" access="public" output="true" returntype="void">
                <cfargument name="method" displayName="method" type="string" hint="the name of the method generating the error" required="true" />

                <cfset jsonError = genError(arguments.method, "json")>

                <cfoutput>
                        <script type="text/javascript">
                                console.log(jsonError);
                        </script>
                </cfoutput>

                <cfreturn />
        </cffunction>

        <cffunction name="genAlert" displayname="genAlert" hint="Generates an alert struct and returns the object" access="private" output="false" returntype="any">
                <cfargument name="alertNum" displayName="alertNum" type="string" hint="the unique identifier" required="true" />
                <cfargument name="outFormat" displayname="outFormat" type="string" hint="The output format of the alert to return" require="false" default="xml">

                <cfstoredproc procedure="getAlert" datasource="#application.dsn#">
						<cfprocparam type="in" cfsqltype="cf_sql_integer" value="#arguments.alertNum#">
                        <cfprocresult name="alert">
                </cfstoredproc>

                <cfif arguments.outFormat EQ "xml">

                        <cfoutput query="alert">
                                <cfxml variable="strReturn" casesensitive = "no">
                                        <Alert>
                                                <alertNumber>#alert.alertNumber#</alertNumber>
                                                <alertMessage>#alert.message#</alertMessage>
                                                <alertMethod>#alert.method#</alertMethod>
                                                <alertSeverity>#alert.severity#</alertSeverity>
                                        </Alert>
                                </cfxml>
                        </cfoutput>

                <cfelse>

                        <cfsavecontent variable="strReturn">
                        <cfoutput query="alert">
                                ALERT{"number":"#alert.number#", "message":"#alert.message#", "method":"#alert.method#", "severity":"#alert.severity#"}
                        </cfoutput>
                        </cfsavecontent>

                </cfif>

                <cfreturn strReturn />

        </cffunction>

		<cffunction name="basicAlert" access="public" output="true" returntype="void">
			<cfargument name="message" type="string" required="true">

			<cflock scope="session" timeout="5" type="exclusive">
				<cfset session.message = arguments.message />
			</cflock>

			<cfoutput>
				<script type="text/javascript">
					$('##alert-div').dialog({ title: "ALERT !", autoOpen:true, modal: true });
				</script>
			</cfoutput>

		</cffunction>

		<cffunction name="createAudit" access="public" output="false" returntype="void">
			<cfargument name="auditEvent" type="string" required="true">

			<cfstoredproc procedure="dbo.createAudit" datasource="#Application.config.dsnMost#">
				<cfprocparam type="in" cfsqltype="cf_sql_varchar" value="#Application.config.smart_org_name#">
				<cfprocparam type="in" cfsqltype="cf_sql_varchar" value="#arguments.auditEvent#">
				<cfprocparam type="in" cfsqltype="cf_sql_varchar" value="#session.uid#">
			</cfstoredproc>
		</cffunction>

		<cffunction name="getAudits" access="remote" output="false" returnType="query">

			<cfstoredproc procedure="dbo.getAudits" datasource="#getDatasource()#">
				<cfprocparam type="in" cfsqltype="cf_sql_integer" value="#Application.config.smart_org_name#">
				<cfprocresult name="qryAudits">
			</cfstoredproc>

                <cfreturn qryAudits />
        </cffunction>

		<cffunction name="getError" access="public" output="false" returnType="struct">
			<cfargument name="developer_refer_name" type="string" required="true">

			<cfset var stcError = structNew() />

			<cfstoredproc procedure="common_local.dbo.usp_cf_error_messages_select" datasource="#getDatasource()#">
				<cfprocparam type="in" cfsqltype="cf_sql_varchar" value="#arguments.developer_refer_name#">
				<cfprocresult name="qError">
			</cfstoredproc>

			<cfset sctError["module"] = qError.dev_refer_module />
			<cfset sctError["component"] = qError.dev_refer_module />
			<cfset sctError["errNumber"] = qError.id />
			<cfset sctError["method"] = qError.method />
			<cfset sctError["message"] = qError.error_msg />

			<cfreturn sctError />
        </cffunction>

</cfcomponent>