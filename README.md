# Dockerized VPN Proxy

Magical HTTP and SOCKS4/SOCKS5 proxy behind VPN (without host being on VPN)

Other **joestldr** used containers under this `docker compose` project:
- dockerized-openvpn-client
    - https://hub.docker.com/r/joestldr/openvpn-client
    - https://github.com/joestldr/dockerized-openvpn-client
- dockerized-http-proxy
    - https://hub.docker.com/r/joestldr/http-proxy
    - https://github.com/joestldr/dockerized-http-proxy
- dockerized-srelay
    - https://hub.docker.com/r/joestldr/srelay
    - https://github.com/joestldr/dockerized-srelay
- dockerized-toolbox
    - https://hub.docker.com/r/joestldr/toolbox
    - https://github.com/joestldr/dockerized-toolbox

## TLDR; Quickstart... But not so quick...

Assuming your VPN server requires username/password... This is straightforward... If not... I believe in you!~ You will figure it out ^^,

### Step #1: Checkout `.git` and make `tmp` and `config/openvpn` subfolder

```bash
git clone git@github.com:joestldr/dockerized-vpn-proxy.git; \
cd dockerized-vpn-proxy; \
mkdir -p ./tmp ./config/openvpn
```

### Step #2: `.env`

```bash
cat <<\EOF > ./config/.env
DNS_PRIMARY=9.9.9.9
DNS_SECONDARY=149.112.112.112
CHECK_IP_URL=https://checkip.amazonaws.com
CHECK_IP_PATH=/tmp/get-local-public-ip
CHECK_IP_FILE=/tmp/get-local-public-ip/LOCAL_PUBLIC_IP
EOF
```
**Note**: These sample values can work as-is... READ `docker-compose.yaml` to understand where/why these values are used.

**Note**: **joestldr** is a big fan of QUAD9 DNS (`9.9.9.9`, `149.112.112.112`): https://www.quad9.net/

### Step #3 `config/openvpn`

Add your VPN server configuration file as `./config/openvpn/client.ovpn` and username/password as `./config/openvpn/client.pass`:

- `./config/openvpn/client.ovpn`
  ```bash
  client
  dev tun
  proto udp
  remote sg-sng.prod.surfshark.com 1194
  # ...
  # etc. etc. etc.
  ```
  **Note**: **joestldr** is a big fan of Surfshark: https://surfshark.com/
- `./config/openvpn/client.pass`
  ```bash
  FIRST_LINE_IS_USERNAME
  SECOND_LINE_IS_PASSWORD
  ```
  Ref: https://stackoverflow.com/a/48862593

### Step #4 Review

```bash
tree .
.
├── compose.sh
├── config
│   └── openvpn
│       ├── client.ovpn
│       └── client.pass
├── docker-compose.yaml
├── README.md
└── tmp
```

### Step #5 CONNECT!~

```bash
./compose.sh start
```

**Note**: This will launch detached `docker compose up --detach`, and will just immediately `docker compose logs -f` after.

## Test!~

```bash
# your actual own public IP
curl --noproxy checkip.amazonaws.com https://checkip.amazonaws.com

# test http-proxy
curl --proxy http://127.0.0.1:3128 https://checkip.amazonaws.com

# test socks-proxy
curl --proxy socks://127.0.0.1:1080 https://checkip.amazonaws.com
curl --proxy socks4://127.0.0.1:1080 https://checkip.amazonaws.com
curl --proxy socks5://127.0.0.1:1080 https://checkip.amazonaws.com
```

# License

Copyright 2023 [joestldr](https://joestldr.com)

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the “Software”), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
