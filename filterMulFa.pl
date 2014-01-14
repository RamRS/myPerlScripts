#!/usr/bin/perl
use strict;
use Bio::Seq;
use Bio::SeqIO;

# This script reads a FASTA file with multiple sequences, a text file with a list 
# of IDs and picks from the FASTA file sequences that have an ID match in the ID
# file. These sequences are output to STDOUT

# Inputs - 2 mandatory - FASTA file with input sequences and text file with IDs of 
# sequences to be picked
my $inFile=shift;
my $ids=shift;


# Open files, use BioPerl to create object to read FASTA file and read all IDs
# into an array
my $inSeqs = Bio::SeqIO->new(-file => "$inFile", -format => 'fasta' );
open ID, $ids or die "Could not open filter file";
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
