# Ascending boootstrapper
A dockerized network of 2 nano nodes.

- server node which holds the ledger
- client node that downloads the ledger from the server node (bootstrapping)

stats are enabled and can be seen at https://nl-nodestats.bnano.info 

(job `nano-tests_ascending_bootstrap_Beta`and `nano-tests_ascending_bootstrap_Live`)



## Run the test
copy a nano-ledger into the `server_node/Nano` or `server_node/NanoBeta` folder 
<code>./run_test_asc_bootstrap.sh</code>

You can set the following variables
```
env=beta #or live
docker_tag=new-bootstrap-$(date '+%Y%m%d')
build_path=https://github.com/nanocurrency/nano-node/\#new-bootstrap
test_path=./ #current folder
```