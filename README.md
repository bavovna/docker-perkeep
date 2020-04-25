# docker-perkeep
prebuilt docker image of perkeep (aka camlistore)

## instructions

```bash
docker stop perkeepd && docker rm -v perkeepd
docker run -d --restart=always --memory="1G" --name=perkeepd --volume=/srv/perkeep:/srv/perkeep -p 3179:3179 docker.pkg.github.com/mkorenkov/docker-perkeep/perkeep:latest
```

1. modify `/srv/perkeep/.config/perkeep/server-config.json` according to [perkeep docs](https://perkeep.org/doc/server-config).
2. get [Google maps key](https://developers.google.com/maps/documentation/geocoding/get-api-key) and save it to `/srv/perkeep/.config/perkeep/google-geocode.key`
3. add `alias pk="docker run --rm -it --volume=/srv/perkeep:/srv/perkeep docker.pkg.github.com/mkorenkov/docker-perkeep/perkeep:latest /bin/pk"` to your env

## (optional) obtaining Google Cloud Compute key

1. go to https://console.cloud.google.com > API & Services > Credentials
2. create "Other" OAuth Client ID
3. use obtained values as input for the following command
```
docker run -it --volume=/srv/perkeep:/srv/perkeep docker.pkg.github.com/mkorenkov/docker-perkeep/perkeep:latest /bin/pk googinit -type cloud
```
4. paste results into your config (consult perkeep docs)

## (optional) low level configuration

Low level config can be printed using `pk dumpconfig`

### Google Cloud Storage

```json
    "/sto-googlecloudstorage/": {
      "handler": "storage-googlecloudstorage",
      "handlerArgs": {
        "auth": {
          "client_id": "something.apps.googleusercontent.com",
          "client_secret": "client-secret",
          "refresh_token": "refresh-token"
        },
        "bucket": "bucket-name"
      }
    },
    "/sync-to-googlecloudstorage/": {
      "handler": "sync",
      "handlerArgs": {
        "from": "/bs/",
        "queue": {
          "file": "/srv/perkeep/var/perkeep/blobs/sync-to-googlecloud-queue.leveldb",
          "type": "leveldb"
        },
        "to": "/sto-googlecloudstorage/"
      }
    },
```

## S3 compatible storage

```json
    "/sto-wasabi/": {
      "handler": "storage-s3",
      "handlerArgs": {
        "aws_access_key": "very-secret",
        "aws_secret_access_key": "such-secret-vow",
        "bucket": "bucket-name",
        "hostname": "s3.us-west-1.wasabisys.com"
      }
    },
    "/sync-to-wasabi/": {
      "handler": "sync",
      "handlerArgs": {
        "from": "/bs/",
        "queue": {
          "file": "/srv/perkeep/var/perkeep/blobs/sync-to-wasabi-queue.leveldb",
          "type": "leveldb"
        },
        "to": "/sto-wasabi/"
      }
    },
```

## Replication

```json
    "/repl/": {
			"handler": "storage-replica",
			"handlerArgs": {
				"backends": ["/sto-wasabi-east/", "/sto-wasabi-west/"],
				"minWritesForSuccess": 2
			}
    },
    "/sync-to-replicas/": {
      "handler": "sync",
      "handlerArgs": {
        "from": "/bs/",
        "queue": {
          "file": "/srv/perkeep/var/perkeep/blobs/sync-to-replicas-queue.leveldb",
          "type": "leveldb"
        },
        "to": "/repl/"
      }
    },
```

## Encryption

```json
    "/enc-wasabi-east/": {
      "handler": "storage-encrypt",
      "handlerArgs": {
        "I_AGREE": "that encryption support hasn't been peer-reviewed, isn't finished, and its format might change.",
        "meta": "/enc-wasabi-east-meta/",
        "blobs": "/enc-wasabi-east-blob/",
        "metaIndex": {
          "file": "/srv/perkeep/var/perkeep/blobs/enc-wasabi-east-queue.leveldb",
          "type": "leveldb"
        },
        "passphrase": "secret"
      }
    },
    "/enc-wasabi-east-meta/": {
      "handler": "storage-s3",
      "handlerArgs": {
        "aws_access_key": "very-secret",
        "aws_secret_access_key": "such-secret-vow",
        "bucket": "bucket-name/meta",
        "hostname": "s3.us-east-2.wasabisys.com"
      }
    },
    "/enc-wasabi-east-blob/": {
      "handler": "storage-s3",
      "handlerArgs": {
        "aws_access_key": "very-secret",
        "aws_secret_access_key": "such-secret-vow",
        "bucket": "bucket-name/blob",
        "hostname": "s3.us-east-2.wasabisys.com"
      }
    },
```
