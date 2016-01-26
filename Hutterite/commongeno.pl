#!usr/bin/env/perl

use strict;
use warnings;

my %af;
my %one;
my %two;
my %zero;
my $total; 

open (PED, "/group/ober-resources/users/smozaffari/Prediction/data/test/recode_all.raw") || die "nope: $!";

#open (PED, "/group/ober-resources/users/smozaffari/Prediction/data/test/ped_test") || die "nope: $!";   #test file

my $first = <PED>; #skip first line;
#open (NEW, ">cgtest") || die "nope: $!";
open (NEW, ">commongenotype2") || die "nope: $!";
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
    if ($zero{$snp}) {       #if 0 exists
	if ($one{$snp}) {    #if 1 exists
	    if ($zero{$snp} >= $one{$snp}) { #if 0>1 give it to 0
		$most{$snp} = "0";             
	    } else {                         #if not it is 1
		$most{$snp} = "1";
	    }
	    if ($two{$snp}) {  #if 2 exists
		if ($zero{$snp} >= $two{$snp}) {  #if 0>2 it is 0
		    $most{$snp} = "0";
		} elsif ($two{$snp} >= $zero{$snp}){   #if 2 >0 it is 2
		    $most{$snp} = "2";
		} elsif ($one{$snp} >= $two{$snp}) {   #if 1>2 it is 1
		    $most{$snp} = "1";
		} elsif ($two{$snp} >= $one{$snp}) {  #if 2>1 it is 2
		    $most{$snp} = "2";
		}
	    }
	} elsif ($two{$snp}) {  # if 1 doesn't exist and 2 does
	    if ($zero{$snp} >= $two{$snp} ) { #if 0>2 then it is 0
		$most{$snp} = "0";
	    } elsif ($zero{$snp} < $two{$snp}) { #if 0<2 then it is 2
		$most{$snp} = "2"; 
	    }
	} else {
	    $most{$snp} = "0";
	}
    } elsif ($one{$snp}) { #if 0 doesn't exist but 1 does
	if ($two{$snp}) {  #if 2 also exists
	    if ($one{$snp} >= $two{$snp}) { #if 1 > 2 it is 1
		$most{$snp} = "1";
	    } elsif ($one{$snp} < $two{$snp}) { #if 1 < 2 then it is 2
		$most{$snp} = "2";
	    }
	} else { #if 0 and 2 doesn't exist then it is 1
	    $most{$snp} = "1";
	}
    } elsif ($two{$snp}) { #if 0 and 1 doesn't exist then it is 2
	$most{$snp} ="2";
    }
    print NEW ("$snp\t$most{$snp}\n");
}
close (NEW);
