#!/usr/bin/env/perl

use strict;
use warnings;

my %count;
my %start;
my %stop;

open (BIM, "/group/ober-resources/users/smozaffari/Prediction/data/test/correctgeno") || die "nope: $!";
while (my $line = <BIM>) {
    chomp $line;
    my @line = split "\t", $line;
    foreach my $str ($line[0]) {
	$count {$str}++;
    }
}
$stop{0} = 6;

foreach my $str ( sort {$a <=> $b} keys %count) {
    $start{$str} = $stop{$str-1}+1;
    $stop{$str} = ($count{$str})+ $start{$str}-1;
    print "$str $count{$str}   $start{$str}-$stop{$str}\n";
}
close(BIM);

#open (PED, "/group/ober-resources/users/smozaffari/Prediction/data/test/qcfiles_rsids_hapmapSNPs.ped") || die "nope: $!";
#foreach my $str ( sort {$a <=> $b} keys %count)  {
foreach my $str ( sort keys %count) {
    my $a = $start{$str};
    my $b = $stop{$str};
    my $cmd = ('cut -f'.$a.'-'.$b.' -d" " recode_all.raw_sednoNA > chr'.$str.'.ped');
#    my $cmd = ('cut -f'.$a.'-'.$b.' -d" " qcfiles_rsids_hapmapSNPs.ped > chr'.$str.'.ped \n');
    print ($cmd);
    print ("\n");
    system($cmd);
}
