<!DOCTYPE html>
<html>
  	<head>
		<meta charset="UTF-8">
		<title>Endpoint Manager - {{dataItemID}}</title>
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
			.urltype {
				text-transform: capitalize;
			}
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
				Endpoint: {{dataItemID}}
				<h3>URLs</h3>
				{{#urls}}
					<div class='{{type}} url'><span class='urltype'>{{type}} URL:</span> <a href="{{url}}">{{url}}</a>{{#validateurl}} <a href="{{validateurl}}" class="o-buttons o-buttons--standout save-button" />Validate</a>{{/validateurl}}</div>
				{{/urls}}
			</div>
		</div>
		<script src="https://build.origami.ft.com/v2/bundles/js?modules=o-header-services@^1.0.0,o-buttons@^4.0.0,o-forms@^2.0.3,o-grid@^4.2.1"></script>
	</body>
</html>
