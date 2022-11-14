env=beta #or live
docker_tag="docker.io\/library\/new-bootstrap_2022-11-14" #escape slashes!
test_path=. #current folder
prom_exporter_job="nano-tests_ascending_bootstrap"

#stop any current test
cd $test_path && docker-compose -f docker-compose.$env.yml down
#replace the docker tag in the compose file with the latest build
cd $test_path && sed -i "s/image.*/image: $docker_tag/g" docker-compose.$env.yml
#remove the  client ledger to start from 0 for each testrun
cd $test_path/client_node/NanoBeta && rm -rf rocksdb && rm -f data.ldb && cd ../../
#replace prom_exporter job showing the testrun under https://nl-nodestats.bnano.info
cd $test_path && sed -i "s/--runid.*/--runid ${prom_exporter_job}_${env}/g" docker-compose.$env.yml
#start the nodes and run the test
cd $test_path && docker-compose -f docker-compose.$env.yml up -d
