<cfcomponent displayname="Body" hint="All methods to create and control page level objects" output="false">

        <cffunction name="init" access="public" output="false" returntype="any">
			<cfreturn this />
        </cffunction>

        <cffunction name="render" displayname="Render" hint="retrieve content for rendering on page" access="remote" output="true" returntype="void">
			<cfargument name="controller" type="string" required="false" default="home">

                <cfswitch expression="#arguments.controller#">
					<cfdefaultcase>
						<cfset request.curModule = "Home" />
						<cfset variables.home = createObject("component", "controller.home").init() />
						<cfimport prefix="body" taglib="../home">
						<body:home pageObj="#variables.home#">
					</cfdefaultcase>

					<cfcase value="auth">
						<cfset request.curModule = "Authenticate" />
                        <cfset variables.auth = createObject("component", "controller.auth").init() />
						<cfimport prefix="body" taglib="../auth">
						<body:auth pageObj="#variables.auth#">
                    </cfcase>

					<cfcase value="contact">
						<cfset request.curModule = "Contact" />
                        <cfset variables.contact = createObject("component", "controller.contact").init() />
						<cfimport prefix="body" taglib="../contact">
						<body:contact pageObj="#variables.contact#">
                    </cfcase>

					<cfcase value="crm">
						<cfif not structKeyExists(session, "curUser")><cflocation url="/denied" addtoken="no"></cfif>
						<cfset request.curModule = "CRM" />
                        <cfset variables.crm = createObject("component", "controller.crm").init() />
						<cfimport prefix="body" taglib="../crm">
						<body:crm pageObj="#variables.crm#">
                    </cfcase>

					<cfcase value="crm.detail">
						<cfif not structKeyExists(session, "curUser")><cflocation url="/denied" addtoken="no"></cfif>
						<cfset request.curModule = "CRM" />
                        <cfset variables.detail = createObject("component", "controller.crm").init() />
						<cfimport prefix="body" taglib="../crm">
						<body:crmdetail pageObj="#variables.detail#">
                    </cfcase>

					<cfcase value="crm.update">
						<cfif not structKeyExists(session, "curUser")><cflocation url="/denied" addtoken="no"></cfif>
						<cfset request.curModule = "CRM" />
                        <cfset variables.crm = createObject("component", "controller.crm").init() />
						<cfimport prefix="body" taglib="../crm">
						<body:crmedit pageObj="#variables.crm#">
                    </cfcase>

					<cfcase value="services">
						<cfset request.curModule = "Services" />
                        <cfset variables.services = createObject("component", "controller.services").init() />
						<cfimport prefix="body" taglib="../services">
						<body:services pageObj="#variables.services#">
                    </cfcase>

					<cfcase value="team">
						<cfset request.curModule = "Team" />
                        <cfset variables.team = createObject("component", "controller.team").init() />
						<cfimport prefix="body" taglib="../team">
						<body:team pageObj="#variables.team#">
                    </cfcase>

					<cfcase value="bio">
						<cfset request.curModule = "Bio" />
                        <cfset variables.bio = createObject("component", "controller.bio").init() />
						<cfimport prefix="body" taglib="../bio">
						<body:bio pageObj="#variables.bio#">
                    </cfcase>

					<cfcase value="testimonials">
						<cfset request.curModule = "Testimonials" />
                        <cfset variables.testimonials = createObject("component", "controller.testimonials").init() />
						<cfimport prefix="body" taglib="../testimonials">
						<body:testimonials pageObj="#variables.testimonials#">
                    </cfcase>

					<cfcase value="denied">
						<cfset request.curModule = "Denied" />
                        <cfset variables.denied = createObject("component", "controller.auth").init() />
						<cfimport prefix="body" taglib="../denied">
						<body:denied pageObj="#variables.denied#">
                    </cfcase>

                </cfswitch>

                <cfreturn />
        </cffunction>

		<cffunction name="tableData" displayname="tableData" access="remote" output="true" returntype="string" returnformat="plain" hint="retrieves a dataset to output as HTML">
			<cfswitch expression="#request.vw#">
				<cfdefaultcase>No data to display</cfdefaultcase>
				<cfcase value="table.disposition">
					<cfset local.objService = createObject("component", "vision.model.dispositionservice").init() />
					<cfset local.data = local.objService.getDetail(
						pid_list: arguments.pid_list,
						initiative: arguments.initiative,
						sponsor: arguments.sponsor,
						disposition: arguments.disposition
					) />

					<cfset local.strHTML = tableBuilder(local.data) />
				</cfcase>
			</cfswitch>

			<cfreturn local.strHTML />
		</cffunction>

		<cffunction name="xmlData" displayname="xmlData" access="remote" output="true" returntype="string" returnformat="plain" hint="retrieves a dataset to output as XML">
			<cfswitch expression="#request.vw#">
				<cfdefaultcase>No data to display</cfdefaultcase>
				<cfcase value="xml.status">
					<cfset local.objService = createObject("component", "vision.model.statusservice").init() />
					<cfset local.data = local.objService.getStatusSummary() />

					<cfset local.strXML = local.objService.getXml(
						dataset: local.data,
						caption: "Projects with a yellow or red status"
					) />
				</cfcase>
			</cfswitch>

			<cfreturn local.strXML />
		</cffunction>

		<cffunction name="tableBuilder" displayname="tableBuilder" hint="prep dataset for tablefilter view" access="remote" output="false" returntype="string" returnformat="plain">
			<cfargument name="dataset" type="query" required="true">

			<cfset objFormat = createObject("component", "vision.model.utils.format") />

			<cfsavecontent variable="local.strHTML">
			<div class="table-responsive">
			<table class="table table-bordered table-condensed">
				<thead>
				<cfoutput>
					<cfloop list="#arguments.dataset.columnList#" index="col">
						<!--- Any exclusion here must also be made in the switch below --->
						<cfswitch expression="#col#">
							<cfdefaultcase><th>#objFormat.capname(col)#</th></cfdefaultcase>
							<cfcase value="PRISM ID"><th>#col#</th></cfcase>
							<cfcase value="si_owner_uid,sponsor_officer_uid"></cfcase>
						</cfswitch>
					</cfloop>
				</cfoutput>

				</thead>
				<tbody>
				<cfoutput query="arguments.dataset">
				<tr style="background-color:<cfif currentrow MOD 2 EQ 1>##fff<cfelse>##F7F7F7</cfif>;">
				<!--- Conditionals for styling the TD --->
				<cfloop list="#columnList#" index="col">
				<cftry>
					<cfswitch expression = "#col#">
						<cfdefaultcase><td>#arguments.dataset[col][currentrow]#</td></cfdefaultcase>
						<cfcase value = "kintana"><td><a href="http://myprism.cingular.net/ittools/project/resources/cfm/projectView.cfm?activeTab=project&kintana=#arguments.dataset[col][currentrow]#">#arguments.dataset[col][currentrow]#</a></td></cfcase>
						<cfcase value = "prism_id, PRISM ID"><td><a href="http://myprism.cingular.net/ittools/project/resources/cfm/projectView.cfm?activeTab=project&kintana=#arguments.dataset[col][currentrow]#">#arguments.dataset[col][currentrow]#</a></td></cfcase>
						<cfcase value = "PRISM ID"><td><a href="http://myprism.cingular.net/ittools/project/resources/cfm/projectView.cfm?activeTab=project&kintana=#arguments.dataset[col][currentrow]#">#arguments.dataset[col][currentrow]#</a></td></cfcase>
						<cfcase value = "cr_id"><td><a href="http://intranet.att.com/oneattcr/crSummary.cfm?crid=#arguments.dataset[col][currentrow]#">#arguments.dataset[col][currentrow]#</a></td></cfcase>
						<cfcase value = "si_owner_name,sponsoring_officer_name,sponsor_officer_name,sponsor"><td>#objFormat.capname(arguments.dataset[col][currentrow])#</td></cfcase>
						<cfcase value="requested_release_date_1,requested_release_date_2,commit_release_date"><td>#dateFormat(arguments.dataset[col][currentrow], "yymm")#</td></cfcase>
						<cfcase value="total_mde,budget_totals,vp_mde,dde_1,dde_2"><td>#numberFormat(arguments.dataset[col][currentrow], "$999,999,999.99")#</td></cfcase>
						<cfcase value="SI Owner"><td>#objFormat.capname(arguments.dataset[col][currentrow])#</td></cfcase>
						<cfcase value="si_owner_uid,sponsor_officer_uid"></cfcase>
					</cfswitch>
					<cfcatch type="any">&nbsp;</cfcatch>
				</cftry>
				</cfloop>
				</tr>
				</cfoutput>
				</tbody>
			</table>
			</div>
			</cfsavecontent>

			<cfreturn local.strHTML />

		</cffunction>

		<cffunction name="exportContent" displayname="exportContent" hint="prep dataset for export to XLS" access="remote" output="true" returntype="void">
			<cfargument name="fa" displayName="fa" type="string" hint="current page context" required="true" />
			<cfargument name="view" displayName="column view" type="string" hint="which columns to output" required="false" default=1 />
			<cfargument name="rdt" displayName="release date" type="string" required="false" default=9999 />
			<cfargument name="phase" displayName="funding phase" type="string" required="false" default=0 />
			<cfargument name="health" displayName="health" type="string" required="false" default="nnnn" />

			  <cfparam name="request.evt" default="export" />
			  <cfif structKeyExists(request, "view")>
				<cfset arguments.view = request.view />
			</cfif>

			  <cfset objCalc = createObject("component", "entgroup.model.utils.calc").init() />

				<cfswitch expression="#arguments.fa#">
					<cfdefaultcase>Unknown export parameter</cfdefaultcase>

					<cfcase value="export.listview">
						<cfset setViewPath("../widgets/admin/listview-xls.cfm") />
                        <cfmodule template="#getViewPath()#">
					   <!--- <cfinclude template="../widgets/admin/listview-xls.cfm"> --->
					</cfcase>

					<cfcase value="export.fundstat">
					   <cfset request.curModule = "Home" />

						<cfif not structKeyExists(request,"dataset")>
							<cfset objData = createobject("component", "entgroup.model.HomeDao").init() />
							<cfset request.dataset = objData.getFundStatDetail( portfolioID: arguments.portfolioID, phase: arguments.phase, view: arguments.view ) />
						</cfif>

						<cfif arguments.view eq 1>
							<cfset variables.columnList = 'phase,portfolio_name,kintana,project_name,requested_release_date_1,requested_release_date_2,commit_release_date,tower_vp,program_manager,lpm,apm,total_mde,budget_totals,health_status,eta_to_resolve_date' />
							<cfset variables.columnOverride = 'Phase,Portfolio,Project ID,Project,Requested Release 1,Requested Release 2,Commit Date,Tower VP,Program Manager,LPM,APM,Total MDE,Budget Totals,Health Status,ETA to Resolution' />
						<cfelse>
							<cfset variables.columnList = 'phase,portfolio_name,kintana,project_name,requested_release_date_1,requested_release_date_2,commit_release_date,tower_vp,program_manager,lpm,apm,total_mde,budget_totals,health_status,eta_to_resolve_date,clarity_id,carryover,comments,dark_deploy_date,dde_1,dde_2,funding_type,health,hom,incubator,in_program_name,launch_live_date,m9_deploy_date,parent_pid,ptype,roadmap_team,status_name,vp_mde,one_n,areas' />
							<cfset variables.columnOverride = 'Phase,Portfolio,Project ID,Project,Requested Release 1,Requested Release 2,Commit Date,Tower VP,Program Manager,LPM,APM,Total MDE,Budget Totals,Health Status,ETA to Resolution,Clarity ID,Carryover,Comments,Dark Deploy Date,DDE 1,DDE 2,Funding Type,Health,HOM,Incubator,In Program Name,Launch Live Date,M9 Deploy Date,Parent PID,Ptype,Roadmap Team,Status,VP MDE,1-N,Areas' />
						</cfif>

						<cfset download = objCalc.createXlsDownload(
							exportQuery: request.dataset,
							columnList: variables.columnList,
							columnOverride: variables.columnOverride,
							fileName: 'EntGroup_Fundstat_export_#dateformat(Now(), "yyyymmdd")#.xls'
						) />
					</cfcase>

					<cfcase value="export.projrel">
					   <cfset request.curModule = "Home" />

						<cfif not structKeyExists(request,"dataset")>
							<cfset objData = createobject("component", "entgroup.model.HomeDao").init() />
							<cfset request.dataset = objData.getProjrelDetail( portfolioID: arguments.portfolioID, rdt: arguments.rdt, view: arguments.view ) />
						</cfif>

						<cfif arguments.view eq 1>
							<cfset variables.columnList = 'phase,portfolio_name,kintana,project_name,requested_release_date_1,requested_release_date_2,commit_release_date,tower_vp,program_manager,lpm,apm,total_mde,budget_totals,health_status,eta_to_resolve_date' />
							<cfset variables.columnOverride = 'Phase,Portfolio,Project ID,Project,Requested Release 1,Requested Release 2,Commit Date,Tower VP,Program Manager,LPM,APM,Total MDE,Budget Totals,Health Status,ETA to Resolution' />
						<cfelse>
							<cfset variables.columnList = 'phase,portfolio_name,kintana,project_name,requested_release_date_1,requested_release_date_2,commit_release_date,tower_vp,program_manager,lpm,apm,total_mde,budget_totals,health_status,eta_to_resolve_date,clarity_id,carryover,comments,dark_deploy_date,dde_1,dde_2,funding_type,health,hom,incubator,in_program_name,launch_live_date,m9_deploy_date,parent_pid,ptype,roadmap_team,status_name,vp_mde,one_n,areas' />
							<cfset variables.columnOverride = 'Phase,Portfolio,Project ID,Project,Requested Release 1,Requested Release 2,Commit Date,Tower VP,Program Manager,LPM,APM,Total MDE,Budget Totals,Health Status,ETA to Resolution,Clarity ID,Carryover,Comments,Dark Deploy Date,DDE 1,DDE 2,Funding Type,Health,HOM,Incubator,In Program Name,Launch Live Date,M9 Deploy Date,Parent PID,Ptype,Roadmap Team,Status,VP MDE,1-N,Areas' />
						</cfif>

						<cfset download = objCalc.createXlsDownload(
							exportQuery: request.dataset,
							columnList: variables.columnList,
							columnOverride: variables.columnOverride,
							fileName: 'EntGroup_Projrel_export_#dateformat(Now(), "yyyymmdd")#.xls'
						) />
					</cfcase>

					<cfcase value="export.budgrel">
					   <cfset request.curModule = "Home" />

						<cfif not structKeyExists(request,"dataset")>
							<cfset objData = createobject("component", "entgroup.model.HomeDao").init() />
							<cfset request.dataset = objData.getBudgrelDetail( portfolioID: arguments.portfolioID, rdt: arguments.rdt, view: arguments.view ) />
						</cfif>

						<cfif arguments.view eq 1>
							<cfset variables.columnList = 'phase,portfolio_name,kintana,project_name,requested_release_date_1,requested_release_date_2,commit_release_date,tower_vp,program_manager,lpm,apm,total_mde,budget_totals,health_status,eta_to_resolve_date' />
							<cfset variables.columnOverride = 'Phase,Portfolio,Project ID,Project,Requested Release 1,Requested Release 2,Commit Date,Tower VP,Program Manager,LPM,APM,Total MDE,Budget Totals,Health Status,ETA to Resolution' />
						<cfelse>
							<cfset variables.columnList = 'phase,portfolio_name,kintana,project_name,requested_release_date_1,requested_release_date_2,commit_release_date,tower_vp,program_manager,lpm,apm,total_mde,budget_totals,health_status,eta_to_resolve_date,clarity_id,carryover,comments,dark_deploy_date,dde_1,dde_2,funding_type,health,hom,incubator,in_program_name,launch_live_date,m9_deploy_date,parent_pid,ptype,roadmap_team,status_name,vp_mde,one_n,areas' />
							<cfset variables.columnOverride = 'Phase,Portfolio,Project ID,Project,Requested Release 1,Requested Release 2,Commit Date,Tower VP,Program Manager,LPM,APM,Total MDE,Budget Totals,Health Status,ETA to Resolution,Clarity ID,Carryover,Comments,Dark Deploy Date,DDE 1,DDE 2,Funding Type,Health,HOM,Incubator,In Program Name,Launch Live Date,M9 Deploy Date,Parent PID,Ptype,Roadmap Team,Status,VP MDE,1-N,Areas' />
						</cfif>

						<cfset download = objCalc.createXlsDownload(
							exportQuery: request.dataset,
							columnList: variables.columnList,
							columnOverride: variables.columnOverride,
							fileName: 'EntGroup_Budg_export_#dateformat(Now(), "yyyymmdd")#.xls'
						) />
					</cfcase>

					<cfcase value="export.jeop">
					   <cfset request.curModule = "Home" />

						<cfif not structKeyExists(request,"dataset")>
							<cfset objData = createobject("component", "entgroup.model.HomeDao").init() />
							<cfset request.dataset = objData.getJeopDetail( portfolioID: arguments.portfolioID, health: arguments.health, view: arguments.view ) />
						</cfif>

						<cfif arguments.view eq 1>
							<cfset variables.columnList = 'phase,portfolio_name,kintana,project_name,requested_release_date_1,requested_release_date_2,commit_release_date,tower_vp,program_manager,lpm,apm,total_mde,budget_totals,health_status,eta_to_resolve_date' />
							<cfset variables.columnOverride = 'Phase,Portfolio,Project ID,Project,Requested Release 1,Requested Release 2,Commit Date,Tower VP,Program Manager,LPM,APM,Total MDE,Budget Totals,Health Status,ETA to Resolution' />
						<cfelse>
							<cfset variables.columnList = 'phase,portfolio_name,kintana,project_name,requested_release_date_1,requested_release_date_2,commit_release_date,tower_vp,program_manager,lpm,apm,total_mde,budget_totals,health_status,eta_to_resolve_date,clarity_id,carryover,comments,dark_deploy_date,dde_1,dde_2,funding_type,health,hom,incubator,in_program_name,launch_live_date,m9_deploy_date,parent_pid,ptype,roadmap_team,status_name,vp_mde,one_n,areas' />
							<cfset variables.columnOverride = 'Phase,Portfolio,Project ID,Project,Requested Release 1,Requested Release 2,Commit Date,Tower VP,Program Manager,LPM,APM,Total MDE,Budget Totals,Health Status,ETA to Resolution,Clarity ID,Carryover,Comments,Dark Deploy Date,DDE 1,DDE 2,Funding Type,Health,HOM,Incubator,In Program Name,Launch Live Date,M9 Deploy Date,Parent PID,Ptype,Roadmap Team,Status,VP MDE,1-N,Areas' />
						</cfif>

						<cfset download = objCalc.createXlsDownload(
							exportQuery: request.dataset,
							columnList: variables.columnList,
							columnOverride: variables.columnOverride,
							fileName: 'EntGroup_Jeop_export_#dateformat(Now(), "yyyymmdd")#.xls'
						) />
					</cfcase>

                </cfswitch>


		</cffunction>

</cfcomponent>
