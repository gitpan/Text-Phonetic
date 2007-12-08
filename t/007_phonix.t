# -*- perl -*-

# t/007_phonix.t - phonix test 

use Test::More tests=>18;
use utf8;

use Text::Phonetic::Phonix;

require "t/global.pl";

my $phonix = Text::Phonetic::Phonix->new();

my %TEST = (
	'Müller'	=> M4000000,
	schmidt		=> S5300000,
	schneider	=> S5300000,
	fischer		=> F8000000,
	weber		=> 'W1000000',
	meyer		=> M0000000,
	wagner		=> 'W2500000',
	schulz		=> S4800000,
	becker		=> B2000000,
	hoffmann	=> 'v7550000',
	schäfer		=> S7000000,
	computer	=> K5130000,
	computers	=> K5138000,
	pfeifer		=> F7000000,
	pfeiffer	=> F7000000,
	knight		=> N3000000,
	night		=> N3000000,
);


isa_ok($phonix,'Text::Phonetic::Phonix');

SKIP: {
	skip 'TODO: Algorithm does not behave as excpected due to ambiguous documentation/explanation.', 17;
	
	while (my($key,$value) = each(%TEST)) {
		test_encode($phonix,$key,$value);
	}
};
