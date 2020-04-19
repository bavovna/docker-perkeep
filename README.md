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
