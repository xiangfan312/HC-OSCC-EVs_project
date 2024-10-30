#!/bin/bash
#SBATCH -N 1 #1 nodes of ram
#SBATCH -n 28 # 12 cores from each
#SBATCH --contiguous
#SBATCH --mem=250G 
#SBATCH -n 28
#SBATCH -p cu
#SBATCH -w cu06
#SBATCH --job-name=dRep
#SBATCH -o dRep.out
#SBATCH -e dRep.err
#SBATCH --mail-type=END

module load miniconda/4.9.2 
source activate mpa

bin_file="/home/dongbiao/hanzewen/metagenome/metawrap/temp/binning"
dRep dereplicate /home/dongbiao/hanzewen/metagenome/metawrap/temp/drep \
                 -g ${bin_file}/bin.list --S_algorithm fastANI --multiround_primary_clustering \
                 -ms 10000 -pa 0.9 -sa 0.95 -nc 0.50 -cm larger -p 28 