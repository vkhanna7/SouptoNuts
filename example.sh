#!/bin/bash
set -e

cp /staging/vkhanna7/diploshic.tar.gz ./
cp -r /staging/vkhanna7/exampleApplication ./

ENVNAME=diploshic
ENVDIR=$ENVNAME
mkdir $ENVDIR
export PATH
tar -xzf $ENVNAME.tar.gz -C $ENVDIR
. $ENVDIR/bin/activate

# modify this line to run your desired Python script and any other work you need to do

for f in exampleApplication/*.msOut.gz; do diploSHIC fvecSim diploid $f $f.diploid.fvec --totalPhysLen 55000 --maskFileName exampleApplication/Anopheles-gambiae-PEST_CHROMOSOMES_AgamP3.accessible.fa.gz --chrArmsForMasking 3R & done

mkdir rawFVFiles && mv exampleApplication/*.fvec rawFVFiles/
mkdir trainingSets
diploSHIC makeTrainingSets rawFVFiles/neut.msOut.gz.diploid.fvec rawFVFiles/soft \
rawFVFiles/hard 5 0,1,2,3,4,6,7,8,9,10 trainingSets/

diploSHIC train trainingSets/ trainingSets/ bfsModel

cp -r rawFVFiles /staging/vkhanna7
cp -r trainingSets /staging/vkhanna7 
