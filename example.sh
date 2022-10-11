#!/bin/bash
cp /staging/vkhanna7/diploshic.tar.gz ./
cp -r /staging/vkhanna7/exampleApplication ./

tar -xzf packages.tar.gz
tar -xzf python39.tar.gz
export PATH=$PWD/python/bin:$PATH
export PYTHONPATH=$PWD/packages
export HOME=$PWD
export PATH=$PWD/packages/bin/:$PATH
#rm diploshic.tar.gz

# modify this line to run your desired Python script and any other work you need to do
rm diploshic.tar.gz
for f in exampleApplication/*.msOut.gz; do python3 ./packages/bin/diploSHIC fvecSim diploid $f $f.diploid.fvec --totalPhysLen 55000 --maskFileName exampleApplication/Anopheles-gambiae-PEST_CHROMOSOMES_AgamP3.accessible.fa.gz --chrArmsForMasking 3R & done

wait 

mkdir rawFVFiles && mv exampleApplication/*.fvec rawFVFiles/
mkdir trainingSets
python3 ./packages/bin/diploSHIC makeTrainingSets rawFVFiles/neut.msOut.gz.diploid.fvec rawFVFiles/soft \
rawFVFiles/hard 5 0,1,2,3,4,6,7,8,9,10 trainingSets/

python3 ./packages/bin/diploSHIC train trainingSets/ trainingSets/ bfsModel

python3 ./packages/bin/diploSHIC fvecVcf diploid \
exampleApplication/ag1000g.phase1.ar3.pass.biallelic.3R.vcf.28000000-29000000.gz 3R 53200684 \
rawFVFiles/ag1000g.phase1.ar3.pass.biallelic.3R.vcf.28000000-29000000.gz.diploid.fvec \
--targetPop BFS --sampleToPopFileName exampleApplication/samples_pops.txt --winSize 55000 \ 
--maskFileName exampleApplication/Anopheles-gambiae-PEST_CHROMOSOMES_AgamP3.accessible.fa.gz
python3 ./packages/bin/diploSHIC predict bfsModel.json bfsModel.weights.hdf5 rawFVFiles/ag1000g.phase1.ar3.pass.biallelic.3R.vcf.28000000-29000000.gz.diploid.fvec mossie.preds
cp -r rawFVFiles /staging/vkhanna7
cp -r trainingSets /staging/vkhanna7 
