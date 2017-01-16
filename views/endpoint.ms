<!DOCTYPE html>
<html>
  	{{> _head }}
	<body>
		{{> _header }}
		<div id='content' class="o-grid-container">
			<div class="o-grid-row" data-o-grid-colspan="9">

				<form action="{{localpath}}" method="post">
					<div class='link-all'><a href="/"><i class="o-icons-icon o-icons-icon--arrow-left"></i>Back to All Endpoints</a></div>
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

					<div class="o-forms o-forms--wide {{#dependerror}}o-forms--error{{/dependerror}}">
						<label class="o-forms__label" for="base">Base URL</label>
						<small class="o-forms__additional-info">The base URL of the endpoint, not including protocol or __health and __about.</small>
						<input type="text" name="base" value="{{base}}" placeholder="my-app.webservices.ft.com" class="o-forms__text" id="base" required></input>
						{{#dependerror}}<div class="o-forms__errortext">{{dependerror}}</div>{{/dependerror}}
					</div>

					<div class="o-forms--wide o-forms__wrapper o-forms__wrapper--highlight">
						<div class="o-forms o-forms--wide {{#iderror}}o-forms--error{{/iderror}}">
							<label class="o-forms__label" for="id">ID</label>
							<small class="o-forms__additional-info">A unique identification for a endpoint with a SINGLE healthcheck or about (defaults to base URL). If you have mulitple healthchecks for an endpoint then you must define unique identifications for each one.</small>
							{{#id}}{{^iderror}}<small class="o-forms__additional-info">Can't be edited after creation.  If incorrect, create a new endpoint and delete the old one.</small>{{/iderror}}{{/id}}
							<input type="text" name="id" value="{{id}}" placeholder="{{base}}" default="{{base}}" class="o-forms__text" id="id" {{#id}}{{^iderror}}disabled{{/iderror}}{{/id}}></input>
							{{#iderror}}<div class="o-forms__errortext">{{iderror}}</div>{{/iderror}}
						</div>
					</div>

					<div class="o-forms o-forms--wide">
						<label class="o-forms__label" for="protocol">Protocol</label>
						<small class="o-forms__additional-info">Which protocol(s) the endpoint is served over</small>
						<select class="o-forms__select" id="protocol" name="protocol" data-bind="protocol">
							{{#protocollist}}<option value="{{value}}" {{#selected}}selected{{/selected}}>{{name}}</option>{{/protocollist}}
						</select>
					</div>

					<div class="o-forms o-forms--wide">
						<label class="o-forms__label" for="healthSuffix">Healthcheck Suffix</label>
						<small class="o-forms__additional-info">The path of a healthcheck which meets our <a href="https://docs.google.com/document/d/18hefJjImF5IFp9WvPAm9Iq5_GmWzI9ahlKSzShpQl1s/edit">Healthcheck Standard</a></small>
						<div class="o-forms__affix-wrapper">
							<span class="o-forms__prefix baseurl">{{baseurl}}</span>
							<input name="healthSuffix" value="{{healthSuffix}}" default="__health" class="o-forms__text" id="healthSuffix"></input>
						</div>
					</div>

					<div class="o-forms o-forms--wide">
						<label class="o-forms__label" for="aboutSuffix">About Suffix</label>
						<div class="o-forms__affix-wrapper">
							<span class="o-forms__prefix baseurl">{{baseurl}}</span>
							<input name="aboutSuffix" value="{{aboutSuffix}}" default="__about" class="o-forms__text" id="aboutSuffix"></input>
						</div>
					</div>

					<div class="o-forms o-forms--wide">
						<input type="checkbox" class="o-forms__checkbox o-forms__checkbox--highlight" id="isLive" data-bind="isLive" {{#isLive}}checked{{/isLive}} name="isLive"></input>
						<label for="isLive" class="o-forms__label">Handles live traffic</label>
						<small class="o-forms__additional-info">Used for deciding whether Operations Team need to know about this endpoint.  <br />Non-production environments and production environments which aren't yet live should leave this box unchecked.</small>
					</div>


					<div class="o-forms o-forms--wide">
						<label class="o-forms__label" for="systemCode">System Code</label>
						<small class="o-forms__additional-info">The system code of the system this endpoint serves</small>
						<input type="text" name="systemCode" class="o-forms__text" id="systemCode" pattern="^[a-z0-9\-]{3,32}$" value="{{systemCode}}"></input>
						<div class="o-forms__errortext">System Codes must consist of between 3 and 32 lowercase alphanumeric characters or hyphens.</div>
					</div>

					<div class="o-forms o-forms--wide">
						<label class="o-forms__label" for="programme">Related Items({{relationships.length}})</label>
						{{#relationships}}
						<div class="o-grid-container">
							<div class="o-grid-row">
								<div data-o-grid-colspan="3">
									{{reltype}}
								</div>
								<div data-o-grid-colspan="3">
									{{#relitemlink}}<a href="{{relitemlink}}">{{/relitemlink}}{{relitem}}{{#relitemlink}}</a>{{/relitemlink}}
								</div>
							</div>
						</div>
						{{/relationships}}
						{{^relationships}}<div class="empty">This endpoint is not being referenced</div>{{/relationships}}
					</div>

					{{#lastUpdate}}<div class="last-update">Endpoint Last Updated: {{lastUpdate}}</div>{{/lastUpdate}}

					<div id="save"><input type='submit' class="o-buttons o-buttons--standout save-button" value='{{#id}}Save{{/id}}{{^id}}Create{{/id}}' /></div>
				</form>
			</div>

			{{#id}}
			{{^relationships}}
			<div class='o-grid-row' data-o-grid-colspan="9">
				<div class='delete-notice-container'>
					<h2><i class="o-icons-icon o-icons-icon--warning o-icons--big"></i>Delete this record</h2>
					<p><strong>Warning:</strong> this action cannot be undone</p>
					<div>
				    		<form id="delete" action="{{localpath}}/delete" method="post">
							<input type='submit' class="o-buttons o-buttons--standout delete-button" value='Delete' />
				    		</form>
					</div>
			    	</div>
			</div>
			{{/relationships}}

			<div class='o-grid-row' data-o-grid-colspan="9">
				<br/><hr/>
				<h2>Validate Endpoint URLs</h2>
				<small>(Press save to update)</small>
				<br/>
				<ul>
				{{#urls}}
				<li class='{{type}} url' data-validateapi="{{validateapi}}" data-apikey="{{apikey}}"><span class='urltype'>{{type}} URL:</span> <a href="{{url}}">{{url}}</a>{{#validateurl}} <a href="{{validateurl}}" class="o-buttons o-buttons--standout save-button" />Check whether is Valid</a>{{/validateurl}}</li>
				{{/urls}}
				</ul>
			</div>
			{{/id}}

		</div>
		<script src="https://build.origami.ft.com/v2/bundles/js?modules=o-header-services@^1.0.0,o-buttons@^4.0.0,o-forms@^2.0.3,o-grid@^4.2.1"></script>
	</body>
</html>
