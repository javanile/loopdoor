# loopdoor

Loopdoor is a command line tool that wrap SSH Reverse Tunnel 
to connect `master` station (laptop, server, etc...) placed outside a private LAN 
and get control of `slave` station placed inside the private LAN.

## Setup `master` station 
The `master` station need to have Docker installed, than run this command and wait for `slave` station connection. 
```
$ curl -XPOST mystation.ipqueue.com && docker run --rm -it \
       -p 55555:55555 -e LOOPDOOR_PASSWORD=loopdoor javanile/loopdoor
```

## Setup `slave` station 
The `master` station need to have SSH Client installed.
```bash
$ curl -sL https://javanile.github.io/loopdoor/setup | sudo -E bash -
```

```bash
$ curl -OL javanile.github.io/loopdoor/loopdoor
$ chmod +x loopdoor
$ sudo loopdoor /usr/local/bin
```

```yaml
## public backdoor server
varsion: '3'

services:
  backdoor:
    image: javanile/backdoor
    ports:    
      - '10022:10022'
```

```yaml
## private backdoor target
varsion: '3'

services:
  backdoor:
    image: javanile/backdoor
    environment:
      - BACKDOOR_HOST=<public-server-host>
      - BACKDOOR_BIND=50000
```

```yaml
## private backdoor client (need access to target)
varsion: '3'

services:
  backdoor:
    image: javanile/backdoor
    environment:
      - BACKDOOR_HOST=<public-server-host>
      - BACKDOOR_OPEN=50000
```

docker run --rm -p 10022:10022 javanile/backdoor






docker run --rm -d \
    -e BACKDOOR_HOST=private.backdoor.net \
    -e BACKDOOR_PORT=10022 \
    -e BACKDOOR_BIND=50000 \ 
    javanile/backdoor

docker run --rm -it \      
    -e BACKDOOR_HOST=private.backdoor.net \
    -e BACKDOOR_PORT=10022 \
    -e BACKDOOR_OPEN=50000 \ 
    -e BACKDOOR_USER=root \
    javanile/backdoor

ssh -p 10022 backdoor@90.88.55.62 -R 19999:localhost:2

ssh -p 10022 backdoor@localhost 19999

curl -sL https://javanile.github.io/backdoor/setup | sudo -E bash -



backdoor bind 50000

backdoor open 50000

