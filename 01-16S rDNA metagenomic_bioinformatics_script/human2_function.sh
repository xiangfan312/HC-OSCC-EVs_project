#!/bin/bash
#SBATCH -N 1 #1 nodes of ram
#SBATCH -n 20 # 12 cores from each
#SBATCH --contiguous
#SBATCH --mem=100G 
#SBATCH -p cu
#SBATCH -w cu02
#SBATCH --job-name=humann3
#SBATCH -o humann3.out
#SBATCH -e humann3.err
#SBATCH --mail-type=END

module load miniconda/4.9.2 
source activate mpa

data_dir="/home/dongbiao/hanzewen/metagenome/temp/concat"
output_dir="/home/dongbiao/hanzewen/metagenome/humann"

for i in `ls $data_dir | awk -F '.' '{print $1}'`;do
  humann --input $data_dir/${i}.fq --output $output_dir --threads 20;
done

