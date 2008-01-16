

use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    NAME         => 'Text::Phonetic',
    VERSION_FROM => 'lib/Text/Phonetic.pm', # finds \$VERSION
    AUTHOR       => 'Maros Kollar (maros [at] k-1.com)',
    ABSTRACT     => 'A module implementing various phonetic algorithms',
    NO_META      => 1,
    PREREQ_PM    => {
                     'Test::Pod' => 0,
                     'Test::More' => 0,
                     'Test::Pod::Coverage' => 0,
                     'Text::Unidecode' => 0,
                     'Text::Soundex' => 3,
                     'Text::Metaphone' => 0,
                     'Text::DoubleMetaphone' => 0,
                     'Exporter::Lite' => 0,
                    },
);
