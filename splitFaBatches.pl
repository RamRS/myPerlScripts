#!/usr/bin/perl

use Bio::SeqIO;
use Bio::Seq;

# This script splits and input FASTA file into multiple files of
# 'n' sequences each

# Usage to be printed if script is improperly called
if(scalar(@ARGV)<3)
{
	print "Usage: $0 <inFile.fasta> <batchSize> <prefix>\n";
}

# Three mandatory inputs - input fasta file, batch size to split by, 
# output file prefix
my $in=shift;
my $batchSize=shift;
my $prefix=shift;

# SeqIO object to read input FASTA file
my $fa=Bio::SeqIO->new(-file => "$in", -format => 'fasta');

# Counter to count individual sequences
my $count=0;

# Counter to count batches processed
my $batch=1;

# Variable to point to current output file
my $outFile;

# Iterate through sequences in input file
while (my $seq = $fa->next_seq())
{
        # Increment count because we just read a sequence
	$count++;
	# If this is the first sequence of the batch
	if($count % $batchSize == 1)
	{
	        # Create current output file name with supplied prefix and batch counter
		my $fName=$prefix . $batch . ".fa";
		# Create a new SeqIO object with the above output filename
		$outFile = Bio::SeqIO->new(-file => ">$fName", -format => 'fasta');
	}
	# If the current sequence is the last in its batch
	if($count % $batchSize == 0)
	{
	        # We're done with this batch, let's increment the batch count
		$batch++;
	}
	# Write the sequence into its corresponding batch
	$outFile->write_seq($seq);
}

