#!/usr/bin/perl -w
use strict;
use Bio::Seq;
use Bio::SeqIO;
use Getopt::ArgParse;

# This script reads a multi-fasta file and finds the TWIST1/2 motif CA[AC]NTGN in 
# each sequence. It reports the exact sequence and position of each occurrence
# of the motif

my $argPr = Getopt::ArgParse->new_parser(
                        help => 'find TWIST1/2 motif from all seqeunces in input FASTA file',
                        description => '# This script reads a multi-fasta file and finds the \
			TWIST1/2 motif CA[AC]NTGN in each sequence. It reports the exact \
			sequence and position of each occurrence of the motif.'
                        );

# Add arguments to capture input FASTA file
$argPr->add_arg('fasta',required=>1,help=>'input FASTA file', nargs => '+');

# Print usage text on improper usage
if (scalar(@ARGV) != 1)
{
	print(scalar(@ARGV));
        $argPr->print_usage();
        exit(1);
}

my $argArr = $argPr->parse_args();

my @inFiles = $argArr->fasta;

foreach my $inFile(@inFiles)
{
	# Error out if input file does not exist
	unless (-e $inFile)
	{
        	print "Input file $inFile does not exist!";
        	
	}

	my $inSeqs = Bio::SeqIO->new("-format" => "fasta", "-file" => "$inFile");

	# Iterate thru sequences
	while (my $seqRec = $inSeqs->next_seq())
	{
		# Pick sequence part for RegEx motif matching
		my $seq = $seqRec->seq;

		# Extract sequence header
		my $seqHeader = $seqRec->id . " " . $seqRec->desc;
	
		# Iterate thru motif matches
		while ($seq =~ /(CA[AC][ATGC]TG[ATCG])/gi)
		{
			# Print Sequence header, matching 7-mer and position as
			# tab separated values
			print("$seqHeader\t$1\t$-[0]\n");
		}
	}
}
