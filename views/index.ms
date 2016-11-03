<!DOCTYPE html>
<html>
  	{{> _head }}
	<body>
		{{> _header }}
		<div id='content' class="o-grid-container">
			<div class="o-grid-row" data-o-grid-colspan="9">
				<form id="new" action="/new" method="get">
					<input type='submit' class="o-buttons o-buttons--standout " value='Add New Endpoint' />
				</form>

				<h2>Existing Endpoints</h2>

				<form id="filter" action="/" method="get">
					<div class="o-forms-group">
						<div class="o-grid-container">
							<div class="o-grid-row">
								<div data-o-grid-colspan="3">
									<label class="o-forms__label" for="filter_url">URL</label>
									<input name="filter_url" value="{{filter_url}}" class="o-forms__text" id="filter_url"></input>
								</div>
								<div data-o-grid-colspan="3">
									<label class="o-forms__label" for="filter_systemCode">System Code</label>
									<input name="filter_systemCode" value="{{filter_systemCode}}" class="o-forms__text" id="filter_systemCode"></input>
								</div>
								<div data-o-grid-colspan="1">
									<label class="o-forms__label" for="filter_live">Live?</label>
									<input name="filter_live" value="{{filter_live}}" class="o-forms__text" id="filter_live"></input>
								</div>
								<div data-o-grid-colspan="2">
									<label class="o-forms__label" for="filter_protocol">Protocol</label>
									<input name="filter_protocol" value="{{filter_protocol}}" class="o-forms__text" id="filter_protocol"></input>
								</div>
								<div data-o-grid-colspan="3">
									<label class="o-forms__label" for="filter_health">Health</label>
									<input name="filter_health" value="{{filter_health}}" class="o-forms__text" id="filter_health"></input>
								</div>
								<div data-o-grid-colspan="3">
									<label class="o-forms__label" for="filter_about">About</label>
									<input name="filter_about" value="{{filter_about}}" class="o-forms__text" id="filter_about"></input>
								</div>
							</div>
						</div>
						<input type='submit' class="o-buttons o-buttons--standout " value='Filter (blanks show whole index) ' />
					</div>
				</form>

				<p/>

				<div class="o-grid-row">
					<div data-o-grid-colspan="9">
						<table class="o-table o-table--row-stripes" data-o-component="o-table">
							<thead>
								<td><a href="/?sortby=dataItemID">url</a></td>
								<td><a href="/?sortby=SystemCode">systemCode</a></td>
								<td><a href="/?sortby=isLive">is live?</a></td>
								<td><a href="/?sortby=protocol">protocol</a></td>
								<td><a href="/?sortby=health">health</a></td>
								<td><a href="/?sortby=about">about</a></td>
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
		</div>
		<script src="https://build.origami.ft.com/v2/bundles/js?modules=o-header-services@^1.0.0,o-buttons@^4.0.0,o-forms@^2.0.3,o-grid@^4.2.1"></script>
	</body>
</html>
