#!/usr/bin/env bash

docker build -t ianamunoz/docker-zcash:latest .

docker run -itd --rm --name zcashd ianamunoz/docker-zcash

sudo docker cp zcashd:/usr/local/bin/zcash-cli /usr/local/bin/
sudo docker cp zcashd:/usr/local/bin/zcashd /usr/local/bin/
sudo docker cp zcashd:/usr/local/bin/zcash-tx /usr/local/bin/

docker stop zcashd
