# docker-camlistore
docker images for camlistore

## installation instructions

create data container:

```bash
docker run --name=camlidata mkorenkov/camlistore-data:latest
```

replace `username` and `password` in the following command and run camlistore daemon for the first time:
```bash
docker run -d --name=camlistored --volumes-from=camlidata -p 3179:3179 -e CAMLISTORE_AUTH="userpass:username:password" mkorenkov/camlistored:latest
or
docker run -d --name=camlistored --volume=/srv/camlistore:/srv/camlistore -p 3179:3179 -e CAMLISTORE_AUTH="userpass:username:password" mkorenkov/camlistored:latest
https://developers.google.com/maps/documentation/geocoding/get-api-key
sudo vim /srv/camlistore/.config/perkeep/google-geocode.key

```

all the subsequent runs do not require authentication settings:
```bash
docker stop camlistored && docker rm -v camlistored
docker run -d --restart=always --memory="1G" --name=camlistored --volumes-from=camlidata -p 3179:3179 mkorenkov/camlistored:latest
or
docker run -d --restart=always --memory="1G" --name=camlistored --volume=/srv/camlistore:/srv/camlistore -p 3179:3179 mkorenkov/camlistored:latest
```

## advanced instructions:

edit configuration (e.g. identity param or authentication settings):

```bash
docker stop camlistored && docker rm -v camlistored
docker run --rm --name camlistore_import --volumes-from=camlidata -i -t ubuntu:18.04 /bin/bash
apt-get update && apt-get install -y vim && vim /srv/camlistore/.config/perkeep/server-config.json
```

copy identity secret:

```bash
docker stop camlistored && docker rm -v camlistored
docker run --rm --name camlistore_import --volumes-from=camlidata -i -t ubuntu:18.04 /bin/bash
#open second terminal and run
cat identity-secring.gpg | docker exec -i camlistore_import sh -c 'cat > /srv/camlistore/.config/perkeep/identity-secring.gpg'
cat server-config.json | docker exec -i camlistore_import sh -c 'cat > /srv/camlistore/.config/perkeep/server-config.json'
cat google-geocode.key | docker exec -i camlistore_import sh -c 'cat > /srv/camlistore/.config/perkeep/google-geocode.key'
```

and run camlistore again:

```bash
docker run -d --restart=always --memory="1G" --name=camlistored --volumes-from=camlidata -p 3179:3179 mkorenkov/camlistored:latest
```

or copy server config and identity files

```
docker stop camlistored && docker rm -v camlistored
docker run --rm --name camlistore_import --volumes-from=camlidata -i -t ubuntu:18.04 /bin/bash
#open second terminal and run
docker exec -i camlistore_import sh -c 'cat /srv/camlistore/.config/perkeep/identity-secring.gpg' > identity-secring.gpg
docker exec -i camlistore_import sh -c 'cat /srv/camlistore/.config/perkeep/server-config.json' > server-config.json
```

## camtool

run camtool container command (e.g. `dumpconfig`) with:

```bash
docker run --rm --name camtool --volumes-from=camlidata -i -t mkorenkov/camtool dumpconfig
```
