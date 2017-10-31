'use strict'

const express = require('express')

const app = express()
const bodyParser = require('body-parser')

app.use(bodyParser.json())
app.use(bodyParser.urlencoded({ extended: true }))

const mustacheExpress = require('mustache-express')

// Register '.ms' extension with The Mustache Express
app.engine('ms', mustacheExpress())
app.set('view engine', 'ms')
app.set('views', `${__dirname}/views`)

// Set the public directory as public for serving assets
app.use(express.static('public'))

// var CMDB = require("./cmdb.js");
let CMDB
const path = require('path')

if (process.env.LOCALCMDBJS) {
    // eslint-disable-next-line global-require, import/no-dynamic-require
    CMDB = require(path.resolve(__dirname, './cmdb.js'))
} else {
    // eslint-disable-next-line global-require
    CMDB = require('cmdb.js')
}

/** Environment variables * */
const port = process.env.PORT || 3001
let healthApi = process.env.HEALTH_API || 'http://healthcheck.ft.com/'
if (healthApi.slice(-1) !== '/') healthApi += '/'
const healthApiKey = process.env.HEALTH_APIKEY || ''
const cmdb = new CMDB({
    api: process.env.CMDB_API,
    apikey: process.env.CMDB_APIKEY,
})

const systemTool =
    process.env.SYSTEMREGISTRY || 'https://systemregistry.in.ft.com/manage/'
const endpointTool =
    process.env.ENDPOINTMANAGER || 'https://endpointmanager.in.ft.com/manage/'
const contactTool =
    process.env.CONTACTORGANISER ||
    'https://contactorganiser.in.ft.com/contacts/'
let reservedRelTypes = process.env.RESERVEDRELTYPES || 'isHealthcheckFor'
reservedRelTypes = `,${reservedRelTypes},` // to force every value to be enclosed in commas

const ftwebservice = require('express-ftwebservice')

ftwebservice(app, {
    manifestPath: path.join(__dirname, 'package.json'),
    about: {
        systemCode: 'endpoint-manager',
        name: 'Endpoint Manager',
        audience: 'FT Technology',
        serviceTier: 'bronze',
    },

    // Also pass good to go.	If application is healthy enough to return it, then it can serve traffic.
    goodToGoTest() {
        return Promise.resolve(true)
    },

    // Check that track can talk to CMDB
    healthCheck() {
        return cmdb
            .getItem(null, 'endpoint', 'endpointmanager.in.ft.com')
            .then(() => {
                return false
            })
            .catch(error => {
                return error.message
            })
            .then(output => {
                return [
                    {
                        id: 'cmdb-connection',
                        name: 'Connectivity to CMDB',
                        ok: !output,
                        severity: 1,
                        businessImpact:
                            "Can't manage health and about endpoints through the UI",
                        technicalSummary:
                            "App can't connect make a GET request to CMDB",
                        panicGuide:
                            'Check for alerts related to cmdb.ft.com.	Check connectivity to cmdb.ft.com',
                        checkOutput: output,
                        lastUpdated: new Date().toISOString(),
                    },
                ]
            })
    },
})

// Add authentication to everything which isn't one of the standard ftwebservice paths
// and ensure cache control matched akamai expectation
const authS3O = require('s3o-middleware')

app.use(authS3O)
app.use((req, res, next) => {
    res.setHeader('Cache-Control', 'private, no-store, max-age=0')
    next()
})

/**
 * Gets a list of Endpoints from the CMDB and renders them
 */
app.get('/', (req, res) => {
    console.time('CMDB api call for endpoint count')
    cmdb
        .getItemCount(res.locals, 'endpoint', endpointFilter(req))
        .then(counters => {
            console.timeEnd('CMDB api call for endpoint count')
            console.log(counters)
            console.time('CMDB api call for all endpoints')
            const { sortby, page } = req.query
            // prepare pagination links
            const pagebuttons = getPageButtons(page, counters.pages)
            // read one page of endpoints
            cmdb
                .getItemPageFields(
                    res.locals,
                    'endpoint',
                    page,
                    endpointFields(req),
                    endpointFilter(req)
                )
                .then(endpoints => {
                    endpoints.forEach(indexController)
                    endpoints.sort(compareOnKey(sortby))
                    console.timeEnd('CMDB api call for all endpoints')
                    // render the index and the filter parameters
                    res.render(
                        'index',
                        Object.assign(
                            { pages: pagebuttons },
                            { endpoints },
                            req.query,
                            {
                                systemCode_dataItemID:
                                    req.query['isHealthcheckFor.dataItemID'],
                            }
                        )
                    )
                })
                .catch(error => {
                    res.status(502)
                    res.render('error', {
                        message: `Problem obtaining list of endpoints from CMDB (${error})`,
                    })
                })
        })
        .catch(error => {
            res.status(502)
            res.render('error', {
                message: `Problem obtaining count of endpoints from CMDB (${error})`,
            })
        })
})

function getPageButtons(page, maxpages) {
    // are there any pages?
    if (!maxpages) {
        return undefined
    }
    // which page are we on
    if (!page) {
        page = 1
    }
    // prepare pagination links
    const pagination = []
    let startpageno = page - 3
    if (startpageno < 1) {
        startpageno = 1
    }
    let endpageno = startpageno + 6
    if (endpageno > maxpages) {
        endpageno = maxpages
    }
    // prefix for page 1
    if (startpageno !== 1) {
        pagination.push({ number: 1, selected: false })
        pagination.push({ faux: true })
    }
    // main set of page links centerde around the current page
    let pageno = startpageno
    while (pageno <= endpageno && pagination.length < 9) {
        if (pageno === page) {
            pagination.push({ number: pageno, selected: true })
        } else {
            pagination.push({ number: pageno, selected: false })
        }
        pageno += 1
    }
    // suffix for last page
    if (endpageno < maxpages) {
        pagination.push({ faux: true })
        pagination.push({ number: maxpages, selected: false })
    }

    return pagination
}

function endpointFilter(req) {
    const cmdbparams = {}
    Object.assign(cmdbparams, req.query)
    console.log('cmdbparams:', cmdbparams)
    delete cmdbparams.sortby // to avoid it being added to cmdb params
    removeBlankValues(cmdbparams)
    console.log('filter:', cmdbparams)
    return cmdbparams
}

function endpointFields() {
    return [
        'isHealthcheckFor',
        'isLive',
        'protocol',
        'healthSuffix',
        'aboutSuffix',
    ]
}

function compareOnKey(key) {
    return function(a, b) {
        if (!key) {
            // default to url sort
            key = 'dataItemID'
        }
        const avalue = a[key]
        const bvalue = b[key]
        if (!avalue) return -1
        if (!bvalue) return 1
        return avalue.toLowerCase() > bvalue.toLowerCase() ? 1 : -1
    }
}

/**
 * Gets info about a given Endpoint from the CMDB and provides a form for editing it
 */
app.get('/manage/:endpointid', (req, res) => {
    cmdb
        .getItem(res.locals, 'endpoint', req.params.endpointid)
        .then(endpoint => {
            res.render('endpoint', endpointController(endpoint))
        })
        .catch(error => {
            res.status(502)
            res.render('error', {
                message: `Problem obtaining details for ${req.params
                    .endpointid} from CMDB (${error})`,
            })
        })
})

/**
 * Updates an Endpoint
 */
app.post('/manage/:endpointid', (req, res) => {
    console.log('isLive:', req.body.isLive)
    const isLive = !!req.body.isLive
    console.log('!!isLive:', isLive)
    const endpoint = {
        base: req.body.base,
        protocol: req.body.protocol,
        healthSuffix: req.body.healthSuffix,
        aboutSuffix: req.body.aboutSuffix,
    }
    // ensure camelcase on output to screen and database
    if (isLive === true) {
        endpoint.isLive = 'True'
    } else {
        endpoint.isLive = 'False'
    }
    console.log('isLive string:', endpoint.isLive)

    if (req.body.systemCode)
        endpoint.isHealthcheckFor = {
            system: [{ dataItemID: req.body.systemCode }],
        }
    cmdb
        .putItem(res.locals, 'endpoint', req.params.endpointid, endpoint)
        .then(result => {
            result.saved = {
                locals: JSON.stringify(res.locals),
                endpointid: req.params.endpointid,

                // TODO: replace with pretty print function
                json: JSON.stringify(endpoint)
                    .replace(/,/g, ',\n\t')
                    .replace(/}/g, '\n}')
                    .replace(/{/g, '{\n\t'),

                // TODO: get actual url from cmdb.js
                url: `https://cmdb.ft.com/v2/items/endpoint/${encodeURIComponent(
                    encodeURIComponent(req.params.endpointid)
                )}`,
            }
            res.render('endpoint', endpointController(result))
        })
        .catch(error => {
            res.status(502)
            res.render('error', {
                message: `Problem posting details for ${req.params
                    .endpointid} to CMDB (${error})`,
            })
        })
})

/**
 * Deletes an Endpoint
 */
app.post('/manage/:endpointid/delete', (req, res) => {
    cmdb
        .deleteItem(res.locals, 'endpoint', req.params.endpointid)
        .then(() => {
            // TODO: show messaging to indicate the delete was successful
            res.redirect(303, '/')
        })
        .catch(error => {
            if (error.toString().includes(' 409 ')) {
                // get endpoint details ready to display error in context
                cmdb
                    .getItem(res.locals, 'endpoint', req.params.endpointid)
                    .then(endpoint => {
                        const result = endpointController(endpoint)
                        result.dependerror =
                            'Unable to delete this endpoint, dependencies exist - see below. Please reassign the related items before retrying'
                        res.render('endpoint', result)
                    })
                    .catch(() => {
                        res.status(502)
                        res.render('error', {
                            message: `Problem obtaining details for ${req.params
                                .endpointid} from CMDB (${error})`,
                        })
                    })
            } else {
                res.status(502)
                res.render('error', {
                    message: `Problem deleting ${req.params
                        .endpointid} from CMDB (${error})`,
                })
            }
        })
})

/**
 * Displays blank endpoint form for adding new endpoints
 */
app.get('/new', (req, res) => {
    const defaultdata = {
        base: '',
        endpointid: '',
        healthSuffix: '__health',
        aboutSuffix: '__about',
        protocollist: getProtocolList(),
        localpath: '/new',
        baseurl: 'http:///',
    }
    res.render('endpoint', defaultdata)
})

/**
 * Redirect to the approprate path and treat like a save.
 */
app.post('/new', (req, res) => {
    let endpointid = req.body.id
    if (!endpointid.trim()) {
        endpointid = req.body.base
    }
    cmdb
        .getItem(res.locals, 'endpoint', endpointid)
        .then(() => {
            req.body.iderror = 'ID already in use, please re-enter'
            res.render('endpoint', formattedRequest(req))
        })
        .catch(() => {
            res.redirect(307, `/manage/${encodeURIComponent(endpointid)}`)
        })
})

function formattedRequest(req) {
    const request = req.body
    request.protocollist = getProtocolList(request.protocol)

    return request
}

app.use((req, res) => {
    res.status(404).render('error', { message: 'Page not found.' })
})

// eslint-disable-next-line no-unused-vars
app.use((err, req, res, next) => {
    console.error(err.stack)
    res.status(500)
    if (
        res.get('Content-Type') &&
        res.get('Content-Type').indexOf('json') !== -1
    ) {
        res.send({ error: 'Sorry, an unknown error occurred.' })
    } else {
        res.render('error', { message: 'Sorry, an unknown error occurred.' })
    }
})

app.listen(port, () => {
    console.log(`App listening on port ${port}`)
})

/**
 * Transforms the data from CMDB into something expected by the index
 */
function indexController(endpoint) {
    endpoint.id = endpoint.dataItemID

    // look for relationships  endpoint.xxx.[..,..,..]
    const relationships = []
    Object.keys(endpoint).forEach(reltype => {
        // ignore/exclude test attributes and relationships reserved for use by this app
        if (
            reservedRelTypes.indexOf(`,${reltype},`) === -1 &&
            typeof endpoint[reltype] === 'object'
        ) {
            Object.keys(endpoint[reltype]).forEach(itemtype => {
                if (typeof endpoint[reltype][itemtype] === 'object') {
                    endpoint[reltype][itemtype].forEach(relationship => {
                        console.log('relationship:', relationship)
                        let relitemlink = ''
                        const relitem = `${itemtype}: ${relationship.dataItemID}`
                        if (itemtype === 'system') {
                            relitemlink = systemTool + relationship.dataItemID
                        }
                        if (itemtype === 'endpoint') {
                            console.log(endpointTool + relationship.dataItemID)
                            relitemlink = endpointTool + relationship.dataItemID
                        }
                        if (itemtype === 'contact') {
                            relitemlink = contactTool + relationship.dataItemID
                        }
                        relationships.push({
                            reltype,
                            relitem,
                            relitemlink,
                        })
                    })
                }
            })
        }
    })
    if (relationships) {
        endpoint.relationships = relationships
    }

    endpoint.localpath = `/manage/${encodeURIComponent(endpoint.id)}`
    if (
        endpoint.isHealthcheckFor &&
        endpoint.isHealthcheckFor.system &&
        endpoint.isHealthcheckFor.system[0].dataItemID
    ) {
        endpoint.systemCode = endpoint.isHealthcheckFor.system[0].dataItemID
    }
    return endpoint
}

/**
 * Transforms the data from CMDB into something expected by the templates
 */
function endpointController(endpoint) {
    endpoint.id = endpoint.dataItemID
    delete endpoint.dataItemID
    delete endpoint.dataTypeID
    if (!{}.hasOwnProperty.call(endpoint, 'base')) {
        endpoint.base = endpoint.id
    }
    endpoint.localpath = `/manage/${encodeURIComponent(endpoint.id)}`
    endpoint.protocollist = getProtocolList(endpoint.protocol)
    endpoint.urls = []
    let protocols = []
    if (['http', 'https'].indexOf(endpoint.protocol) !== -1) {
        protocols.push(endpoint.protocol)
        endpoint.baseurl = `${endpoint.protocol}://${endpoint.base}/`
    } else if (endpoint.protocol === 'both') {
        protocols = ['http', 'https']

        // In the form, just show http for the baseurl for simplicity
        endpoint.baseurl = `http://${endpoint.base}/`
    }
    protocols.forEach(protocol => {
        const validateparams = `?host=${encodeURIComponent(
            endpoint.id
        )}&protocol=${encodeURIComponent(
            protocol
        )}&healthSuffix=${encodeURIComponent(endpoint.healthSuffix)}`
        if (endpoint.healthSuffix)
            endpoint.urls.push({
                type: 'health',
                url: `${protocol}://${endpoint.base}/${endpoint.healthSuffix}`,
                validateurl: `${healthApi}validate${validateparams}`,
                validateapi: `${healthApi}validate.json${validateparams}`,
                apikey: healthApiKey,
            })
        if (endpoint.aboutSuffix)
            endpoint.urls.push({
                type: 'about',
                url: `${protocol}://${endpoint.base}/${endpoint.aboutSuffix}`,
            })
    })
    if (
        endpoint.isHealthcheckFor &&
        endpoint.isHealthcheckFor.system &&
        endpoint.isHealthcheckFor.system[0].dataItemID
    ) {
        endpoint.systemCode = endpoint.isHealthcheckFor.system[0].dataItemID
    }
    if (endpoint.isLive && typeof endpoint.isLive === 'string') {
        // any case will trigger checkbox for true
        endpoint.isLive = endpoint.isLive.toLowerCase() === 'true'
    } else {
        endpoint.isLive = Boolean(endpoint.isLive)
    }
    return endpoint
}

function getProtocolList(selected) {
    const protocollist = [
        { name: 'HTTP', value: 'http' },
        { name: 'HTTPS', value: 'https' },
        { name: 'HTTP & HTTPS', value: 'both' },
    ]
    protocollist.forEach(protocol => {
        if (protocol.value === selected) protocol.selected = true
    })
    return protocollist
}

function removeBlankValues(object, deep) {
    Object.keys(object).reduce((result, key) => {
        const value = object[key]
        if (deep && typeof value === 'object') {
            const actionedValue = removeBlankValues(value, deep)
            if (Object.keys(actionedValue).length > 0) {
                result[key] = value
            }
        } else if (value) {
            result[key] = value
        }
        return result
    }, {})
}
