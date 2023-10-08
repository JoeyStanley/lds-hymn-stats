#!usr/bin/perl

use strict;
use warnings;
use feature 'say';

use Spreadsheet::ParseExcel;

my @colNames = qw(sNote sNum sDur sValue aNote aNum aDur aValue tNote tNum tDur tValue bNote bNum bDur bValue);
 
# Read in the file    
my $parser   = Spreadsheet::ParseExcel->new();
my $workbook = $parser->parse("/Users/joeystanley/Desktop/Projects/Hymns/Music-Quantified-perl.xls");
die $parser->error(), ".\n" unless defined $workbook;
my $music = $workbook->worksheet('Raw Data');

# Get the row and cols
my ( $row_min, $row_max ) = $music->row_range();
my ( $col_min, $col_max ) = $music->col_range();
 
for my $row ( $row_min .. $row_max ) {

	my $titleRow = 0;
	my $sTrans   = 0;
	my $aTrans   = 0;
	my $tTrans   = 0;
	my $bTrans   = 0;

	my $cell = $music->get_cell($row,0);
	next unless $cell;

	my $text = $cell->value();

	say "\nRow: $row";
	say "TitleRow: $titleRow";
		
	# If it's a title
	if ($text =~ m/Hymn (\d+): (.*)/) {			
		my $num = $1;
		my $title = $2;
		$titleRow = $row;
		
		say "Row: $row";
		say "Title: $2";
		say "Number: $1";
		
	# If it's the transposition line
	} elsif ($row == $titleRow+1) {
		$sTrans = $music->get_cell($row,0)->value;
		$aTrans = $music->get_cell($row,4)->value;
		$tTrans = $music->get_cell($row,8)->value;
		$bTrans = $music->get_cell($row,12)->value;
		
		say "S Transposition: $sTrans";
		say "A Transposition: $aTrans";
		say "T Transposition: $tTrans";
		say "B Transposition: $bTrans";
	}

	#for my $col ( $col_min .. $col_max ) {	
	#}
	
	last if $row > 50;
}
