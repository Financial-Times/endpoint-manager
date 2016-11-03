<!DOCTYPE html>
<html>
  	{{> _head }}
  	</head>
	<body>
		{{> _header }}
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
					<div class="o-forms-group">
						<label class="o-forms-label" for="base">Base URL</label>
						<small class="o-forms-additional-info">The base URL of the endpoint, not including protocol or __health and __about.</small>
						<input type="text" name="base" value="{{base}}" placeholder="my-app.webservices.ft.com" class="o-forms-text" id="base" required></input>
					</div>
					<div class="o-forms-wrapper o-forms-wrapper--highlight">
						<div class="o-forms-group {{#iderror}}o-forms--error{{/iderror}}">
							<label class="o-forms-label" for="id">ID</label>
							<small class="o-forms-additional-info">A unique identification for a endpoint with a SINGLE healthcheck or about (defaults to base URL). If you have mulitple healthchecks for an endpoint then you must define unique identifications for each one.</small>
							{{#id}}<small class="o-forms-additional-info">Can't be edited after creation.  If incorrect, create a new endpoint and delete the old one.</small>{{/id}}
							<input type="text" name="id" value="{{id}}" placeholder="{{base}}" default="{{base}}" class="o-forms-text" id="id" {{^iderror}}{{#id}}disabled{{/id}}{{/iderror}}></input>
							{{#iderror}}<div class="o-forms-errortext">{{iderror}}</div>{{/iderror}}
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
