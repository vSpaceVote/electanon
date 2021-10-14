#!/bin/zsh
source ./constants.sh

# NODE_OPTIONS=--max-old-space-size=4096 REPORT_GAS=true VCOUNT=$VOTECOUNT PCOUNT=$PCOUNT npx hardhat --network localhost test --no-compile test/gasanalysis/batched-basic/setup.js > outputs/zk-private-pair/basic/setup-v$VOTECOUNT-p$PCOUNT.txt

N=4
(
for ((i=16; i<$(( (VOTECOUNT/BATCHSIZE) )); i++))
do
   ((p=p%N)); ((p++==0)) && wait
   NODE_OPTIONS=--max-old-space-size=4096 VROUND=$i ADDRESS=$ADDRESS VCOUNT=$VOTECOUNT PCOUNT=$PCOUNT BSIZE=$BATCHSIZE REPORT_GAS=true npx hardhat --network localhost test --no-compile test/gasanalysis/batched-basic/commit-vote.js > outputs/zk-private-pair/basic/commit-vote-v$VOTECOUNT-p$PCOUNT-r$i.txt &
done
)

NODE_OPTIONS=--max-old-space-size=4096 ADDRESS=$ADDRESS VCOUNT=$VOTECOUNT PCOUNT=$PCOUNT REPORT_GAS=true npx hardhat --network localhost test --no-compile test/gasanalysis/batched-basic/reveal-vote.js > outputs/zk-private-pair/basic/reveal-vote-v$VOTECOUNT-p$PCOUNT.txt