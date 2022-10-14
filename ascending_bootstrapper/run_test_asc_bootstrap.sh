env=beta #or live
docker_tag=new-bootstrap-$(date '+%Y%m%d')
build_path=https://github.com/nanocurrency/nano-node/\#new-bootstrap
test_path=./ #current folder

echo "BUILD nano_node from $build_path with tag '$docker_tag'"

#build the nano node as docker container
cd $build_path &&  docker build -f docker/node/Dockerfile -t $docker_tag .

#stop any current test
cd $test_path && docker-compose -f docker-compose.$env.yml down
#replace the docker tag in the compose file with the latest build
cd $test_path && sed -i "s/image.*/image: $docker_tag/g" docker-compose.yml
#remove the  client ledger to start from 0 for each testrun
cd $test_path/NanoBeta_client/NanoBeta && rm -rf rocksdb && rm -f data.ldb
#start the nodes and run the test
cd $test_path && docker-compose -f docker-compose.$env.yml up -d
