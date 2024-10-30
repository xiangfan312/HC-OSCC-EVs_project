#!/bin/bash
#SBATCH -N 1 #1 nodes of ram
#SBATCH -n 28 # 12 cores from each
#SBATCH --contiguous
#SBATCH --mem=30G 
#SBATCH -p cu
#SBATCH -w cu05
#SBATCH --job-name=moving_host
#SBATCH -o moving_host.out
#SBATCH -e moving_host.err
#SBATCH --mail-type=END

module load miniconda/4.9.2 
source activate metawrap-env

for i in `less /home/dongbiao/hanzewen/metagenome/sample.txt`; do
    bowtie2 -x /beegfs/huangxiaochang/database/H.sapiens/GRCh38_noalt_as/GRCh38_noalt_as \
            -p 28 \
            -1 /beegfs/dongbiao/han_metagenome_rna/202307测序-诺禾-SHI培养前后-宏基因组/00.CleanData/${i}/${i}_1.clean.fq.gz \
            -2 /beegfs/dongbiao/han_metagenome_rna/202307测序-诺禾-SHI培养前后-宏基因组/00.CleanData/${i}/${i}_2.clean.fq.gz \
            -S /home/dongbiao/hanzewen/metagenome/temp/${i}.sam 
        
    samtools view -@ 23 -bS /home/dongbiao/hanzewen/metagenome/temp/${i}.sam > /home/dongbiao/hanzewen/metagenome/temp/${i}.bam
    
    samtools view -b -@ 23 -f 12 -F 256 /home/dongbiao/hanzewen/metagenome/temp/${i}.bam > /home/dongbiao/hanzewen/metagenome/temp/${i}_unmapped.bam
    
    samtools sort -@ 23 -n /home/dongbiao/hanzewen/metagenome/temp/${i}_unmapped.bam -o /home/dongbiao/hanzewen/metagenome/temp/${i}_unmapped_sorted.bam
    
    samtools fastq -@ 8 /home/dongbiao/hanzewen/metagenome/temp/${i}_unmapped_sorted.bam \
                 -1 /home/dongbiao/hanzewen/metagenome/move_host/${i}_R1.fastq.gz \
                 -2 /home/dongbiao/hanzewen/metagenome/move_host/${i}_R2.fastq.gz \
                 -n
done

