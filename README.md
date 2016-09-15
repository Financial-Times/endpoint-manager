# endpoint-manager
UI for managing endpoints in CMDB

## Local Dev
Run `npm start`

## Environment variables
All environment variables are optional.

- _PORT_ The HTTP port to listen on.  Defaults to 3001;
- _CMDB_API_ The CMDB API to use.  Defaults to 'https://cmdb.ft.com/v2';
- _CMDB_APIKEY_ The API key for this application to talk to CMDB.  Defaults to 'changeme';
- _HEALTH_API_ The healthcheck aggregator API to use for validataions.  Defaults to 'http://healthcheck.ft.com/';
- _HEALTH_APIKEY_ The API key for this application to use the healtcheck aggregator validation.  Defaults to nothing.
