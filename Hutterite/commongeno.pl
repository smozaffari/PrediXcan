#!usr/bin/env/perl

use strict;
use warnings;

my %af;
my %one;
my %two;
my %zero;
my $total; 

=head
open (BIM, "/group/ober-resources/users/smozaffari/Prediction/data/test/correctgeno") || die "nope: $!";
my $counter =7;
while (my $line = <BIM>) {
    chomp $line;
    my @line = split "\t", $line;
    my $snp = $line[1];
    if ($af{$snp}) {
	print "duplicated: $snp";
    }
    $af{$snp} = $line[6];   
    $af{$counter} = 2*$line[6];
    $counter++;
}
close (BIM);
=cut

open (PED, "/group/ober-resources/users/smozaffari/Prediction/data/test/qcfiles_rsids_hapmapSNPs_geno0.15.ped") || die "nope: $!";
#open (PED, "/group/ober-resources/users/smozaffari/Prediction/data/test/ped_test") || die "nope: $!";   
open (NEW, ">commongenotype") || die "nope: $!";
while (my $line = <PED>) {
    my @line = split " ", $line;
    my $count2 = 0;
    foreach my $geno (@line) {
	if ($count2 >=6 ){
	    if ($geno =~ /1/) {
		if ($one{$count2}){
		    $one{$count2}++;
		} else {
		    $one{$count2}=1;
		}
	    } elsif ($geno =~ /0/) {
		if ($zero{$count2}) {
		    $zero{$count2}++;
		} else {
		    $zero{$count2}=1;
		}
	    } elsif ($geno =~ /2/) {
		if ($two{$count2}) {
		    $two{$count2}++;
		} else {
		    $two{$count2}=1;
		}
	    }
	}
	$count2++;
    }
    $total = $count2-1;
}


my @snps = '6'..$total;

my %most;

print NEW ("SNP\tmostcommon\n");
foreach my $snp (@snps) {
    if ($zero{$snp}) {
	if ($one{$snp}) {
	    if ($zero{$snp} >= $one{$snp}) {
		$most{$snp} ="0";
		if ($zero{$snp} >= $two{$snp}) {
		    $most{$snp} = "0";
		} elsif ($two{$snp} >= $zero{$snp}){
		    $most{$snp} = "2";
		} 
	    }
	} elsif ($two{$snp}) {
	    if ($zero{$snp} >= $two{$snp} ) {
		$most{$snp} = "0";
	    } else {
		$most{$snp} = "2";
	    }
	}
    } elsif ($one{$snp}) {
	if ($two{$snp}) {
	    if ($one{$snp} > $two{$snp}) {
		$most{$snp} = "1";
	    } else {
		$most{$snp} = "2";
	    }
	} else {
	    $most{$snp} = "1";
	}
    } elsif ($two{$snp}) {
	$most{$snp} ="2";
    }
    print NEW ("$snp\t$most{$snp}\n");
}
close (NEW);
