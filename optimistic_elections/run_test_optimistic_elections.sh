NANOENV=beta #or live
DOCKER_TAG=pwo_optimistic_elections-2
RPCPORT=55000


echo NANOENV=$NANOENV > .env
echo DOCKER_TAG=$DOCKER_TAG >> .env
echo RPCPORT=$RPCPORT >> .env
NANO_PATH="Nano${NANOENV^}"

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

#Clear confirmation_heigh in ledger (reset cemented count while keeping all blocks)
./confirmation_height_table.py delall -d ./client_node/${NANO_PATH}/data.ldb

docker-compose -f docker-compose.optimistic.yml up -d
