#!/bin/bash
cp /staging/vkhanna7/diploshic.tar.gz ./
cp -r /staging/vkhanna7/exampleApplication ./
cp -r /staging/vkhanna7/rawFVFiles ./
cp -r /staging/vkhanna7/trainingSets ./

tar -xzf packages.tar.gz 
tar -xzf python39.tar.gz
export PATH=$PWD/python/bin:$PATH
export PYTHONPATH=$PWD/packages
export HOME=$PWD
export PATH=$PWD/packages/bin/:$PATH
#rm diploshic.tar.gz



python3 ./packages/bin/diploSHIC train trainingSets/ trainingSets/ bfsModel

python3 ./packages/bin/diploSHIC fvecVcf diploid \
exampleApplication/ag1000g.phase1.ar3.pass.biallelic.3R.vcf.28000000-29000000.gz 3R 53200684 \
rawFVFiles/ag1000g.phase1.ar3.pass.biallelic.3R.vcf.28000000-29000000.gz.diploid.fvec \
--targetPop BFS --sampleToPopFileName exampleApplication/samples_pops.txt --winSize 55000 \
--maskFileName exampleApplication/Anopheles-gambiae-PEST_CHROMOSOMES_AgamP3.accessible.fa.gz
python3 ./packages/bin/diploSHIC predict bfsModel.json bfsModel.weights.hdf5 rawFVFiles/ag1000g.phase1.ar3.pass.biallelic.3R.vcf.28000000-29000000.gz.diploid.fvec mossie.preds
cp -r rawFVFiles /staging/vkhanna7
cp -r trainingSets /staging/vkhanna7

