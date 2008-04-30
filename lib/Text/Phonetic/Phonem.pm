# ================================================================
package Text::Phonetic::Phonem;
# ================================================================
use strict;
use warnings;
use utf8;

use base qw(Text::Phonetic);

use vars qw($VERSION %DOUBLECHARS);
$VERSION = $Text::Phonetic::VERSION;

%DOUBLECHARS = (
    SC  =>'C', 
    SZ  =>'C', 
    CZ  =>'C', 
    TZ  =>'C', 
    SZ  =>'C', 
    TS  =>'C',
    KS  =>'X', 
    PF  =>'V', 
    QU  =>'KW', 
    PH  =>'V', 
    UE  =>'Y', 
    AE  =>'E',
    OE  =>'Ö', 
    EI  =>'AY', 
    EY  =>'AY', 
    EU  =>'OY', 
    AU  =>'A§', 
    OU  =>'§ '
);

# -------------------------------------------------------------
sub _do_encode
# -------------------------------------------------------------
{
    my $obj = shift;
    my $string = shift;
    
    $string = uc($string);
    $string =~ tr/A-Z//cd;


    # Iterate over two character substitutions
    foreach my $index (0..((length $string)-2)) {
        if ($DOUBLECHARS{substr $string,$index,2}) {
            substr ($string,$index,2) = $DOUBLECHARS{substr $string,$index,2};
        }
    }
    
    # Single character substitutions via tr
    $string =~tr/ZKGQIJFWPT§/CCCCYYVBDUA/;
    
    #delete forbidden characters
    $string =~tr/ABCDLMNORSUVWXY//cd;
    
    #remove double chars
    $string =~tr/ABCDLMNORSUVWXY//s;
    
    return $string;
}

=pod

=head1 NAME

Text::Phonetic::Phonem - Phonem algorithm

=head1 DESCRIPTION

The PHONEM algorithm is a simple substitution that was originally 
implemented in dBase.

Implementation of the PHONEM substitutions, as described in Georg Wilde and 
Carsten Meyer, "Doppelgaenger gesucht - Ein Programm fuer kontextsensitive 
phonetische Textumwandlung" from ct Magazin fuer Computer & Technik 25/1999.

The original variant was implemented as X86-Assembler-Funktion. This 
implementation does not try to mimic the original code, though it should 
achieve equal results. As the original software used for building the original
implementation was not available, there was no testing for correctness, other
than the examples given in the article.

The Perl implementation was written by Martin Wilz 
(L<http://wilz.de/view/Themen/MagisterArbeit>)

=head1 AUTHOR

    Maroš Kollár
    CPAN ID: MAROS
    maros [at] k-1.com
    http://www.k-1.com

=head1 COPYRIGHT

This program is free software; you can redistribute
it and/or modify it under the same terms as Perl itself.

The full text of the license can be found in the
LICENSE file included with this module.

=head1 SEE ALSO


=cut




1;