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
			.valid {
				background: green;
			}
			.invalid {
				background: red;
			}
			.upgrade {
				background: chocolate;
			}
			.url > .save-button {
				margin-left: 2em;
			}

			#saved {
				padding: 0;
				padding-bottom: 0.1em;
			}
			#saved .success {
				background-color: green;
				color: white;
				padding: 8px;
				border-radius: 5px 5px 0 0;
				font-weight: bold;
				font-size: large;
			}
			#saved aside > div {
				margin: 8px;
			}
			#saved aside[data-collapse=true] > div {
				display: none;
			}
			#saved aside > h3 {
				cursor: pointer;
				margin: 0.5em 3px;
			}
			#saved aside > h3:before {
				width: 1em;
				float: left;
				text-align: center;
			}
			#saved aside[data-collapse="true"] > h3:before {
				content: "+ ";
			}
			#saved aside[data-collapse="false"] > h3:before {
				content: "- ";
			}
			#saved aside pre {
				padding: 8px;
				border: groove;
				border-radius: 4px;
			}
  		</style>

  		<script type="text/javascript">
  			<!--

  				document.addEventListener("DOMContentLoaded", function() {
					var savedmessagetitle = document.querySelector('#saved h3');
					if (savedmessagetitle) savedmessagetitle.addEventListener('click', function () {
						savedmessagetitle.parentNode.dataset.collapse = savedmessagetitle.parentNode.dataset.collapse != "true";
					});

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

					var idinput = document.querySelector('#id');
					addChecks(idinput, idinput.parentNode);

					var protocolinput = document.querySelector('#protocol');

					function updateBaseURL() {
						var baseurl = (protocolinput.value == "both") ? "http" : protocolinput.value;
						baseurl += "://" + idinput.value + "/";
						var baseurlnodes = document.querySelectorAll(".baseurl"), i;
						for (i = 0; i < baseurlnodes.length; i++) {
							baseurlnodes[i].firstChild.nodeValue = baseurl;
						}
					}
					idinput.addEventListener('change', updateBaseURL);
					protocolinput.addEventListener('change', updateBaseURL);


					var urlnodes = document.querySelectorAll(".url"), i;
					for (i = 0; i < urlnodes.length; i++) {
						checkValidity(urlnodes[i]);
					}
					function checkValidity(urlnode) {
						fetch(urlnode.dataset.validateapi, {headers:{
							key: urlnode.dataset.apikey,
						}}).then(function (response) {
							return response.json();
						}).then(function (body) {
							var msg, classname;
							console.log(body);
							if (!body.isValid) {
								msg = "This is healthcheck is invalid";
								classname = "invalid";
							} else if(body.needsUpgrade) {
								msg = "This healthcheck is valid, but isn't up-to-date with the latest standard";
								classname = "upgrade";
							} else {
								msg = "This healthcheck is valid";
								classname = "valid";
							}
							var savebutton = urlnode.querySelector(".save-button");
							savebutton.firstChild.nodeValue = msg;
							savebutton.className += " " + classname;
						})
					}
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
						<p class='success'>Endpoint data saved succesfully</p>
						<aside data-collapse='true'>
							<h3>How can I automate this action?</h3>
							<div>
								<p>If you're using javascript, use the <a href="https://github.com/Financial-Times/cmdb.js">cmdb.js</a> library as follows:</p>
								<pre>cmdb.putItem({{locals}}, "endpoint", "{{endpointid}}", {{json}});</pre>
								<p>Alternatively, make a HTTP PUT request to <a href="{{url}}">{{url}}</a> with the following body:</p><pre>{{json}}</pre>
								<p>NB: both these methods will require an <a href="https://cmdb-key-manager-prod.herokuapp.com/">API Key</a></p>
							</div>

						</aside>
					</div>{{/saved}}
					<div class="o-forms-wrapper o-forms-wrapper--highlight">
						<div class="o-forms-group">
							<label class="o-forms-label" for="id">Base URL</label>
							<small class="o-forms-additional-info">The base URL of the endpoint, not including protocol or __health and __about</small>
							{{#id}}<small class="o-forms-additional-info">Can't be edited after creation.  If incorrect, create a new endpoint and delete the old one.</small>{{/id}}
							<input type="text" name="id" value="{{id}}" placeholder="my-app.webservices.ft.com" class="o-forms-text" id="id" required{{#id}} disabled{{/id}}></input>
						</div>
					</div>
					<div class="o-forms-group">
						<label class="o-forms-label" for="protocol">Protocol</label>
						<small class="o-forms-additional-info">Which protocol(s) the endpoint is served over</small>
						<select class="o-forms-select" id="protocol" name="protocol" data-bind="protocol">
							{{#protocollist}}<option value="{{value}}" {{#selected}}selected{{/selected}}>{{name}}</option>{{/protocollist}}
						</select>
					</div>

					<div class="o-forms-group">
						<label class="o-forms-label" for="healthSuffix">Healthcheck Suffix</label>
						<small class="o-forms-additional-info">The path of a healthcheck which meets our <a href="https://docs.google.com/document/d/18hefJjImF5IFp9WvPAm9Iq5_GmWzI9ahlKSzShpQl1s/edit">Healthcheck Standard</a></small>
						<div class="o-forms-affix-wrapper">
							<span class="o-forms-prefix baseurl">{{baseurl}}</span>
							<input name="healthSuffix" value="{{healthSuffix}}" default="__health" class="o-forms-text" id="healthSuffix"></input>
						</div>
					</div>
					<div class="o-forms-group">
						<label class="o-forms-label" for="aboutSuffix">About Suffix</label>
						<div class="o-forms-affix-wrapper">
							<span class="o-forms-prefix baseurl">{{baseurl}}</span>
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
				<ul>
					{{#urls}}
					<li class='{{type}} url' data-validateapi="{{validateapi}}" data-apikey="{{apikey}}"><span class='urltype'>{{type}} URL:</span> <a href="{{url}}">{{url}}</a>{{#validateurl}} <a href="{{validateurl}}" class="o-buttons o-buttons--standout save-button" />Check whether is Valid</a>{{/validateurl}}</li>
					{{/urls}}
				</ul>
				{{/id}}
			</div>
		</div>
		<script src="https://build.origami.ft.com/v2/bundles/js?modules=o-header-services@^1.0.0,o-buttons@^4.0.0,o-forms@^2.0.3,o-grid@^4.2.1"></script>
	</body>
</html>
