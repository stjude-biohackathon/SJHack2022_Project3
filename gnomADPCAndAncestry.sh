set -eu

# data download:
# gnomAD loadings and random forest classifier
# TODO:
# 
# install before use
# pip install /home/wchen1/biohackathon/hail/gnomad-0.6.1-py3-none-any.whl
# for gnomAD v2 GRCh37, need to install the following:
# pip install -U scikit-learn==0.21.3
# for gnomAD v3 GRCh38
# pip install -U scikit-learn

# set up hail in the HPC cluster
module load openblas/0.3.17
module load lapack/open64/64/3.7.0
module load python/test/3.8.10
module load java/1.8.0_301
export PYSPARK_SUBMIT_ARGS="--driver-memory 400G pyspark-shell"
export LD_PRELOAD=/hpcf/authorized_apps/rhel7_apps/openblas/install/develop/0.3.17/lib/libopenblas.so

# run python script to extract PCs and gnomAD ancestry
vcf=$1
build=$2
outputFile=$3
python3 ./code/gnomADPCAndAncestry.py ${vcf} ${build} ${outputFile}
