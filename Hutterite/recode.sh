#!/bin/bash
#PBS -N plink
#PBS -l walltime=2:00:00:00
#PBS -l nodes=1:ppn=1
#PBS -l mem=15gb
#PBS -e plink.err
#PBS -o plink.log
#PBS -M smozaffari@uchicago.edu

export TMPDIR=$WORKDIR
cd $PBS_O_WORKDIR
export TEMP=$WORKDIR

module load plink

plink --ped everything/qcfiles_rsids_hapmapSNPs.ped --map everything/recode_nors.map --recodeA --recode-allele SNP_recode.txt --out qcfiles_dosage


