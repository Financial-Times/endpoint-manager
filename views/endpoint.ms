<!DOCTYPE html>
<html>
  	<head>
		<meta charset="UTF-8">
		<title>Endpoint Manager - {{id}}{{^id}}New Endpoint{{/id}}</title>
		<meta name=viewport content="width=device-width, initial-scale=1">
		<link rel="stylesheet" href="https://build.origami.ft.com/v2/bundles/css?modules=o-header-services@^1.0.0,o-buttons@^4.0.0,o-forms@^2.0.3,o-grid@^4.2.1">
		<style type="text/css">
		  	body {
				margin:0;
				font-family: Helvetica,arial,sans-serif;
				font-size: 16px;
			}
			#content {
				padding: 20px 0;
			}
			#save, #delete {
				margin: auto;
				padding: 0.5em 0;
				max-width: 400px;
				display: block;
				clear: both;
			}
			#save {
				padding-top: 3em;
			}
			#save input {
				width: 100%;
			}
			#delete input {
				background: #900;
				border-color: #900;
				float: right;
			}
			#saved {
			    transition: opacity 5s;
			}
			#saved.hide {
				opacity: 0;
			}
			label {
				display: block;
			}
			.o-forms-errortext {
				display: none;
			}
			.o-forms--error > .o-forms-errortext {
				display: block;
			}
			.urltype {
				text-transform: capitalize;
			}
			.link-all a{
				color: inherit;
				text-decoration: none;
				font-weight: bold;
				font-size: larger;
			}
			.link-all a:hover {
				text-decoration: underline;
			}
			.link-all {
				margin-bottom: 1em;
    			font-size: small;
			}
  		</style>

  		<script type="text/javascript">
  			<!--

  				document.addEventListener("DOMContentLoaded", function() {
					window.setTimeout(function () {
						var savedmessage = document.querySelector('#saved');
						if (savedmessage) {
							savedmessage.setAttribute("class", savedmessage.getAttribute("class")+" hide");
						}
					}, 5000);

					/**
					 * Check the validity of a field on page load and each time the field changes 
					 **/
					function addChecks(input, group) {
						function checkValidity() {
							if(!input.value) {
								group.setAttribute("class","o-forms-group");
							} else if(input.checkValidity()){
								group.setAttribute("class","o-forms-group o-forms--valid");
							} else {
								group.setAttribute("class","o-forms-group o-forms--error");
							}
						}
						input.addEventListener('change', checkValidity);
						checkValidity();
					}
					var systemcodeinput = document.querySelector('#systemCode');
					addChecks(systemcodeinput, systemcodeinput.parentNode);
  				});
  			-->
  		</script>
  	</head>
	<body>
		<header class='o-header-services' data-o-component='o-header-services'>
			<div class='o-header-services__top o-header-services__container'>
				<a href="/" class='o-header-services__ftlogo'></a>
				<div class='o-header-services__title'>
					<h1 class='o-header-services__product-name'>Endpoint Manager</h1>
					<span class='o-header-subrand__product-tagline'>Update healthcheck and about endpoints</span>
				</div>
			</div>
		</header>
		<div id='content' class="o-grid-container">
			<div class="o-grid-row" data-o-grid-colspan="9">

				<form action="{{localpath}}" method="post">
					<div class='link-all'><a href="/">&lt;- Back to All Endpoints</a></div>
					<h1>{{^id}}Add New{{/id}}{{#id}}Edit{{/id}} Endpoint</h1>
					{{#saved}}<div class="o-forms-message o-forms-message--highlight" id='saved'>
						<p>Endpoint data saved</p>
					</div>{{/saved}}
					<div class="o-forms-wrapper o-forms-wrapper--highlight">
						<div class="o-forms-group">
							<label class="o-forms-label" for="id">Base URL</label>
							<small class="o-forms-additional-info">The base URL of the endpoint, not including protocol or __health and __about</small>
							<input type="text" name="id" value="{{id}}" placeholder="my-app.webservices.ft.com" class="o-forms-text" id="id" required{{#id}} disabled{{/id}}></input>
						</div>
					</div>
					<div class="o-forms-group">
						<label class="o-forms-label" for="protocol">Protocol</label>
						<small class="o-forms-additional-info">Which protocol(s) the endpoint is served over</small>
						<select class="o-forms-select" id="position" name="protocol" data-bind="protocol">
							{{#protocollist}}<option value="{{value}}" {{#selected}}selected{{/selected}}>{{name}}</option>{{/protocollist}}
						</select>
					</div>

					<div class="o-forms-group">
						<label class="o-forms-label" for="healthSuffix">Healthcheck Suffix</label>
						<small class="o-forms-additional-info">The path of a healthcheck which meets our <a href="https://docs.google.com/document/d/18hefJjImF5IFp9WvPAm9Iq5_GmWzI9ahlKSzShpQl1s/edit">Healthcheck Standard</a></small>
						<div class="o-forms-affix-wrapper">
							<span class="o-forms-prefix">{{id}}/</span>
							<input name="healthSuffix" value="{{healthSuffix}}" default="__health" class="o-forms-text" id="healthSuffix"></input>
						</div>
					</div>
					<div class="o-forms-group">
						<label class="o-forms-label" for="aboutSuffix">About Suffix</label>
						<div class="o-forms-affix-wrapper">
							<span class="o-forms-prefix">{{id}}/</span>
							<input name="aboutSuffix" value="{{aboutSuffix}}" default="__about" class="o-forms-text" id="aboutSuffix"></input>
						</div>
					</div>

					<div class="o-forms-group">
						<input type="checkbox" class="o-forms-checkbox o-forms-checkbox--highlight" id="isLive" data-bind="acceptMarketingOptIn" {{#isLive}}checked{{/isLive}} name="isLive"></input>
						<label for="isLive" class="o-forms-label">Handles live traffic</label>
						<small class="o-forms-additional-info">Used for deciding whether Operations Team need to know about this endpoint.  <br />Non-production environments and production environments which aren't yet live should leave this box unchecked.</small>
					</div>


					<div class="o-forms-group">
						<label class="o-forms-label" for="systemCode">System Code</label>
						<small class="o-forms-additional-info">The system code of the system this endpoint serves</small>
						<input type="text" name="systemCode" class="o-forms-text" id="systemCode" pattern="^[a-z0-9\-]{3,32}$" value="{{systemCode}}"></input>
					<div class="o-forms-errortext">System Codes must consist of between 3 and 32 lowercase alphanumeric characters or hyphens.</div>
					</div>

					<div id="save"><input type='submit' class="o-buttons o-buttons--standout save-button" value='{{#id}}Save{{/id}}{{^id}}Create{{/id}}' /></div>
				</form>
				{{#id}}<form id="delete" action="{{localpath}}/delete" method="post">
					<input type='submit' class="o-buttons o-buttons--standout delete-button" value='Delete' />
				</form>
				<br/><hr/>
				<h2>Validate Endpoint URLs</h2>
				<small>(Press save to update)</small>
				<br/>
				{{#urls}}
					<div class='{{type}} url'><span class='urltype'>{{type}} URL:</span> <a href="{{url}}">{{url}}</a>{{#validateurl}} <a href="{{validateurl}}" class="o-buttons o-buttons--standout save-button" />Validate</a>{{/validateurl}}</div>
				{{/urls}}
				{{/id}}
			</div>
		</div>
		<script src="https://build.origami.ft.com/v2/bundles/js?modules=o-header-services@^1.0.0,o-buttons@^4.0.0,o-forms@^2.0.3,o-grid@^4.2.1"></script>
	</body>
</html>
