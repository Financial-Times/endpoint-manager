<!DOCTYPE html>
<html>
  	{{> _head }}
	<body>
		{{> _header }}
		<div id='content' class="o-grid-container">

			<form id="filter" action="/" method="get">
				<div class="o-forms-group">
					<fieldset>
						<legend class="o-forms__label" for="filter">Endpoint Filtering (enter one or more fields)</legend>
						<div class="o-grid-container">
							<div class="o-grid-row">
								<div data-o-grid-colspan="3">
									<label class="o-forms__label" for="dataItemID">URL</label>
									<small class="o-forms__additional-info">Please be exact.</small>
									<input name="dataItemID" value="{{dataItemID}}" class="o-forms__text" id="dataItemID"></input>
								</div>
								<div data-o-grid-colspan="3">
									<label class="o-forms__label" for="systemCode">System Code</label>
									<small class="o-forms__additional-info">Wildcards (* and ?) can be used.</small>
									<input name="systemCode" value="{{systemCode}}" class="o-forms__text" id="systemCode"></input>
								</div>
								<div data-o-grid-colspan="3">
									<label class="o-forms__label" for="isLive">Live?</label>
									<small class="o-forms__additional-info">Wildcards (* and ?) can be used.</small>
									<input name="isLive" value="{{isLive}}" class="o-forms__text" id="isLive"></input>
								</div>
								<div data-o-grid-colspan="3">
									<label class="o-forms__label" for="protocol">Protocol</label>
									<small class="o-forms__additional-info">Wildcards (* and ?) can be used.</small>
									<input name="protocol" value="{{protocol}}" class="o-forms__text" id="protocol"></input>
								</div>
								<div data-o-grid-colspan="3">
									<label class="o-forms__label" for="healthSuffix">Health</label>
									<small class="o-forms__additional-info">Wildcards (* and ?) can be used.</small>
									<input name="healthSuffix" value="{{healthSuffix}}" class="o-forms__text" id="healthSuffix"></input>
								</div>
								<div data-o-grid-colspan="3">
									<label class="o-forms__label" for="aboutSuffix">About</label>
									<small class="o-forms__additional-info">Wildcards (* and ?) can be used.</small>
									<input name="aboutSuffix" value="{{aboutSuffix}}" class="o-forms__text" id="aboutSuffix"></input>
								</div>
							</div>
							<div class="o-grid-row">
								<div data-o-grid-colspan="3">
									<input type='submit' class="o-buttons o-buttons--standout " value='Filter' />
								</div>
							</div>
						</div>
					</fieldset>
				</div>
			</form>

			<p/>

			<div class="o-grid-container">
				<div class="o-grid-row">
					<div data-o-grid-colspan="3">
						<h2>Existing Endpoints</h2>
					</div>
					<div data-o-grid-colspan="3">
					</div>
					<div data-o-grid-colspan="3">
						<form id="new" action="/new" method="get">
							<input type='submit' class="o-buttons o-buttons--standout o-buttons--big" value='Add New Endpoint' />
						</form>
					</div>
				</div>
			</div>

			<div class="o-grid-row">
				<div data-o-grid-colspan="9">
					<table class="o-table o-table--row-stripes" data-o-component="o-table">
						<thead>
							<th><a href="/?sortby=dataItemID">url</a></th>
							<th><a href="/?sortby=SystemCode">systemCode</a></th>
							<th><a href="/?sortby=isLive">live?</a></th>
							<th><a href="/?sortby=protocol">protocol</a></th>
							<th><a href="/?sortby=health">health</a></th>
							<th><a href="/?sortby=about">about</a></th>
						</thead>
						<tbody>
							{{#endpoints}}
								<tr>
									<td><a href="{{localpath}}">{{id}}</a></td>
									<td>{{systemCode}}</td>
									<td>{{isLive}}</td>
									<td>{{protocol}}</td>
									<td>{{healthSuffix}}</td>
									<td>{{aboutSuffix}}</td>
								</tr>
							{{/endpoints}}
						</tbody>
					</table>
				</div>
			</div>

		</div>
		<script src="https://build.origami.ft.com/v2/bundles/js?modules=o-header-services@^1.0.0,o-buttons@^4.0.0,o-forms@^2.0.3,o-grid@^4.2.1"></script>
	</body>
</html>
