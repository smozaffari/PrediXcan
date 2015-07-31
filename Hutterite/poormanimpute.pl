#!usr/bin/env/perl

use strict;
use warnings;

my %af;

open (BIM, "/group/ober-resources/users/smozaffari/Prediction/data/test/commongenotype") || die "nope: $!";
while (my $line = <BIM>) {
    chomp $line;
    my @line = split "\t", $line;
    my $snp = $line[0];
    $af{$snp} = $line[1];   
}

#open (PED, "/group/ober-resources/users/smozaffari/Prediction/data/test/qcfiles_rsids_hapmapSNPs_geno0.15.ped") || die "nope: $!";
open (PED, "/group/ober-resources/users/smozaffari/Prediction/data/test/recode_all.raw") || die "nope: $\
!"; 
open (NEW, ">NAfilledin_recode_all.ped") || die "nope: $!";
while (my $line = <PED>) {
    my @line = split " ", $line;
    my $count2 = 0;
    foreach my $geno (@line) {
	if ($count2 >=6 ){
	    if ($geno =~ /NA/) {
		print NEW ("$af{$count2} ");
	    } else {
		print NEW ("$geno ");
	    }
	} else {
	    print NEW ("$geno ");
	}
	$count2++;
    }
    print NEW ("\n");
}

