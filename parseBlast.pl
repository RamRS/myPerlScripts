#!/usr/bin/perl -w
use strict;
use Bio::Seq;
use Bio::SeqIO;
use Bio::SearchIO;
use Bio::SearchIO::Writer::TextResultWriter;
use Getopt::ArgParse;

# This script reads a BLAST results file as input and filters out query
# sequences with no hits to the database.

my $argPr = Getopt::ArgParse->new_parser(
			help => 'remove entries with no hits from BLAST output file',
			description => 'This script reads a BLAST results file as input\
			 and filters out query sequences with no hits to the database. \
			 The results are written in plain text format to output file.'
			);

# Add arguments to capture input FASTA file
$argPr->add_arg('--fasta','-f',required=>1,help=>'input FASTA file');

# Print usage on improper call
if(scalar(@ARGV) != 1)
{
	$argPr->print_usage();
	exit(1);
}

# Read the BLAST results file
$\="\n";
my $argArr = $argPr->parse_args();
my $inFile = $argArr->fasta;
my $out = shift;

# Create BioPerl objects to read BLAST results file and an outputformatter
# object to format output before writing it to output file
my $blast = Bio::SearchIO->new( -file => "$inFile", -format => 'blast');
my $writer = new Bio::SearchIO::Writer::TextResultWriter();
my $filt = new Bio::SearchIO(-file => ">$out", -writer => $writer);

while (my $result = $blast->next_result())
{
	if($result->num_hits() > 0)
	{
		$filt->write_report($result);
	}
}