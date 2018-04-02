# ianamunoz/docker-zcash

Zcash inside docker

Image is based on the [debian](https://hub.docker.com/_/debian/) base image

## Docker image usage

```
docker run [docker-options] ianamunoz/docker-zcash
```

## Examples

Typical basic usage (start zcashd testnet daemon):
  - Having your data directory in a named location will allow persistence between containers.

```
mkdir -p ~/.zcash.testnet

cat >~/.zcash.testnet/zcash.conf <<EOF
addnode=testnet.z.cash
rpcuser=username
rpcpassword=$(head -c 32 /dev/urandom | base64)
gen=0
genproclimit=$(lscpu | sed -n '/^Core/p' | awk '{print $4}')
equihashsolver=tromp
EOF

docker run -t -d --name zcashd_testnet \
  -v ${HOME}/.zcash.testnet:/home/zcash/.zcash.testnet \
  --restart=unless-stopped \
  --user=$(id -u):$(id -g) \
  -p 8233:8233 \
  ianamunoz/docker-zcash

```

## Beta
Helper script with common defaults set:

```
./run_zcash zcashd
```
