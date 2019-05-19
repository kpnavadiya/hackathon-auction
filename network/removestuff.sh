docker stop $(docker ps -aq) && docker rm $(docker ps -aq)
docker volume prune
docker system prune
#rm -r crypto-config && rm -r network-config && mkdir network-config
