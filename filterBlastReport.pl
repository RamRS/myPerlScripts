#!/usr/bin/perl -w
use strict;
use Bio::Seq;
use Bio::SeqIO;
use Bio::SearchIO;
use Bio::SearchIO::Writer::TextResultWriter;
use Getopt::ArgParse;
use File::Basename;

# This script reads a BLAST results file as input and filters out query
# sequences with no hits to the database.

my $argPr = Getopt::ArgParse->new_parser(
			help => 'remove entries with no hits from BLAST output file',
			description => 'This script reads a BLAST results file as input\
			 and filters out query sequences with no hits to the database. \
			 The results are written in plain text format to output file.'
			);

# Add arguments to capture input FASTA file
$argPr->add_arg('--in','-i',required=>1,help=>'input BLAST results file');

# Read the BLAST results file
$\="\n";
my $argArr = $argPr->parse_args();
my $inFile = $argArr->in;

# Determine output file to write filtered results to
my ($fileName,$dirPath,$extn)=fileparse($inFile,qr/\.[^.]*/);
my $outFile = "${dirPath}${fileName}_filtered.txt";

# Check for input file existence, quit otherwise
unless (-e $inFile) 
{
	print "Input BLAST file does not exist!";
	exit(1);	
}
print "Writing filtered BLAST results to $outFile";

# Create BioPerl objects to read BLAST results file and an outputformatter
# object to format output before writing it to output file
my $blast = Bio::SearchIO->new( -file => "$inFile", -format => 'blast');
my $writer = new Bio::SearchIO::Writer::TextResultWriter();
my $filt = new Bio::SearchIO(-file => ">$outFile", -writer => $writer);

while (my $result = $blast->next_result())
{
	if($result->num_hits() > 0)
	{
		$filt->write_report($result);
	}
}
