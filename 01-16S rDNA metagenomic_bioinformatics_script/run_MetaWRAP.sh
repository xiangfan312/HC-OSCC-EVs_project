#!/bin/bash
#SBATCH -N 1 #1 nodes of ram
#SBATCH -n 28 # 12 cores from each
#SBATCH --contiguous
#SBATCH --mem=250G 
#SBATCH -n 28
#SBATCH -p cu
#SBATCH -w cu05
#SBATCH --job-name=metawrap
#SBATCH -o metawrap.out
#SBATCH -e metawrap.err
#SBATCH --mail-type=END

module load miniconda/4.9.2 
source activate metawrap-env

result="/home/dongbiao/hanzewen/metagenome/metawrap/temp"
fastq_file="/home/dongbiao/hanzewen/metagenome/move_host"

### 拼接Assembly
# megahit -t 28 -1 /home/dongbiao/hanzewen/metagenome/all_R1.fastq \
#         -2 /home/dongbiao/hanzewen/metagenome/all_R2.fastq \
#         -o ${result}/megahit 

### 运行三种分箱软件
# metawrap binning -o ${result}/binning -t 28 -a ${result}/megahit/final.contigs.fa \
#       --metabat2 --maxbin2 --concoct ${fastq_file}/*.fastq
      

### Bin提纯
# metawrap bin_refinement \
#   -o ${result}/bin_refinement \
#   -A ${result}/binning/metabat2_bins/ \
#   -B ${result}/binning/maxbin2_bins/ \
#   -C ${result}/binning/concoct_bins/ \
#   -c 50 -x 10 -t 10 -m 2000000 \
#   --skip-checkm


### Bin定量
# 使用salmon计算每个bin在样本中相对丰度
# 需要指定输出文件夹
metawrap quant_bins -b ${result}/drep/dereplicated_genomes -t 28 \
  -o ${result}/bin_quant -a ${result}/megahit/final.contigs.fa ${fastq_file}/*.fastq

 
