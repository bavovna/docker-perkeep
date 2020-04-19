# docker-perkeep
docker images for perkeep (aka camlistore)

## instructions

```bash
docker stop perkeepd && docker rm -v perkeepd
docker run -d --restart=always --memory="1G" --name=perkeepd --volume=/srv/perkeep:/srv/perkeep -p 3179:3179 mkorenkov/perkeep:latest
```

1. modify `/srv/perkeep/.config/perkeep/server-config.json` according to [perkeep docs](https://perkeep.org/doc/server-config).
2. get [Google maps key](https://developers.google.com/maps/documentation/geocoding/get-api-key) and save it to `/srv/perkeep/.config/perkeep/google-geocode.key`
