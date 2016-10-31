<!DOCTYPE html>
<html>
  	<head>
		<meta charset="UTF-8">
		<title>Endpoint Manager</title>
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
			.o-forms-errortext {
				display: none;
			}
			.o-forms--error > .o-forms-errortext {
				display: block;
			}
			.o-forms-group {
				padding-left: 0;
			}
			#basic {
			  width: 100%; }
			#basic thead {
			  font-weight: bold;
			  font-size: larger; }
    	</style>
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
				<form id="new" action="/new" method="get">
					<input type='submit' class="o-buttons o-buttons--standout " value='Add New Endpoint' />
				</form>

				<h2>Existing Endpoints</h2>

				<form id="filter" action="/" method="get">
					<div class="o-forms-group">
						<div class="o-grid-container">
							<div class="o-grid-row">
								<div data-o-grid-colspan="3">
									<label class="o-forms-label" for="filter_url">URL</label>
									<input name="filter_url" value="{{filter_url}}" class="o-forms-text" id="filter_url"></input>
								</div>
								<div data-o-grid-colspan="3">
									<label class="o-forms-label" for="filter_systemCode">System Code</label>
									<input name="filter_systemCode" value="{{filter_systemCode}}" class="o-forms-text" id="filter_systemCode"></input>
								</div>
								<div data-o-grid-colspan="3">
									<label class="o-forms-label" for="filter_live">is Live?</label>
									<input name="filter_live" value="{{filter_live}}" class="o-forms-text" id="filter_live"></input>
								</div>
							</div>
						</div>
						<input type='submit' class="o-buttons o-buttons--standout " value='Filter (blanks show whole index) ' />
					</div>
				</form>

				<table id='basic'>
					<thead>
						<td><a href="/?sortby=dataItemID">url (click to sort)</a></td>
						<td><a href="/?sortby=SystemCode">systemCode (click to sort)</a></td>
						<td><a href="/?sortby=isLive">live (click to sort)</a></td>
					</thead>
					<tbody>
						{{#endpoints}}
						<tr>
							<td><a href="{{localpath}}">{{id}}</a></td>
							<td>{{systemCode}}</td>
							<td>{{isLive}}</td>
						</tr>
						{{/endpoints}}
					</tbody>
				</table>
				
			</div>
		</div>
		<script src="https://build.origami.ft.com/v2/bundles/js?modules=o-header-services@^1.0.0,o-buttons@^4.0.0,o-forms@^2.0.3,o-grid@^4.2.1"></script>
	</body>
</html>
