#!/usr/bin/perl

use strict;
use warnings;
use feature 'say';

open IN, "Music-QuantifiedCSV.csv" or die "Cannot open file: $!";

# Note	Num	Duration	Value	Note	Num	Duration	Value	Note	Num	Duration	Value	Note	Num	Duration	Value

while (<IN>) {
	my ($sNote, $sNum, $sDur, $sVal,
		$aNote, $aNum, $aDur, $aVal,
		$tNote, $tNum, $tDur, $tVal,
		$bNote, $bNum, $bDur, $sbVal) = split /,/;
		
	next if $sNote eq "Note";	
	
	if ($sNote =~ /Hymn/) {
		# Hymn title
		say $sNote;
	} else {
		#say $sNote;
	}
}

close IN;