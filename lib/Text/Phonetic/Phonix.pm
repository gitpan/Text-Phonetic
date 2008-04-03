# ================================================================
package Text::Phonetic::Phonix;
# ================================================================
use strict;
use warnings;
use utf8;

use base qw(Text::Phonetic);

use vars qw($VERSION @RULES $VOVEL $CONSONANT @VALUES);
$VERSION = $Text::Phonetic::VERSION;

$VOVEL = '[AEIOU]';
$CONSONANT = '[BCDFGHJLMNPQRSTVXZXY]';

@VALUES = (
	[qr/[BP]/,1],
	[qr/[CGJKQ]/,2],
	[qr/[DT]/,3],
	[qr/L/,4],
	[qr/[MN]/,5],
	[qr/R/,6],
	[qr/[FV]/,7],
	[qr/[SXZ]/,8],
);

@RULES = (
	[qr/DG/,'G'],
	[qr/C([OAU])/,'K1'],
	[qr/C[YI]/,'SI'],
	[qr/CE/,'SE'],
	[qr/^CL($VOVEL)/,'KL1'],
	[qr/CK/,'K'],
	[qr/[GJ]C$/,'K'],
	[qr/^CH?R($VOVEL)/,'KR1'],
	[qr/^WR/,'R'],
	[qr/NC/,'NK'],
	[qr/CT/,'KT'],
	[qr/PH/,'F'],
	[qr/SCH/,'SH'],
	
	[qr/BTL/,'TL'],
	[qr/GHT/,'T'],
	[qr/AUGH/,'ARF'],
	[qr/(\w)LJ($VOVEL)/,'1LD2'],
	[qr/LOUGH/,'LOW'],
	[qr/^Q/,'KW'],
	[qr/^KN/,'N'],
	[qr/GN$/,'N'],
	[qr/GHN/,'N'],
	[qr/GNE$/,'N'],
	[qr/GHNE/,'NE'],
	[qr/GNES$/,'NS'],
	[qr/^GN/,'N'],
	[qr/(\w)GN($CONSONANT)/,'1N2'],
	[qr/^PS/,'S'],
	[qr/^PT/,'T'],
	[qr/^CZ/,'C'],
	[qr/($VOVEL)WZ(\w)/,'1Z2'],
	[qr/(\w)CZ(\w)/,'1CZ2'],
	
	[qr/LZ/,'LSH'],
	[qr/RZ/,'RSH'],
	[qr/(\w)Z($VOVEL)/,'1S2'],
	[qr/ZZ/,'TS'],
	[qr/($CONSONANT)Z(\w)/,'1TS2'],
	[qr/HROUGH/,'REW'],
	[qr/OUGH/,'OF'],
	[qr/($VOVEL)Q($VOVEL)/,'1KW2'],
	[qr/($VOVEL)Q($VOVEL)/,'1Y2'],
	[qr/^YJ($VOVEL)/,'Y1'],
	[qr/^GH/,'G'],
	[qr/($VOVEL)GH$/,'1E'],
	[qr/^CY/,'S'],
	[qr/NX/,'NKS'],
	[qr/^PF/,'F'],
	[qr/DT$/,'T'],
	[qr/(T|D)L$/,'1IL'],
	[qr/YTH/,'ITH'],
	
	[qr/^TS?J($VOVEL)/,'CH1'],
	[qr/^TS($VOVEL)/,'T1'],
	[qr/TCH/,'CHE'],
	[qr/^($VOVEL)WSK/,'1VSIKE'],
	[qr/^[PM]N($VOVEL)/,'N1'],
	[qr/($VOVEL)STL/,'1SL'], ## ????
	[qr/TNT$/,'ENT'],
	[qr/EAUX$/,'OH'],
	[qr/EXCI/,'ECS'],
	[qr/X/,'ECS'],
	[qr/NED$/,'ND'],
	[qr/JR/,'DR'],
	[qr/EE$/,'EA'],
	[qr/ZS/,'S'],
	[qr/($VOVEL)H?R($CONSONANT)/,'1AH2'],
	[qr/($VOVEL)HR$/,'1AH'],
	
	[qr/RE$/,'AR'],
	[qr/($VOVEL)R$/,'1AH'],
	[qr/LLE/,'LE'],
	[qr/($CONSONANT)LE(S?)$/,'1ILE2'],
	[qr/E$/,''],
	[qr/ES$/,'S'],
	[qr/($VOVEL)SS/,'1AS'],
	[qr/($VOVEL)MB$/,'1M'],
	[qr/MPTS/,'MPS'],
	[qr/MPS/,'MS'],
	[qr/MPT/,'MT'],

);

# ----------------------------------------------------------------
sub _do_compare
# ----------------------------------------------------------------
{
	my $obj = shift;
	my $result1 = shift;
	my $result2 = shift;

	# Main values are different
	return 0 unless ($result1->[0] eq $result2->[0]);
	
	# Ending values the same
	return 75 if ($result1->[1] eq $result2->[1]);
	
	# Ending values differ in length, and are same for the shorter
	my $length1 = length $result1->[1];
	my $length2 = length $result2->[1];
	if ($length1 > $length2
		&& $length1 - $length2 == 1) {
		return 50 if (substr($result1->[1],0,$length2) eq $result2->[1]);
	 }elsif ($length2 > $length1
		&& $length2 - $length1 == 1) {	
		return 50 if (substr($result2->[1],0,$length1) eq $result1->[1]);
	}
	
	return 25;
}

# -------------------------------------------------------------
sub _do_encode
# -------------------------------------------------------------
{
	my $obj = shift;
	my $string = shift;
	
	$string = uc($string);
	$string =~ tr/A-Z//cd;
	
	# RULE 1
	foreach my $rule (@RULES) {
		my $regexp = $rule->[0];
		my $replace = $rule->[1];
		$string =~ s/$regexp/_replace($replace,$1,$2)/ge;
	}
	
	# RULE 2
	$string =~ s/^([A-Z])//;
	my $first_char = $1;
	# RULE 3
	$first_char = 'v' if $first_char =~ m/$VOVEL/ || $first_char eq 'H';
	# RULE 4
	$string =~ s/ES$/S/;
	# RULE 5
	$string =~ s/([AIOUY])$/$1E/;
	# RULE 6
	$string =~ s/\w$//;
	# RULE 7-8
	$string =~ s/([AEIOUY])([A-Z]+)$/$1/;
	my $last_string =$2;
	# RULE 9-11
	$string = _transform($string);
	# RULE 12
	$string = $first_char.$string;
	# RULE 13
	$last_string = _transform($last_string);
	
	$string .= $last_string;
	$string .= '0'  x (8-length $string);
	$string = substr($string,0,8);
	
	#return [$string,$last_string];
	return $string;
}

# -------------------------------------------------------------
sub _transform
# -------------------------------------------------------------
{
	my $string = shift;
	return unless defined $string;
	
	# RULE 9
	$string =~ s/([AEIOUYHW])//g;
	# RULE 10
	$string =~ s/($CONSONANT+)\1/$1/g;
	# RULE 11
	foreach my $value (@VALUES) {
		my $regexp = $value->[0];
		$string =~ s/$regexp/$value->[1]/g;
	}
	return $string;
}

# -------------------------------------------------------------
sub _replace
# -------------------------------------------------------------
{
	my $replace = shift;
	my $pos1 = shift;
	my $pos2 = shift;
	
	$replace =~ s/1/$pos1/ if (defined $pos1);
	$replace =~ s/2/$pos2/ if (defined $pos2);
	return $replace;
}

1;

=pod

=head1 NAME

Text::Phonetic::Phonix - Phonix algorithm

=head1 WARNING

Since I have only found ambiguous sources about this algorithm this
implementation doesn't behave fully according to the few test cases I was able
to find (currently three out of 17 test cases fail). I'm looking for more and 
better specifications of this algorithm. Until then this module should be 
regarded as EXPERIMENTAL.

=head1 DESCRIPTION

Phonix is a phonetic algorithm similar to Soundex.

The algorithm always returns an array reference with two elements. The fist
element represents the sound of the name without the ending sound, and the 
second element represents the ending sound. To get a full representation of 
the name you need to concat the two elements.

If you want to compare two names the following rules apply:

=over

=item * If the ending sound values of an entered name and a retrieved name are 
the same, the retrieved name is a LIKELY candidate.

=item * If an entered name has an ending-sound value, and the retrieved name 
does not, then the retrieved name is a LEAST-LIKELY candidate.

=item * If the two ending-sound values are the same for the length of the 
shorter, and the difference in length between the two ending-sound is one 
digit only, then the retrieved name isa LESS-LIKELY candidate.

=item * All other cases result in LEAST-LIKELY candidates.

=back

=head1 AUTHOR

    Maroš Kollár
    CPAN ID: MAROS
    maros [at] k-1.com
    http://www.k-1.com

=head1 COPYRIGHT

Text::Phonetic::Phonix is Copyright (c) 2006,2007 Maroš. Kollár.
All rights reserved.

This program is free software; you can redistribute
it and/or modify it under the same terms as Perl itself.

The full text of the license can be found in the
LICENSE file included with this module.

=head1 SEE ALSO


=cut
