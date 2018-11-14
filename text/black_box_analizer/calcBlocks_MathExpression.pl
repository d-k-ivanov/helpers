#!/usr/bin/perl
#
#	Calculating variables within blocks of text from BlackBox source (usually "blackbox.txt")
#   Please install Math::Expression module to run this script (cpan -i Math::Expression).
#

use strict;
use warnings;    
use Math::Expression;

die "Unexpected blackbox file.\nUsing: $0 <BlackBox source file>\n" unless @ARGV==1;

my $filename = $ARGV[0];
open(my $FD, '<:encoding(UTF-8)', $filename) || die "Could not open file '$filename' $!";

my $block = "";
my $block_name = "";
my @vars = "";
my $count;
my $var = "";
my @matches = "";

while (<$FD>) 
{
	$_ =~ s/\s+//g;
	
	## Collecting lines
	$block .= $_;
	
	## Check if we have full block 
	if ($block =~ m/-----END(.*?)-----/) 
	{
	  	## Collecting blocks names
	  	@matches = ($block =~ m/-----START(.*?)-----/g);
	  	foreach (@matches) 
		{
			$block_name = $_;
			print "Calculating block: " . $block_name . "\n";			## Comment for Selection.Variable = Value view
			## Collecting variables in certain block
			if ($block =~ m/-----START$block_name-----(.*?)-----END$block_name-----/) 
			{
		  		@vars = split /;/, $1;
		  		@vars = sort @vars;
		  		$count = 0;
		  		foreach(@vars) 
				{
#					print "\t" . $vars[$count] . "\n";
					$vars[$count] =~ m/(.*):=/;
#           		print "\t" . $block_name . "." . $1 . "\t= ";       	## Uncoment for Selection.Variable = Value view
					print "\t" . $1 . "\t= ";								##  Comment for Selection.Variable = Value view
					my $env = Math::Expression->new;
					$vars[$count] =~ m/:=(.*)/;
					$var = $1;
					$var =~ s/:/\//g;
					$var =~ s/[^0-9+\-*\/._()e]//g;
					my $res = $env->Parse($var);
					print $env->Eval($res);
					print "\n";
					$count++;
		  		}
			}
	  	}
	  	## Clearing calculated block
	  	$block = "";
	}
}
close $FD;
