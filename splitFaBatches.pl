#!/usr/bin/perl

use Bio::SeqIO;
use Bio::Seq;
use Getopt::ArgParse;

# This script splits and input FASTA file into multiple files of
# n sequences each. The last split might typically contain less
# than n sequences.

my $argPr = Getopt::ArgParse->new_parser(
			help => 'split FASTA file into multiple FASTA files of n sequences each',
			description => 'This script splits and input FASTA file into multiple \
			files of n sequences each. The last split might typically contain \
			less than n sequences.'
			);
			
# Add arguments to capture input FASTA file, batch size and output prefix
$argPr->add_arg('--fasta','-f',required=>1,help=>'input FASTA file');
$argPr->add_arg('--bsize','-s',required=>1,help=>'Required number of sequences in output files (batch size)');
$argPr->add_arg('--prefix','-p',required=>0,default=>'out_',help=>'Prefix for output files. Output files will follow the format prefix_XX.fa Default: out_XX.fa');

# Usage to be printed if script is improperly called
if(scalar(@ARGV)<2 or scalar(@ARGV)>3)
{
	$argPr->print_usage();
	exit(1);
}

# Parse CMD line args to variables
my $argArr = $argPr->parse_args();
my $inFile = $argArr->fasta;
my $batchSize=$argArr->bsize;
my $prefix=$argArr->prefix;

# Check for input file existence, quit gracefully otherwise
unless (-e $inFile) 
{
	print "Input FASTA file does not exist!";
	exit(1);	
}

# SeqIO object to read input FASTA file
my $fa=Bio::SeqIO->new(-file => "$inFile", -format => 'fasta');

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
		print "Writing sequence # $count to file $outFile\n";
		$outFile->write_seq($seq);
}