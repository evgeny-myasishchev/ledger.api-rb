# Ledger api layer

## Dev

```$ bundle```

```$ docker-compose start```

```$ bin/rake db:setup```

```$ bin/rake spec```

```$ bin/rails s```

Use guard to have tests running for any change:

```$ guard```

## Production dependencies

Environment variables:

* AUTH0_AUDIENCE
* AUTH0_DOMAIN


## Docker

Build image for local use

```
docker build . -t ledger-api:local
```

Prepare env:
```
AUTH0_DOMAIN=ledger-staging.eu.auth0.com
AUTH0_AUDIENCE=https://staging.api.my-ledger.com
DATABASE_URL=postgresql://user:password@host/db-name
```

Start web worker

```
docker run --rm -it --env-file .env -p3000:3000 ledger-api:local start
```
