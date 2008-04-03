# ================================================================
package Text::Phonetic::DoubleMetaphone;
# ================================================================
use strict;
use warnings;
use utf8;

use base qw(Text::Phonetic);

use Text::DoubleMetaphone qw( double_metaphone );

use vars qw($VERSION);
$VERSION = $Text::Phonetic::VERSION;

# ----------------------------------------------------------------
sub _do_compare
# ----------------------------------------------------------------
{
	my $obj = shift;
	my $result1 = shift;
	my $result2 = shift;

	return Text::Phonetic::_compare_list($result1,$result2);	

	return 0;
}

# -------------------------------------------------------------
sub _do_encode
# -------------------------------------------------------------
{
	my $obj = shift;
	my $string = shift;
	
	 my($code1, $code2) = double_metaphone($string);
	 return [$code1,$code2];
}

1;

=pod

=head1 NAME

Text::Phonetic::DoubleMetaphone - DoubleMetaphone algorithm

=head1 DESCRIPTION

The Double Metaphone search algorithm is a phonetic algorithm written by 
Lawrence Philips and is the second generation of his Metaphone algorithm.
(Wikipedia, 2007)

The Result is always an array ref containing two (mostly, but not always)
identical elements.

This module is a thin wrapper arround L<Text::DoubleMetaphone>.

=head1 AUTHOR

    Maroš Kollár
    CPAN ID: MAROS
    maros [at] k-1.com
    http://www.k-1.com

=head1 COPYRIGHT

Text::Phonetic::DoubleMetaphone is Copyright (c) 2006,2007 Maroš. Kollár.
All rights reserved.

This program is free software; you can redistribute
it and/or modify it under the same terms as Perl itself.

The full text of the license can be found in the
LICENSE file included with this module.

=head1 SEE ALSO

Description of the algorithm can be found at 
L<http://en.wikipedia.org/wiki/Double_Metaphone>

L<Text::DoubleMetaphone>

=cut
