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
									<label class="o-forms__label" for="dataItemID">ID</label>
									<small class="o-forms__additional-info">Wildcards (* and ?) can be used.</small>
									<input name="dataItemID" value="{{dataItemID}}" class="o-forms__text" id="dataItemID"></input>
								</div>
								<div data-o-grid-colspan="3">
									<label class="o-forms__label" for="base">URL</label>
									<small class="o-forms__additional-info">Wildcards (* and ?) can be used.</small>
									<input name="base" value="{{base}}" class="o-forms__text" id="base"></input>
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
									<label class="o-forms__label" for="systemCode">System Code</label>
									<small class="o-forms__additional-info">Wildcards (* and ?) can be used.</small>
									<input name="systemCode..dataItemID" value="{{systemCode_dataItemID}}" class="o-forms__text" id="systemCode..dataItemID"></input>
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
									<a class="o-buttons o-buttons--standout" href="/">Clear</a>
								</div>
							</div>
						</div>
					</fieldset>
				</div>
			</form>

			<p/>

			<div class="o-grid-container">
				<div class="o-grid-row">
					<div data-o-grid-colspan="4">
						<h2>Existing Endpoints ({{endpoints.length}})</h2>
					</div>
					<div data-o-grid-colspan="4">
						<div class="o-buttons__pagination">
						{{#pages}}
							{{#faux}}...{{/faux}}
							{{^faux}}
								<a class="o-buttons" aria-selected="{{selected}}" href="?dataItemID={{dataItemID}}&amp;base={{base}}&amp;isLive={{isLive}}&amp;protocol={{protocol}}&amp;healthSuffix={{healthSuffix}}&amp;aboutSuffix={{aboutSuffix}}&amp;page={{number}}">{{number}}</a>
							{{/faux}}
						{{/pages}}
						</div>
					</div>
					<div data-o-grid-colspan="3">
						<form id="new" action="/new" method="get">
							<input type='submit' class="o-buttons o-buttons--standout o-buttons--big" value='Add New Endpoint' />
						</form>
					</div>
				</div>
			</div>

			<div class="o-grid-row">
				<div data-o-grid-colspan="12">
					<table class="o-table o-table--row-stripes" data-o-component="o-table">
						<thead>
							{{#endpoints.length}}
							<th>url</th>
							<th>systemCode</th>
							<th>live?</th>
							<th>protocol</th>
							<th>health</th>
							<th>about</th>
							{{/endpoints.length}}
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
							{{^endpoints}}
							<div id='emptylist'>Sorry, no records are available. Please adjust your filter</div>
							{{/endpoints}}
						</tbody>
					</table>
				</div>
			</div>

		</div>
		<script src="https://build.origami.ft.com/v2/bundles/js?modules=o-header-services@^1.0.0,o-buttons@^4.0.0,o-forms@^2.0.3,o-grid@^4.2.1"></script>
	</body>
</html>
