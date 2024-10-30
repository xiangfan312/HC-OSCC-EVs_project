#!/bin/bash
#SBATCH -N 1 #1 nodes of ram
#SBATCH -n 28 # 12 cores from each
#SBATCH --contiguous
#SBATCH --mem=250G 
#SBATCH -n 28
#SBATCH -p cu
#SBATCH -w cu06
#SBATCH --job-name=annotation
#SBATCH -o annotation.out
#SBATCH -e annotation.err
#SBATCH --mail-type=END

module load miniconda/4.9.2 
source activate mpa

bin_file="/home/dongbiao/hanzewen/metagenome/metawrap/temp/drep/dereplicated_genomes"
annotation_file="/home/dongbiao/hanzewen/metagenome/annotation"
refseq_masher matches -o ${annotation_file} ${bin_file}/*.fa

