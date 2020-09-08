# OpenVPN dockerfile

Dockerfile to create an OpenVPN Image ready to execute a Server.

## Buiding image

```
docker build -t openvpn .
```

## Creating a container

```
docker container run -it --rm -v vpn-server:/etc/openvpn/server \
                              -v clients:/root/clients \
                              -v certificates:/root/certificates \
                              --cap-add=NET_ADMIN \
                              --device /dev/net/tun -p1194:1194/udp \
                              --name my-ovpnserver openvpn
```

Use the init.sh script to create a initial CA and certificates structure
automatically. It uses the `create_ca.sh` and the `create_vpn_server_certs.sh`

```
docker exec -it my-ovpnserver /bin/bash /root/init.sh
```

To create client certificates and VPN config files, use the `make-client.sh`
script.

```
docker exec -it my-ovpnserver /bin/bash /root/make-client.sh <ClientID>
```

The folders `/root/certificates` and `/root/clients` store the certificates and
configurations for clients. The `/etc/openvpn/server` contains the server
certificates, CA and server configuration. Each of these folders are mapped to a
volume, to ensure persistance. if you whish to create your own chain of
certificates and configurations, just dont execute the scripts and mount the
volumes to the appropriate paths.

## TAP VPN
```
docker container run -it --rm -v vpn-server:/etc/openvpn/server \
                              -v clients:/root/clients \
                              -v certificates:/root/certificates \
                              --network host --cap-add=NET_ADMIN \
                              --device /dev/net/tun \
                              --name my-ovpnserver openvpn
```
