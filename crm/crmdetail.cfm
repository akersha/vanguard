<cfif thisTag.ExecutionMode eq "Start">

<cfinclude template="../shared/_layout_top.cfm">
<cfmodule template="../shared/_header.cfm" controller="#attributes.pageObj.curModule#">

<cfset variables.objAdminSvc = createObject("component", "model.admin.service").init() />
<cfset variables.xmlContact = variables.objAdminSvc.getCRMDetail(contactid: request.id) />

<cfset xmlDoc = xmlParse(variables.xmlContact, false) />

<section id="content">
  <div class="contact-leadspace-head">
	<!--- <span id="breadcrumbs"><cfinclude template="../shared/_breadcrumb.cfm"></span> --->
    <div class="content-wrap">
        <div class="container clearfix">
            <div class="page-intro">
                <h2>CRM Detail</h2>
            </div><!-- #page-title end -->
        </div>
    </div>
  </div>
</section>
<p>&nbsp;</p>
<div class="container-fluid clearfix">
	<div class="row">
		<div class="col-md-8 col-md-offset-2">
<cfloop index="intContact" from="1" to="#ArrayLen( xmlDoc.contacts.XmlChildren )#" step="1">
	<cfset contact = xmlDoc.contacts[ "contact" ][ intContact ] />

	<cfset id = contact.contactid.XmlText />
	<cfset date = contact.date.XmlText />
	<cfset regarding = contact.regarding.XmlText />
	<cfset company = contact.company.XmlText />
	<cfset contactname = contact.name.XmlText />
	<cfset callto = contact.callto.XmlText />
	<cfset phone = contact.phone.XmlText />
	<cfset email = contact.email.XmlText />
	<cfset duration = contact.duration.XmlText />
	<cfset result = contact.result.XmlText />
	<cfset notes = contact.notes.XmlText />

	<cfoutput>
	<div class="panel-group">
	  <div class="<cfif result eq 'favorable'>panel panel-success<cfelse>panel panel-danger</cfif>">
	  	<div class="panel-heading">Contact vCard<a href="/crm" title="Back"><i style="float:right" class="glyphicon glyphicon-circle-arrow-left"></i></a><a href="/crm/?edit=#id#" title="edit this vCard"><i style="float:right" class="glyphicon glyphicon-pencil"></i></a></div>
	    <div class="panel-body">
			 <div class="list-group">
			  <a href="javascript:void(0);" class="list-group-item">Date/Time: #dateFormat(date, "mm/dd/yyyy")# #timeFormat(date, "hh:mm:ss")#</a>
			  <a href="javascript:void(0);" class="list-group-item">Subject: #regarding#</a>
			  <a href="javascript:void(0);" class="list-group-item">Company: #company#</a>
			  <a href="javascript:void(0);" class="list-group-item">Contact: #contactname#</a>
			  <a href="javascript:void(0);" class="list-group-item">Phone: #phone#</a>
			  <a href="javascript:void(0);" class="list-group-item">Email: #email#</a>
			  <a href="javascript:void(0);" class="list-group-item">Duration: #duration#</a>
			  <a href="javascript:void(0);" class="list-group-item">Notes: #notes#</a>
			</div>
		</div>
	  </div>

	</div>
	</cfoutput>

</cfloop>

	</div>
  </div>
</div>

<script type="text/javascript" src="crm.js"></script>
<cfinclude template="../shared/_layout_bottom.cfm">

</cfif>