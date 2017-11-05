<cfif thisTag.ExecutionMode eq "Start">

<cfinclude template="../shared/_layout_top.cfm">
<cfmodule template="../shared/_header.cfm" controller="#attributes.pageObj.curModule#">
<!--- <cfmodule template="../shared/_breadcrumb.cfm" controller="#attributes.pageObj.curModule#"> --->

<section id="content">
  <div class="contact-leadspace-head">
    <div class="content-wrap">
        <div class="container clearfix">
            <div class="page-intro">
                <h1>Investigate, monitor, protect</h1>
                <h2>Your privacy is guaranteed.</h2>
            </div><!-- #page-title end -->
        </div>
    </div>
      <div class="contact-content-1">
        <div class="container clearfix">
            <h2 class="justify white">Vanguard Investigative Services is here to help. Please fill out the form completely and a representative will contact you within 24 hours.</h2>
        </div>
      </div>
  </div>
</section>
<div class="content-wrap">
	<div class="container clearfix">
		 <form method="POST">
			 <div class="form-group">
			    <label for="fullName">Name:</label>
			    <input type="text" class="form-control" id="fullName" name="fullName">
			  </div>
			  <div class="form-group">
			    <label for="email">Email address:</label>
			    <input type="email" class="form-control" id="email" name="email">
			  </div>
			  <div class="form-group">
			    <label for="phone">Phone:</label>
			    <input type="phone" class="form-control" id="phone">
			  </div>
				<div class="form-group">
			    <label for="comments">Comments:</label>
			    <textarea name="comments" class="form-control" id="comments"></textarea>
			  </div>
			  <button type="button" class="btn btn-default" id="contactSend">Submit</button>
			</form>
		</div>
	</div>

	<script type="text/javascript" src="contact.js"></script>
	<cfinclude template="../shared/_layout_bottom.cfm">

	</cfif>