#!usr/bin/perl

use strict;
use warnings;
use feature 'say';

say "Hello, World!";

open IN, "<data.txt" or die "Cannot open file: $!";

while (<IN>) {
	m#(\d+/\d+/\d+)\t(.*)\t(\d+)\t(\d+)\t(.*)\t(\d+)\t(.*)#;
	my ($date, $event, $open, $sac, $inter, $clos, $ward) = ($1, $2, $3, $4, $5, $6, $7);
	
	say "$date\t$ward\t$open";
	say "$date\t$ward\t$sac";
	say "$date\t$ward\t$inter" unless $inter =~ /\w/;
	say "$date\t$ward\t$clos";
}

say "\n";
close IN;