var express = require('express');
var app = express();
var request = require("request");
var bodyParser = require('body-parser');
const querystring = require('querystring');
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));


var mustacheExpress = require('mustache-express');

// Register '.ms' extension with The Mustache Express
app.engine('ms', mustacheExpress());
app.set('view engine', 'ms');
app.set('views', __dirname + '/views');

// Set the public directory as public for serving assets
app.use(express.static('public'));

var CMDB = require("cmdb.js");

/** Environment variables **/
var port = process.env.PORT || 3001;
var health_api = process.env.HEALTH_API || "http://healthcheck.ft.com/";
if (health_api.slice(-1) != '/') health_api += '/';
var health_apikey = process.env.HEALTH_APIKEY || "";
var cmdb = new CMDB({
	api: process.env.CMDB_API,
	apikey: process.env.CMDB_APIKEY,
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
	endpointsurl = process.env.CMDB_API + "items/endpoint";
	params = req.query;
	console.log("params:",params);
	params['outputfields'] = "name,serviceTier,isLive,protocol,healthSuffix,aboutSuffix";
	params['objectDetail'] = "False";
	params['subjectDetail'] = "False";
	remove_blank_values(params);
	endpointsurl = endpointsurl + '?' +querystring.stringify(params);
	console.log("url:",endpointsurl)
	cmdb._fetchAll(res.locals, endpointsurl).then(function (endpoints) {
		if (req.query.sortby) { console.log(req.query.sortby) } // check how sort param is provided
		endpoints.sort(CompareOnKey(req.query.sortby));
		endpoints.forEach(endpointController);
		res.render('index', {endpoints: endpoints});
	}).catch(function (error) {
		res.status(502);
		res.render("error", {message: "Problem obtaining list of endpoints from CMDB ("+error+")"});
	});
});


function CompareOnKey(key) {
	return function(a,b) {
		if (!key) {  // default to url sort
			key = 'dataItemID';
		}
		avalue = a[key];
		bvalue = b[key];
		if (!avalue) return -1;
		if (!bvalue) return 1;
		return avalue.toLowerCase() > bvalue.toLowerCase() ? 1 : -1;
	};
}

/**
 * Gets info about a given Contact from the CMDB and provides a form for editing it
 */
app.get('/manage/:endpointid', function (req, res) {
	cmdb.getItem(res.locals, 'endpoint', req.params.endpointid).then(function (endpoint) {
		res.render('endpoint', endpointController(endpoint));
	}).catch(function (error) {
		res.status(502);
		res.render("error", {message: "Problem obtaining details for "+req.params.endpointid+" from CMDB ("+error+")"});
	});
});

/**
 * Updates an Endpoint
 */
app.post('/manage/:endpointid', function (req, res) {
	var endpoint = {
		base: req.body.base,
		protocol: req.body.protocol,
		healthSuffix: req.body.healthSuffix,
		aboutSuffix: req.body.aboutSuffix,
		isLive: !!req.body.isLive,
	}
	if (req.body.systemCode) endpoint.isHealthcheckFor = {system: [{'dataItemID':req.body.systemCode}]};
	cmdb.putItem(res.locals, 'endpoint', req.params.endpointid, endpoint).then(function (result) {
		result.saved = {
			locals: JSON.stringify(res.locals),
			endpointid: req.params.endpointid,

			// TODO: replace with pretty print function
			json: JSON.stringify(endpoint).replace(/,/g, ",\n\t").replace(/}/g, "\n}").replace(/{/g, "{\n\t"),
			
			// TODO: get actual url from cmdb.js
			url: 'https://cmdb.ft.com/v2/items/endpoint/'+encodeURIComponent(encodeURIComponent(req.params.endpointid)),
		}
		res.render('endpoint', endpointController(result));
	}).catch(function (error) {
		res.status(502);
		res.render("error", {message: "Problem posting details for "+req.params.endpointid+" to CMDB ("+error+")"});
	});
});

/**
 * Deletes an Endpoint
 */
app.post('/manage/:endpointid/delete', function (req, res) {
	cmdb.deleteItem(res.locals, 'endpoint', req.params.endpointid).then(function (endpoint) {

		// TODO: show messaging to indicate the delete was successful
		res.redirect(303, '/');
	}).catch(function (error) {
		res.status(502);
		res.render("error", {message: "Problem deleting "+req.params.endpointid+" from CMDB ("+error+")"});
	});
});

/**
 * Displays blank endpoint form for adding new endpoints
 */
app.get('/new', function (req, res) {
	var defaultdata = {
		base: "",
		endpointid: "",
		healthSuffix: "__health",
		aboutSuffix: "__about",
		protocollist: getProtocolList(),
		localpath: '/new',
		baseurl: 'http:///',
	};
	res.render('endpoint', defaultdata);
});

/**
 * Redirect to the approprate path and treat like a save.
 */
app.post('/new', function (req, res) {
	endpointid = req.body.id
	if (!endpointid.trim()) {
		endpointid = req.body.base
	};
	cmdb.getItem(res.locals, 'endpoint', endpointid).then(function (endpoint) {
		req.body.iderror = "ID already in use, please re-enter"
		res.render('endpoint', req.body);
	}).catch(function (error) {
		res.redirect(307, '/manage/' + encodeURIComponent(encodeURIComponent(endpointid)));
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

/** 
 * Transforms the data from CMDB into something expected by the templates
 */
function endpointController(endpoint) {
	endpoint.id = endpoint.dataItemID;
	delete endpoint.dataItemID;
	delete endpoint.dataTypeID;
	if (!endpoint.hasOwnProperty('base')) {
		endpoint.base = endpoint.id;
	};
	endpoint.localpath = "/manage/"+encodeURIComponent(encodeURIComponent(endpoint.id));
	endpoint.protocollist = getProtocolList(endpoint.protocol);
	endpoint.urls = [];
	var protocols = [];
	if (['http', 'https'].indexOf(endpoint.protocol) != -1) {
		protocols.push(endpoint.protocol);
		endpoint.baseurl = endpoint.protocol+"://"+endpoint.base+"/";
	} else if (endpoint.protocol == "both") {
		protocols = ['http', 'https'];

		// In the form, just show http for the baseurl for simplicity
		endpoint.baseurl = "http://"+endpoint.base+"/";
	}
	protocols.forEach(function (protocol) {
		var validateparams = "?host="+encodeURIComponent(endpoint.id)
			+ "&protocol=" + encodeURIComponent(protocol)
			+ "&healthSuffix=" + encodeURIComponent(endpoint.healthSuffix);
		if (endpoint.healthSuffix) endpoint.urls.push({
			type: 'health',
			url: protocol+"://"+endpoint.base+"/"+endpoint.healthSuffix,
			validateurl: health_api + "validate"+validateparams,
			validateapi: health_api + "validate.json"+validateparams,
			apikey: health_apikey,
		});
		if (endpoint.aboutSuffix) endpoint.urls.push({
			type: 'about',
			url: protocol+"://"+endpoint.base+"/"+endpoint.aboutSuffix,
		});
	});
	if (endpoint.isHealthcheckFor && endpoint.isHealthcheckFor.system && endpoint.isHealthcheckFor.system[0].dataItemID) {
		endpoint.systemCode = endpoint.isHealthcheckFor.system[0].dataItemID;
	}
	endpoint.isLive = (endpoint.isLive == "True");
	return endpoint;
}

function getProtocolList(selected) {
	var protocollist = [
		{name: "HTTP", value: "http"},
		{name: "HTTPS", value: "https"},
		{name: "HTTP & HTTPS", value: "both"},
	];
	protocollist.forEach(function (protocol) {
		if (protocol.value == selected) protocol.selected = true;
	});
	return protocollist;
}

function remove_blank_values(obj, recurse) {
	for (var i in obj) {
		if (obj[i] === null || obj[i] === '') {
			delete obj[i];
		} else {
			if (recurse && typeof obj[i] === 'object') {
				remove_blank_values(obj[i], recurse);
				if (Object.keys(obj[i]).length == 0) {
					{
						delete obj[i];
					}
				}
			}
		}
	}
}