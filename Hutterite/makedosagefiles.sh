#!/bin/bash
#PBS -N dosagefiles
#PBS -l walltime=2:00:00:00
#PBS -l nodes=1:ppn=1
#PBS -l mem=15gb
#PBS -e dosagefiles.err
#PBS -o dosagefiles.log
#PBS -M smozaffari@uchicago.edu

export TMPDIR=$WORKDIR
cd $PBS_O_WORKDIR
export TEMP=$WORKDIR

module load R

    Rscript /group/ober-resources/users/smozaffari/Prediction/data/test/PrediXcan/Hutterite/makedosagefiles.R 1




