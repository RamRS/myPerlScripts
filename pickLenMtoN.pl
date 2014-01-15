#!/usr/bin/perl -w
use strict;
use Bio::Seq;
use Bio::SeqIO;
use Getopt::ArgParse;

# This script filters a FASTA file and picks sequences with length between given
# inputs. It also reports the number of sequences that fall below the lower
# bound, above the upper bound and between the two bounds

my $argPr = Getopt::ArgParse->new_parser(
			help => 'pick sequences in the given length range from input \
			FASTA file',
			description => 'This script filters a FASTA file and prints \
			to STDOUT sequences with length between given inputs. It \
			also reports the number of sequences that fall below the \
			lower bound, above the upper bound and between the two bounds.'
			);

# Variables to hold min and max values


# Add arguments to capture input FASTA file, min length and max length
$argPr->add_arg('--fasta','-f',required=>1,help=>'input FASTA file');
$argPr->add_arg('--min','-l',required=>0,default=>0,help=>'minimum length to filter with. Default: 0');
$argPr->add_arg('--max','-u',required=>0,default=>10000,help=>'maximum length to filter with. Default: 10,000');

if(scalar(@ARGV) < 1 or scalar(@ARGV) > 3)
{
	$argPr->print_usage();
	exit(1);
}

# Parse CMD line args to variables
my $argArr = $argPr->parse_args();
my $inFile = $argArr->fasta;
my $minLen = $argArr->min;
my $maxLen = $argArr->max;

# BioPerl objects for the input file
my $inSeqs = Bio::SeqIO->new(-file => "$inFile", -format => 'fasta');

# Counters, all initialized to 0
$_ = 0 for my ($cBelow,$cIn,$cAbove);

# Iterate through the sequences
while ( my $seqRec = $inSeqs->next_seq()) 
{
		# Pick length
        my $seqLen = $seqRec->length();

		# Check length
        if ($seqLen >= $minLen && $seqLen <= $maxLen)
        {
        		# If length is between min and max, write to output
				my $seqId = $seqRec->id();
				print "\n>$seqId";
				print $seqRec->sequence();

                # counter increment for length distribution calculation
                $cIn++;
        }
		elsif ($seqLen < $minLen) { $cBelow++; }
		else { $cAbove++; }
}
# Length distribution reporting
print "Length distribution:\n";
print "Below $minLen:\t$cBelow\n";
print "Between $minLen and $maxLen:\t$cIn\n";
print "Above $maxLen:\t$cAbove\n";