#!/usr/bin/perl
use strict;
use Bio::Seq;
use Bio::SeqIO;
use Getopt::ArgParse;
use File::Basename;

# This script reads a multi-fasta file and splits the input into unique and duplicate
# sequences. Additionally, found duplicates might be written to a separate file

my $argPr = Getopt::ArgParse->new_parser(
			help => 'remove sequence duplicates from FASTA file',
			description => 'This script reads a multi-fasta file and splits the input \
			into unique and duplicate sequences. Additionally, found duplicates might \
			be written to a separate file'
			);
			
# Add arguments to capture input FASTA file and duplicate print flag
$argPr->add_arg('--fasta','-f',required=>1,help=>'input FASTA file');
$argPr->add_arg('--dups','-d',type=>'Bool',help=>'flag to set to save duplicates to a separate file');

# Print usage text on improper usage
if (scalar(@ARGV) < 1 or scalar(@ARGV) > 2)
{
	$argPr->print_usage();
	exit(1);
}

my $argArr = $argPr->parse_args();
my $inFile;

$inFile = $argArr->fasta;
unless (-e $inFile) 
{
	print "Input file does not exist!";
	exit(1);	
}
my ($fileName,$dirPath,$extn)=fileparse($inFile,qr/\.[^.]*/);
my $outFile = "${dirPath}${fileName}_uniq${extn}"; 
print "Writing unique sequences to $outFile";

my $dupFlagOn = $argArr->dups();
my $dupFile;
if ($dupFlagOn)
{
	$dupFile = "${dirPath}${fileName}_dups${extn}";
	print "Writing duplicate sequences to $dupFile";
}

# Open files, use BioPerl to read and write fasta sequences
my $inSeqs = Bio::SeqIO->new(-file => "$inFile", -format => 'fasta' );
my $uniqSeqs = Bio::SeqIO->new(-file => ">$outFile", -format => 'fasta' );

# Define object for duplicate file only if file for duplicates is given as input
my $dupSeqs;
if($dupFlagOn)
{ 
	$dupSeqs = Bio::SeqIO->new(-file => ">$dupFile", -format => 'fasta' ); 
}

# Hash to hold sequences incrementally as we process them
my %seqIdHash;

# Read seqs one-by-one from input
while(my $seqRec=$inSeqs->next_seq())
{
        my $sequence = $seqRec->seq();
		
		# If sequence exists in hash, write entry to dups file
        if(exists $seqIdHash{$sequence} && $dupFlagOn)
        {
        	$dupSeqs->write_seq($seqRec);
        }
        # Else, write seq to uniqs file and add an entry to the hash
        else
        {
        	$uniqSeqs->write_seq($seqRec);
        	$seqIdHash{$seqRec}="Found";
        }
}