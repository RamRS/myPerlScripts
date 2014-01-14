#!/usr/bin/perl -w
use strict;
use Bio::Seq;
use Bio::SeqIO;

# This script filters a FASTA file and picks sequences with length between given
# inputs. It also reports the number of sequences that fall below the lower
# bound, above the upper bound and between the two bounds

# Three required inputs - input file with all sequences, min length and max 
# length. Output written to STDOUT
my $inFile = shift; 

# Variables to hold min and max values
my $minLen = shift;
my $maxLen = shift;

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
	elsif ($seqLen < $minLen) $cBelow++
	else $cAbove++
}
# Length distribution reporting
print "Length distribution:\n"
print "Below $minLen:\t$cBelow\n";
print "Between $minLen and $maxLen:\t$cIn\n";
print "Above $maxLen:\t$cAbove\n";
