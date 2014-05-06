#!/usr/bin/perl -w
use strict;
use Bio::Seq;
use Bio::SeqIO;
use Getopt::ArgParse;

# This script reads a multi-fasta file and finds the TWIST1/2 motif CA[AC]NTGN
# in each sequence. It reports the exact sequence and position of each 
# occurrence of the motif

my $argPr = Getopt::ArgParse->new_parser(
                        help => 'find TWIST1/2 motif from all seqeunces in input \
                        FASTA file',
                        description => '# This script reads a multi-fasta file \
                        and finds the TWIST1/2 motif CA[AC]NTGN in each \
                        sequence and its reverse complement. It reports \
                        the exact sequence and position of each occurrence \
                        of the motif. Case sensitive option is available \
                        via the -c parameter.'
                        );

# Add arguments to capture input FASTA file and casing information
$argPr->add_arg('fasta',required=>1,help=>'input FASTA file(s)',nargs => '+');
$argPr->add_arg('-c','--casing',help=>'case sensitivity for when features are distinguishable by case. Possible values: u|l|b',default => 'b');

# Print usage text on improper usage
if (scalar(@ARGV) == 0)
{
	print(scalar(@ARGV));
        $argPr->print_usage();
        exit(1);
}

my $argArr = $argPr->parse_args();

# Capture input files
my @inFiles = $argArr->fasta;
# Capture casing information
my $casing = $argArr->c;

# Iterate thru files
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
		#TO-DO: Add case specific switch for intron exon differentiation
		if($casing eq 'u')
		{
			while ($seq =~ /(CA[AC][ATGC]TG[ATCG])/g)
			{
				# Fetch match position
				my $posn = $-[0]+1;

				# Print Sequence header, matching 7-mer and position as
				# tab separated values
				print("$seqHeader\t$1\t$posn\tOriginal\n");
			}

			# Get reverse complement of sequence
			my $revCom = $seqRec->revcom->seq;
			#if ($casing eq 'u' && $seq eq "\U$seq") { $revCom = uc($revCom); }

			# Find motifs of reverse complement
			while ($revCom =~ /(CA[AC][ATGC]TG[ATCG])/g)
			{
				# Fetch match position
				my $posn = $-[0]+1;

				# Print Sequence header, matching 7-mer and position as
				# tab separated values
				print("$seqHeader\t$1\t$posn\tRevCom\n");
			}
		}
		elsif($casing eq 'l')
		{	
			while ($seq =~ /(ca[ac][atgc]tg[atcg])/g)
			{
				# Fetch match position
				my $posn = $-[0]+1;

				# Print Sequence header, matching 7-mer and position as
				# tab separated values
				print("$seqHeader\t$1\t$posn\tOriginal\n");
			}

			# Get reverse complement of sequence
			my $revCom = $seqRec->revcom->seq;
			#if ($casing eq 'u' && $seq eq "\U$seq") { $revCom = uc($revCom); }

			# Find motifs of reverse complement
			while ($revCom =~ /(ca[ac][atgc]tg[atcg])/g)
			{
				# Fetch match position
				my $posn = $-[0]+1;

				# Print Sequence header, matching 7-mer and position as
				# tab separated values
				print("$seqHeader\t$1\t$posn\tRevCom\n");
			}
		}
		else
		{
		while ($seq =~ /(CA[AC][ATGC]TG[ATCG])/gi)
			{
				# Fetch match position
				my $posn = $-[0]+1;

				# Print Sequence header, matching 7-mer and position as
				# tab separated values
				print("$seqHeader\t$1\t$posn\tOriginal\n");
			}

			# Get reverse complement of sequence
			my $revCom = $seqRec->revcom->seq;
			#if ($casing eq 'u' && $seq eq "\U$seq") { $revCom = uc($revCom); }

			# Find motifs of reverse complement
			while ($revCom =~ /(CA[AC][ATGC]TG[ATCG])/gi)
			{
				# Fetch match position
				my $posn = $-[0]+1;

				# Print Sequence header, matching 7-mer and position as
				# tab separated values
				print("$seqHeader\t$1\t$posn\tRevCom\n");
			}
		}
	}
}