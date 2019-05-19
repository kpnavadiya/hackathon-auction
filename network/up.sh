docker-compose -f ./deployment/all_containers.yaml up -d
sleep 10
docker-compose -f ./deployment/docker-compose-cli.yaml up -d


