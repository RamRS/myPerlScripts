#!/usr/bin/perl -w
use strict;
use Bio::Seq;
use Bio::SeqIO;
use Bio::SearchIO;
use Bio::SearchIO::Writer::TextResultWriter;

# This script reads a BLAST results file as input and filters out query
# sequences with no hits to the database.

# Define usage
sub usage()
{
	my $usage = "$0 <BLAST_results_file> <output_file_name>";
	print $usage;
}

# Print usage on improper call
if(scalar(@ARGV) != 2)
{
	usage();
}

# Read the BLAST results file
$\="\n";
my $in = shift;
my $out = shift;

# Create BioPerl objects to read BLAST results file and an outputformatter
# object to format output before writing it to output file
my $blast = Bio::SearchIO->new( -file => "$in", -format => 'blast');
my $writer = new Bio::SearchIO::Writer::TextResultWriter();
my $filt = new Bio::SearchIO(-file => ">$out", -writer => $writer);

while (my $result = $blast->next_result())
{
	if($result->num_hits() > 0)
	{
		$filt->write_report($result);
	}
}
