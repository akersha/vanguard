<cfif thisTag.ExecutionMode eq "Start">

<cfinclude template="../shared/_layout_top.cfm">
<cfmodule template="../shared/_header.cfm" controller="#attributes.pageObj.curModule#">
<!--- <cfmodule template="../shared/_breadcrumb.cfm" controller="#attributes.pageObj.curModule#"> --->

<section id="content">
  <div class="home-leadspace-head">
    <div class="content-wrap">
        <div class="container clearfix">
            <div class="page-intro">
				<h1 style="padding-left:25px;">Professionalism, integrity, security</h1>
                <h2>Security and investigations professionals</h2>
            </div>
        </div>
    </div>
	<!--- Charity feature will fade out left after 3 seconds --->
	<!--- <div class="charity-feature"><h2>Proud supporters of </h2><a href="http://www.vetscount.org"><img src="../images/veterans_count.png" border="0" alt="Veterans Count"></a></div> --->
    <div class="home-content-1">
        <div class="container clearfix">
            <h2 class="justify white">Vanguard Investigative Services, LLC. is located along the New Hampshire seacoast and serves the New England Area and beyond.<br>
			We are licensed investigators and security professionals with over 40 years of combined law enforcement experience.<br>
			Regardless of what variety of service you require it will be handled with the highest level of discretion. Your privacy matters to us!<br></h2>
        </div>
      </div>
  </div>
</section>

<div class="row">
	<div class="col-md-1"></div>
	<div class="col-md-6">
		<h3>Please feel free to contact us at the following address:</h3>
		<h4>VANGUARD Investigative Services LLC.<br />
		P.O. Box 461<br />
		Dover, NH 03821<br />
		603-767-0870<br />
		603-343-8076<br />
		<a href="mailto:waynebchr@vanguardshield.com">waynebchr@vanguardshield.com</a><br />
		<a href="mailto:rjrusso@vanguardshield.com">rjrusso@vanguardshield.com</a>
		</h4>
	</div>
</div>

<script type="text/javascript" src="home/home.js"></script>
<cfinclude template="../shared/_layout_bottom.cfm">

</cfif>