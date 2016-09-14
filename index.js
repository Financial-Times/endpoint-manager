var express = require('express');
var app = express();
var request = require("request");
var bodyParser = require('body-parser');
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));


var mustacheExpress = require('mustache-express');

// Register '.ms' extension with The Mustache Express
app.engine('ms', mustacheExpress());
app.set('view engine', 'ms');
app.set('views', __dirname + '/views');

var CMDB = require("cmdb.js");

/** Environment variables **/
var port = process.env.PORT || 3001;
var cmdb = new CMDB({
	api: process.env.CMDBAPI,
	apikey: process.env.APIKEY,
});

var path = require('path');
var ftwebservice = require('express-ftwebservice');
ftwebservice(app, {
	manifestPath: path.join(__dirname, 'package.json'),
	about: {
		"systemCode": "endpoint-manager",
		"name": "Endpoint Manager",
		"audience": "FT Technology",
		"serviceTier": "bronze",
	},

	// Also pass good to go.	If application is healthy enough to return it, then it can serve traffic.
	goodToGoTest: function() {
		return new Promise(function(resolve, reject) {
			resolve(true);
		});
	},

	// Check that track can talk to CMDB
	healthCheck: function() {
		return cmdb.getItem(null, 'endpoint', 'endpoint-manager.ft.com').then(function (result) {
			return false;
		}).catch(function (error) {
			return error.message;
		}).then(function (output) {
			 return [{
				id: 'cmdb-connection',
				name: "Connectivity to CMDB",
				ok: !output,
				severity: 1,
				businessImpact: "Can't manage health and about endpoints through the UI",
				technicalSummary: "App can't connect make a GET request to CMDB",
				panicGuide: "Check for alerts related to cmdb.ft.com.	Check connectivity to cmdb.ft.com",
				checkOutput: output,
				lastUpdated: new Date().toISOString(),
			}];
		});
	}
});

// Add authentication to everything which isn't one of the standard ftwebservice paths
var authS3O = require('s3o-middleware');
app.use(authS3O);

/**
 * Gets a list of Endpoints from the CMDB and renders them
 */
app.get('/', function (req, res) {
	cmdb.getAllItems(res.locals, 'endpoint').then(function (endpoints) {
		endpoints.sort(function (a,b){
			if (!a.dataItemID) return -1;
			if (!b.dataItemID) return 1;
			return a.dataItemID.toLowerCase() > b.dataItemID.toLowerCase() ? 1 : -1;
		});
		endpoints.forEach(function (endpoint) {
			endpoint.path = "/manage/"+encodeURIComponent(endpoint.dataItemID);
		});
		res.render('index', {endpoints: endpoints});
	}).catch(function (error) {
		res.status(502);
		res.render("error", {message: "Problem connecting to CMDB ("+error+")"});
	});
});


/**
 * Gets info about a given Contact from the CMDB and provides a form for editing it
 */
app.get('/manage/:endpointid', function (req, res) {
	cmdb.getItem(res.locals, 'endpoint', req.params.endpointid).then(function (endpoint) {
		res.render('endpoint', endpoint);
	}).catch(function (error) {
		res.status(502);
		res.render("error", {message: "Problem connecting to CMDB ("+error+")"});
	});
});


app.use(function(req, res, next) {
	res.status(404).render('error', {message:"Page not found."});
});

app.use(function(err, req, res, next) {
	console.error(err.stack);
	res.status(500);
	if (res.get('Content-Type') && res.get('Content-Type').indexOf("json") != -1) {
		res.send({error: "Sorry, an unknown error occurred."});
	} else {
		res.render('error', {message:"Sorry, an unknown error occurred."});
	}
});

app.listen(port, function () {
	console.log('App listening on port '+port);
});

