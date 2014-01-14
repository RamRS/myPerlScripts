#!/usr/bin/perl
use strict;
use Bio::Seq;
use Bio::SeqIO;
use Getopt::ArgParse;

# This script reads a FASTA file with multiple sequences, a text file with a list 
# of IDs and picks from the FASTA file sequences that have an ID match in the ID
# file. These sequences are output to STDOUT

my $argPr = Getopt::ArgParse->new_parser(
			help => 'extract subset of sequences from FASTA file',
			description => 'This script reads a FASTA file with multiple \
			sequences, a text file with a list of IDs and picks from the \
			FASTA file sequences that have an ID match in the IDs file. \
			These sequences are then printed to STDOUT'
			);

# Add arguments to capture input FASTA file and IDs file
$argPr->add_arg('--fasta','-f',required=>1,help=>'input FASTA file');
$argPr->add_arg('--ids','-i',required=>1,help=>'file with IDs of sequences to be picked');

# Print usage text on improper usage
if (scalar(@ARGV) != 2)
{
	$argPr->print_usage();
	exit(1);
}

# Store input arguments into variables
my $argArr = $argPr->parse_args();
my $inFile = $argArr->fasta;
my $idsFile = $argArr->ids;

# Open files, use BioPerl to create object to read FASTA file and read all IDs
# into an array
my $inSeqs = Bio::SeqIO->new(-file => "$inFile", -format => 'fasta' );
open ID, $idsFile or die "Could not open filter file";
my @idArr = <ID>;
close ID;
chomp @idArr;

# Map IDs to a hash for easier searching
my %hSeqId = map { $_ => 1 } @idArr; 

# Read seqs from input
while(my $seqRec=$inSeqs->next_seq())
{
	# If the ID matches in the hash
	my $seqId = $seqRec->id();
	if (exists($hSeqId{$seqId}))
	{
		# Write sequence record to STDOUT
		print "\n>$seqId";
		print $seqRec->sequence();
	}
}
