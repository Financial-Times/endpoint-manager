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
- _SYSTEMREGISTRY_ The URL that allows related systems to be modified. Defaults to https://systemregistry.in.ft.com/manage/
- _ENDPOINTMANAGER_ The URL that allows related endpoints to be modified. Defaults to https://endpointmanager.in.ft.com/manage/
- _CONTACTORGANISER_ The URL that allows related contacts to be modified. Defaults to https://contactorganiser.in.ft.com/contacts/
- _RESERVEDRELTYPES_ A comma seprated list of the relationships managed by this app. Defaults to isHealthcheckFor

To allow for a development verison of cmdb.js you may also define the following environmental variable to force runtime execution of a copy of cmdb.js from within the same directory as index.js. If the environmental variable is not present then the latest production npm verion of cmd.bjs will be used.

- _LOCALCMDBJS_ 
