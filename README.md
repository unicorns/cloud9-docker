# cloud9-docker

## Getting Started

```bash
docker build -t cloud9 .
docker run --rm --name cloud9 -it -p 8181:8181 cloud9 -a username:password
```

## Credits

Dockerfile references [theia-full](https://github.com/theia-ide/theia-apps/blob/0610ffa4213c499127b372d92dc658ec726d9ca1/theia-full-docker/Dockerfile#L174)
