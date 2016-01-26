# PrediXcan_Hutterites

Extract SNPs with rsids from PRIMAL qc data

    plink  --bfile /group/ober-resources/resources/Hutterites/PRIMAL/data-sets/qc/qc --extract rsSNPlist.txt --out qcfiles_rsids --recode 12

CGI SNPs in rs ids:

    qcfiles_rsids_SNPs.map qcfiles_rsids_SNPs.ped

Extract hapmapSnps for PrediXcan:

    plink --extract hapmapSnpsCEU.list --file new2 --out qcfiles_rsids_hapmapSNPs --recode 12    
    
Call rate QC:

    plink --file qcfiles_rsids_hapmapSNPs --geno 0.15 --out qcfiles_rsids_hapmapSNPs_geno0.15 --recode 12

Unique SNP identifiers by combining rs id + location

    plink --file qcfiles_rsids_hapmapSNPs_geno0.15 --out recode_all --recode A --recode-allele correct_recode.txt
    
Replace NA's with most common genotype file
* get most common genotype : `commong.sh` runs `commongeno.pl`
* replace NA's: `impute.sh` runs `poormanimpute.pl` to file called: `NAfilledin_recode_all.ped`

Separate dosage file by chromosome

    bychrom.sh
  
Separate SNPinfo.bim and list by chromosome:

    bychrom_list.pl

Make dosage files:

    makedosagefiles.R

Run PrediXcan:

    runPrediXcan.sh
