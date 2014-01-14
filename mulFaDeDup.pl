#!/usr/bin/perl -w
use strict;
use Bio::Seq;
use Bio::SeqIO;

# This script reads a multi-fasta file and splits the input into unique and duplicate
# sequences. Additionally, found duplicates might be written to a separate file

# Usage text
sub usage{
	my $usageText=
	"This script reads a multi-fasta file and removes duplicate sequences 
Usage:
	$0 input_fasta_file file_to_write_uniq_seqs [file_to_write_dup_seqs]";
	print $usageText;
}

# Print usage on improper call
if (scalar(@ARGV) < 2 or scalar(@ARGV) > 3)
{
	usage();
}

# Files - 2 mandatory (input file and output filename) and 1 optional file to hold any 
# duplicate sequences found
my $inFile=shift;
my $outFile=shift;
my $dupFile=shift;

# Open files, use BioPerl to read and write fasta sequences
my $inSeqs = Bio::SeqIO->new(-file => "$inFile", -format => 'fasta' );
my $uniqSeqs = Bio::SeqIO->new(-file => ">$outFile", -format => 'fasta' );

# Define object for duplicate file only if file for duplicates is given as input
my $dupSeqs;
if(defined $dupFile)
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
        if(exists $seqIdHash{$sequence} && defined $dupFile)
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
