#!/bin/bash
#!/bin/bash
#SBATCH --nodes=1
#SABTCH --ntasks=1
#SBATCH --cpus-per-task=14
#SBATCH -p cu
#SBATCH --mem=30G #per node
#SBATCH -w cu01
#SBATCH --job-name=aligning
#SBATCH -o Read_summarization.out
#SBATCH -e Read_summarization.err
#SBATCH --mail-type=END

ref_genome="/home/dongbiao/hanzewen/transcriptome/ref/GRCh38_genomic.fna"
my_index="/home/dongbiao/hanzewen/transcriptome/ref/my_index"
rnaseq_file="/beegfs/dongbiao/han_metagenome_rna/202308测序-诺禾-细胞EVs处理后-转录组/00.CleanData"
output_file="/home/dongbiao/hanzewen/transcriptome/aligning"

# 构建索引文件
subread-buildindex -o ${my_index} ${ref_genome}

# 比对
for i in `less /home/dongbiao/hanzewen/transcriptome/sample.txt`; do
    subread-align -t 0 -i ${my_index} \
                  -r ${rnaseq_file}/${i}/${i}_1.clean.fq.gz \
                  -R ${rnaseq_file}/${i}/${i}_2.clean.fq.gz \
                  -o ${output_file}/${i}_result.bam \
                  -T 14

done

# Read summarization
annotation="/home/dongbiao/hanzewen/transcriptome/ref/genomic.gtf"
featureCounts -a ${annotation} -p --countReadPairs \
              -t exon -g gene_id -C \
              -o /home/dongbiao/hanzewen/transcriptome/counts.txt \
              ${output_file}/27_Ctrl_result.bam ${output_file}/27_P-1_result.bam ${output_file}/27_P-5_result.bam \
              ${output_file}/6_HC-Ctrl_result.bam ${output_file}/6_P-4_result.bam ${output_file}/Ha_HC-1_result.bam  \
              ${output_file}/Ha_P-2_result.bam ${output_file}/27_HC-1_result.bam ${output_file}/27_P-2_result.bam \
              ${output_file}/6_HC-1_result.bam ${output_file}/6_P-1_result.bam ${output_file}/6_P-5_result.bam \
              ${output_file}/Ha_HC-2_result.bam ${output_file}/Ha_P-3_result.bam ${output_file}/27_HC-2_result.bam \
              ${output_file}/27_P-3_result.bam ${output_file}/6_HC-2_result.bam ${output_file}/6_P-2_result.bam \
              ${output_file}/6_P-Ctrl_result.bam ${output_file}/Ha_HC-3_result.bam ${output_file}/Ha_P-4_result.bam \
              ${output_file}/27_HC-3_result.bam ${output_file}/27_P-4_result.bam ${output_file}/6_HC-3_result.bam \
              ${output_file}/6_P-3_result.bam ${output_file}/Ha_Ctrl_result.bam ${output_file}/Ha_P-1_result.bam ${output_file}/Ha_P-5_result.bam \
