<cfif thisTag.ExecutionMode eq "Start">

<cfinclude template="../shared/_layout_top.cfm">
<cfmodule template="../shared/_header.cfm" controller="#attributes.pageObj.curModule#">
<!--- <cfmodule template="../shared/_breadcrumb.cfm" controller="#attributes.pageObj.curModule#"> --->

<section id="content">
  <div class="contact-leadspace-head">
    <div class="content-wrap">
        <div class="container clearfix">
            <div class="page-intro">
                <h2>CRM Authentication</h2>
            </div><!-- #page-title end -->
        </div>
    </div>
  </div>
</section>
<div class="content-wrap">
	<div class="container clearfix">
		 <form method="POST">
		  <div class="form-group">
		    <label for="email">Account:</label>
		    <input type="email" class="form-control" id="email" name="email">
		  </div>
		  <div class="form-group">
		    <label for="myPass">Password:</label>
		    <input type="password" class="form-control" id="myPass" name="myPass">
		  </div>
		  <button type="button" class="btn btn-default" id="authSubmit" name="authSubmit">Login</button>
		</form>
	</div>
</div>

<script type="text/javascript" src="auth.js"></script>
<cfinclude template="../shared/_layout_bottom.cfm">

</cfif>