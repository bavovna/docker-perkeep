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
```

all the subsequent runs do not require authentication settings:
```bash
docker stop camlistored && docker rm -v camlistored
docker run -d --restart=always --name=camlistored --volumes-from=camlidata -p 3179:3179 mkorenkov/camlistored:latest
```

## advanced instructions:

edit configuration (e.g. identity param or authentication settings):

```bash
docker stop camlistored && docker rm -v camlistored
docker run --name camlistore_import --volumes-from=camlidata -i -t ubuntu:14.04 /bin/bash
apt-get install -y vim && vim /srv/camlistore/.config/camlistore/server-config.json
```

copy identity secret:

```bash
docker stop camlistored && docker rm -v camlistored
docker run --name camlistore_import --volumes-from=camlidata -i -t ubuntu:14.04 /bin/bash
#open second terminal and run
cat ~/.config/camlistore/identity-secring.gpg | docker exec -i camlistore_import sh -c 'cat > /srv/camlistore/.config/camlistore/identity-secring.gpg'
```

and run camlistore again:

```bash
docker run -d --restart=always --name=camlistored --volumes-from=camlidata -p 3179:3179 mkorenkov/camlistored:latest
```

## camtool

run camtool container command (e.g. `dumpconfig`) with:

```bash
docker run --rm --name camtool --volumes-from=camlidata -i -t mkorenkov/camtool dumpconfig
```
