<cfif thisTag.ExecutionMode eq "Start">

<cfinclude template="../shared/_layout_top.cfm">
<cfmodule template="../shared/_header.cfm" controller="#attributes.pageObj.curModule#">
<!--- <cfmodule template="../shared/_breadcrumb.cfm" controller="#attributes.pageObj.curModule#"> --->

<section id="content">
  <div class="bio-leadspace-head">
    <div class="content-wrap">
        <div class="container clearfix">
            <div class="page-intro">
				<cfswitch expression="#request.id#">
					<cfcase value="boucher">
						<cfinclude template="boucherLeadIn.html">
					</cfcase>
					<cfcase value="russo">
						<cfinclude template="russoLeadIn.html">
					</cfcase>
					<cfcase value="connifey">
						<cfinclude template="connifeyLeadIn.html">
					</cfcase>
					<cfdefaultcase></cfdefaultcase>
				</cfswitch>
            </div><!-- #page-title end -->
        </div>
    </div>
      <div class="bio-content-1">
        <div class="container clearfix">
            <cfswitch expression="#request.id#">
				<cfcase value="boucher">
					<cfinclude template="boucher.html">
				</cfcase>
				<cfcase value="russo">
					<cfinclude template="russo.html">
				</cfcase>
				<cfcase value="connifey">
					<cfinclude template="connifey.html">
				</cfcase>
				<cfdefaultcase></cfdefaultcase>
			</cfswitch>
        </div>
      </div>
  </div>
</section><!--end section-->

<script type="text/javascript" src="bio/bio.js"></script>
<cfinclude template="../shared/_layout_bottom.cfm">

</cfif>