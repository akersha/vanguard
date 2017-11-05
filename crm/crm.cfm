<cfif thisTag.ExecutionMode eq "Start">

<cfinclude template="../shared/_layout_top.cfm">
<cfmodule template="../shared/_header.cfm" controller="#attributes.pageObj.curModule#">

<section id="content">
  <div class="contact-leadspace-head">
	<span id="breadcrumbs"><cfinclude template="../shared/_breadcrumb.cfm"></span>
    <div class="content-wrap">
        <div class="container clearfix">
            <div class="page-intro">
                <h2>CRM Tracking</h2>
            </div><!-- #page-title end -->
        </div>
    </div>
  </div>
</section>
<p>&nbsp;</p>
<div class="container-fluid clearfix">
	<div class="row">
		<div id="tabs" class="col-md-8 col-md-offset-2">
		  <ul>
		    <li><a href="#tabs-1">New contact</a></li>
		    <li><a href="crmhistory.cfm">View History</a></li>
		    <li><a href="crmetrics.cfm">Metrics</a></li>
		  </ul>
		  <div id="tabs-1">
			 <form method="POST">
			  <div class="form-group">
			    <label for="curDate">Date:</label>
			    <input type="text" id="datepicker" name="curDate">
			    <select name="hours" id="hours">
				    <cfloop from="1" to="12" index="hours">
					<cfoutput>
					<option value="#hours#">#hours#</option>
					</cfoutput>
					</cfloop>
				</select>
			    <select name="minutes" id="minutes">
			    	<option value="00">00</option>
			    	<option value="15">15</option>
			    	<option value="30">30</option>
			    	<option value="45">45</option>
			    </select>
			    <select name="ampm" id="ampm">
			    	<option value="am">am</option>
			    	<option value="pm">pm</option>
			    </select>
			  </div>
			  <div class="form-group">
			    <label for="regarding">Regarding:</label>
			    <input type="text" class="form-control" id="regarding" name="regarding" value="">
			  </div>
			  <div class="form-group">
			    <label for="company">Company:</label>
			    <input type="text" class="form-control" id="company" name="company" value="">
			  </div>
			  <div class="form-group">
			    <label for="name">Name:</label>
			    <input type="text" class="form-control required" id="name" name="name" value="">
			  </div>
			  <div class="form-group">
			    <label for="callTo">Call to:</label>
			    <select name="callTo" id="callTo" class="form-control required">
					<option value="email">email</option>
					<option value="phone" selected="selected">phone</option>
					<option value="in person">in person</option>
				</select>
			  </div>
			  <div class="form-group">
			    <label for="phone">Phone:</label>
			    <input type="text" class="form-control required" id="phone" name="phone" value="">
			  </div>
			  <div class="form-group">
			    <label for="phone">Email:</label>
			    <input type="text" class="form-control required" id="email" name="email" value="">
			  </div>
			  <div class="form-group">
			    <label for="notes">Notes:</label><br />
			    <textarea id="notes" name="notes" class="form-control required"></textarea>
			  </div>
			  <div class="form-group">
			    <label for="duration">Duration:</label>
			    <input type="text" class="form-control required" id="duration" name="duration" placeholder="examples: 1h 15m 30s" value="">
			  </div>
			  <div class="form-group">
			    <label for="result">Result:</label>
			    <select name="result" id="result" class="form-control required">
					<option value="favorable" selected="selected">favorable</option>
					<option value="unfavorable">unfavorable</option>
				</select>
			  </div>
			  <button type="button" class="btn btn-default" id="crmSubmit" name="crmSubmit">Save</button>
			</form>
		  </div>
		  <div id="tabs-2"></div>
		  <div id="tabs-3"></div>
		</div>
	</div>
</div>

<!--- Success / fail div --->
<cfif structKeyExists(request, "inserted")>
<div style="position: absolute; width: 320px; left: 50px; top: 30px; padding: 1.2em;" class="ui-widget ui-front ui-widget-content ui-corner-all ui-widget-shadow">
	<cfif request.inserted eq 1>Contact inserted !<cfelse>Insert failed.</cfif>
</div>
</cfif>

<script type="text/javascript">
$('#datepicker').datepicker();
</script>
<script type="text/javascript" src="crm.js"></script>
<cfinclude template="../shared/_layout_bottom.cfm">

</cfif>