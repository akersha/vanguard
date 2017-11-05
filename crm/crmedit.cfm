<cfif thisTag.ExecutionMode eq "Start">

<cfinclude template="../shared/_layout_top.cfm">
<cfmodule template="../shared/_header.cfm" controller="#attributes.pageObj.curModule#">

<cfset variables.objAdminSvc = createObject("component", "model.admin.service").init() />
<cfset variables.qContact = variables.objAdminSvc.getCRMForEdit( contactID: request.edit ) />

<section id="content">
  <div class="contact-leadspace-head">
	<!--- <span id="breadcrumbs"><cfinclude template="../shared/_breadcrumb.cfm"></span> --->
    <div class="content-wrap">
        <div class="container clearfix">
            <div class="page-intro">
                <h2>CRM Update</h2>
            </div><!-- #page-title end -->
        </div>
    </div>
  </div>
</section>
<p>&nbsp;</p>
<div class="container-fluid clearfix">
	<div class="row">
		<div class="col-md-8 col-md-offset-2">
			<cfoutput query="variables.qContact">
		 	<form method="POST">
			 	<input type="hidden" name="contactID" id="contactID" value="#request.edit#">
			  <div class="form-group">
			    <label for="curDate">Date:</label>
			    <input type="text" id="datepicker" name="curDate" value="#dateFormat(insertDate, 'mm/dd/yyyy')#">
			    <select name="hours" id="hours">
				    <cfloop from="1" to="12" index="hours">
					<cfoutput>
					<option value="#hours#" <cfif hour(insertDate) eq hours>selected="selected"</cfif>>#hours#</option>
					</cfoutput>
					</cfloop>
				</select>
			    <select name="minutes" id="minutes">
			    	<option value="00" <cfif minute(insertDate) eq 0>selected="selected"</cfif>>00</option>
			    	<option value="15" <cfif minute(insertDate) eq 15>selected="selected"</cfif>>15</option>
			    	<option value="30" <cfif minute(insertDate) eq 30>selected="selected"</cfif>>30</option>
			    	<option value="45" <cfif minute(insertDate) eq 45>selected="selected"</cfif>>45</option>
			    </select>
			    <select name="ampm" id="ampm">
			    	<option value="am" <cfif hour(insertDate) lt 12>selected="selected"</cfif>>am</option>
			    	<option value="pm" <cfif hour(insertDate) gte 12>selected="selected"</cfif>>pm</option>
			    </select>
			    <a href="javascript:void(0);"><button class="btn btn-warning"onClick="javascript:crm.backToDetail(#request.edit#)">Cancel</button></a>
			  </div>
			  <div class="form-group">
			    <label for="regarding">Regarding:</label>
			    <input type="text" class="form-control" id="regarding" name="regarding" value="#regarding#">
			  </div>
			  <div class="form-group">
			    <label for="company">Company:</label>
			    <input type="text" class="form-control" id="company" name="company" value="#company#">
			  </div>
			  <div class="form-group">
			    <label for="name">Name:</label>
			    <input type="text" class="form-control required" id="name" name="name" value="#contactName#">
			  </div>
			  <div class="form-group">
			    <label for="callTo">Call to:</label>
			    <select name="callTo" id="callTo" class="form-control required">
				    <option value="email" <cfif callTo eq "email">selected="selected"</cfif>>email</option>
					<option value="phone" <cfif callTo eq "phone">selected="selected"</cfif>>phone</option>
					<option value="in person" <cfif callTo eq "in person">selected="selected"</cfif>>in person</option>
				</select>
			  </div>
			  <div class="form-group">
			    <label for="phone">Phone:</label>
			    <input type="text" class="form-control required" id="phone" name="phone" value="#phone#">
			  </div>
			  <div class="form-group">
			    <label for="email">Email:</label>
			    <input type="text" class="form-control required" id="email" name="email" value="#email#">
			  </div>
			  <div class="form-group">
			    <label for="notes">Notes:</label><br />
			    <textarea id="notes" name="notes" class="form-control required">#notes#</textarea>
			  </div>
			  <div class="form-group">
			    <label for="duration">Duration:</label>
			    <input type="text" class="form-control required" id="duration" name="duration" placeholder="examples: 1h 15m 30s" value="#duration#">
			  </div>
			  <div class="form-group">
			    <label for="result">Result:</label>
			    <select name="result" id="result" class="form-control required">
					<option value="favorable" <cfif result eq "favorable">selected="selected"</cfif>>favorable</option>
					<option value="unfavorable" <cfif result eq "unfavorable">selected="selected"</cfif>>unfavorable</option>
				</select>
			  </div>
			  <button type="button" class="btn btn-default" id="crmUpdate" name="crmUpdate">Update</button>
			</form>
			</cfoutput>
		  </div>
	</div>
</div>

<!--- Success / fail div --->
<cfif structKeyExists(request, "updated")>
<div style="position: absolute; width: 320px; left: 50px; top: 30px; padding: 1.2em;" class="ui-widget ui-front ui-widget-content ui-corner-all ui-widget-shadow">
	<cfif request.updated eq 1>Contact updated !<cfelse>Update failed.</cfif>
</div>
</cfif>

<script type="text/javascript">
$('#datepicker').datepicker();
</script>
<script type="text/javascript" src="crm.js"></script>
<cfinclude template="../shared/_layout_bottom.cfm">

</cfif>