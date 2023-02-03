#NANOENV=beta #or live
NANOENV=live
DOCKER_TAG=gr0v1ty\/nano-node:optimisic_elections_testing
#DOCKER_TAG=nanocurrency\/nano:V24.0
#RPCPORT=55000
RPCPORT=7076

echo NANOENV=$NANOENV > .env
echo DOCKER_TAG=$DOCKER_TAG >> .env
echo RPCPORT=$RPCPORT >> .env
if [ "$NANOENV" = "live" ]
then
  NANO_PATH="Nano"
else
  NANO_PATH="NanoBeta"
fi

#Test can only run if a ledger file exists
if [ ! -f ./client_node/${NANO_PATH}/data.ldb ]
then
    echo "data.ldb does not exist. Please place your [data.ldb] file into ./client_node/${NANO_PATH}/"
    exit 0
fi

#Use virtual envionment to not pollute the host machine
if ! [ -d "venv_python3" ]; then
    ./setup_python_venv.sh
fi

#stop any existing testruns
docker-compose -f docker-compose.optimistic.yml down

docker-compose -f docker-compose.optimistic.yml up -d nano_optimistic_elections_client
echo $(docker exec -it nano_optimistic_elections_client /usr/bin/nano_node  --data_path=/home/nanocurrency/$NANO_PATH --network=$NANOENV --debug_block_count)
echo "Clearing confirmation height..."
echo $(docker exec -it nano_optimistic_elections_client /usr/bin/nano_node  --data_path=/home/nanocurrency/$NANO_PATH --network=$NANOENV --confirmation_height_clear --account=all)
docker restart nano_optimistic_elections_client
echo $(docker exec -it nano_optimistic_elections_client /usr/bin/nano_node  --data_path=/home/nanocurrency/$NANO_PATH --network=$NANOENV --debug_block_count)
docker-compose -f docker-compose.optimistic.yml up -d
