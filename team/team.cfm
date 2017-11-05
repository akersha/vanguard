<cfif thisTag.ExecutionMode eq "Start">

<cfinclude template="../shared/_layout_top.cfm">
<cfmodule template="../shared/_header.cfm" controller="#attributes.pageObj.curModule#">
<!--- <cfmodule template="../shared/_breadcrumb.cfm" controller="#attributes.pageObj.curModule#"> --->

<!--- <section id="page-title">
	<div class="container clearfix">
		<h1>VANGUARD Team</h1>
	</div>
</section> --->

<section id="content">
  <div class="team-leadspace-head">
    <div class="content-wrap">
        <div class="container clearfix">
            <div class="page-intro">
                <h1>Professionalism, integrity, privacy</h1>
                <h2>Our team is comprised of trained security and investigative professionals.</h2>
            </div><!-- #page-title end -->
        </div>
    </div>
      <div class="team-content-1">
        <div class="container clearfix">
            <h2 class="justify white">Corporate and event security, private investigations and security escorts are just some of the services our team provides. Professionals in the industry, our security and investigations team is ready to handle your requirements.</h2>
        </div>
      </div>
  </div>
</section><!--end section-->

  <div class="team-content-2">
    <div class="container clearfix">

        <h2 class="center">Senior Management</h2>

        <div class="col-md-6 leader-bio">
			<!--- <img class="img-rounded fleft" style="margin-right:20px;" title="" src="assets/img/team/9a.jpg"> --->
			<p><strong>Wayne D. Boucher, President</strong><br />Wayne was a police officer, detective and police prosecutor for over 17 years in the State of New Hampshire. During that time he earned accolades from both superiors and the citizenry that include a lifesaving award and a meritorious unit commendation.<br />
				<a href="https://www.linkedin.com/in/wayne-boucher-b243b083/" target="_blank"><img src="../images/linkedin-icon.png" height="24" width="24" border="0">Connect with me</a>
			</p>
			<a class="btn btn-default btn-sm pull-right" href="/bio?id=boucher">
			<button classs="btn btn-default">Read more ...</button>
			</a>
		</div>

        <div class="col-md-6 col_last leader-bio">
			<!--- <img class="img-rounded fleft" style="margin-right:20px;" title="" src="assets/img/team/8a.jpg"> --->
			<p><strong>Russ Russo, Director - Operations</strong><br />Russ has over 20 years of law enforcement experience with the City of Portsmouth New Hampshire Police Department. Russ has been trained in interview and interrogation techniques as well as investigations.<br />
				<a href="https://www.linkedin.com/in/rj-russo-902a2b2b/" target="_blank"><img src="../images/linkedin-icon.png" height="24" width="24" border="0">Connect with me</a>
			</p>
			<a class="btn btn-default btn-sm pull-right" href="/bio?id=russo">
			<button classs="btn btn-default">Read more ...</button>
			</a>
		</div>

        <div class="divider divider-short divider-center"></div>

        <h2 class="center">Security Profiles</h2>

        <div class="row">
            <div class="col-md-4 profile"><h4>Josh Hebert</h4><span>Security Agent</span>
                <span class="label label-primary">Event Security</span>
            </div>
            <div class="col-md-4 profile"><h4>Tim Connifey</h4><span>Security Consultant</span>
            	<span class="label label-primary">Executive Protection</span>
                <p>Tim Connifey is a senior security consultant at Vanguard. His focus is on the accounts in the greater Boston area. Connifey brings significant expertise as a security and logistics management expert with a deep understanding of travel and event security. He is a specialist in executive protection and crisis management.</p>
				<a class="btn btn-default btn-sm" href="/bio?id=connifey">
				<button classs="btn btn-default">Read more ...</button>
				</a>
            </div>
            <div class="col-md-4 profile"><h4>Troy Menard</h4><span>Security Agent</span>
                <span class="label label-primary">Event Security</span>
			</div>
        </div><!--end row-->


        <div class="clear"></div>

    </div><!-- container end -->

  </div>

<script type="text/javascript" src="home/home.js"></script>
<cfinclude template="../shared/_layout_bottom.cfm">

</cfif>