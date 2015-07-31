#!/bin/bash
#PBS -N dosagefiles16
#PBS -l walltime=2:00:00:00
#PBS -l nodes=1:ppn=1
#PBS -l mem=15gb
#PBS -e dosagefiles16.err
#PBS -o dosagefiles16.log
#PBS -M smozaffari@uchicago.edu

export TMPDIR=$WORKDIR
cd $PBS_O_WORKDIR
export TEMP=$WORKDIR

module load R

    Rscript /group/ober-resources/users/smozaffari/Prediction/data/test/PrediXcan/Hutterite/makedosagefiles.R 16


