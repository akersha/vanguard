<cfcomponent displayname="ServiceFactory" hint="base service used to generate application objects" output="false">
        <cfproperty name="majorVersion" type="string" required="no" default="1">
        <cfproperty name="minorVersion" type="string" required="no" default="0.0">

    <!--- Application configuration data --->
    <cfset variables.config = 0>

    <!--- Struct to hold all of our singletons --->
    <cfset variables.singletons = {}>

    <!--- Initialization --->
    <cffunction name="init" output="false">
        <cfargument name="config" type="struct" required="true">
        <cfset variables.config = arguments.config />
        <cfset createSingletons()>
        <cfreturn this />
    </cffunction>

        <!--- Private helper method to add singletons --->
        <cffunction name="addSingleton" output="false" access="private" returntype="void">
            <cfargument name="name" required="true">
            <cfargument name="object" required="true">

            <cfset variables.singletons[arguments.name] = arguments.object>
        </cffunction>

        <cffunction name="createSingletons" output="false" access="private" returntype="void">

            <cfset local = {}>

			<!--- Main application service --->
			<cfset local.WebApp = createObject("component","model.ApplicationService").init()>

			<!--- Page requests --->
            <cfset local.objRender = createObject("component","controller.PageController").init()>

            <!--- Error --->
            <cfset local.objErrorSvc = createObject("component","model.ErrorService").init()>

			<!--- Base Data Access Object --->
            <cfset local.objConfig = createObject("component","model.Config").init()>

			<!--- Employee --->
            <cfset local.objEmpSvc = createObject("component","model.EmployeeService").init()>
			<cfset local.objEmpDAO = createObject("component","model.Employee").init()>

			<!--- Application CRM Service and Data Object --->
			<cfset local.objAdminSvc = createObject("component","model.admin.service").init()>
			<cfset local.objAdmin = createObject("component","model.admin.dao").init()>

			<!--- Utility functions --->
			<cfset local.objFile = createObject("component","model.utils.File").init()>
			<!--- <cfset local.objCalc = createObject("component","model.utils.Calc").init()> --->

            <!--- Register the objects as available singletons --->
			<cfset addSingleton("WebApp",local.WebApp) />

			<cfset addSingleton("objRender",local.objRender) />

			<cfset addSingleton("objErrorSvc",local.objErrorSvc) />

			<cfset addSingleton("objConfig",local.objConfig) />

			<cfset addSingleton("objEmpSvc",local.objEmpSvc) />

			<cfset addSingleton("objEmpDAO",local.objEmpDAO) />

			<cfset addSingleton("objAdminSvc",local.objAdminSvc) />

			<cfset addSingleton("objAdmin",local.objAdmin) />

			<cfset addSingleton("objFile",local.objFile) />

			<!--- <cfset addSingleton("objFile",local.objCalc) /> --->

        </cffunction>

        <cffunction name="getSingleton" output="false">
            <cfargument name="name" required="true">
            <cfreturn variables.singletons[arguments.name]>
        </cffunction>

</cfcomponent>
