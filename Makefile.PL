use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'Benchmark::Apps',
    AUTHOR              => 'Aberto Simoes <ambs@cpan.org>',
    VERSION_FROM        => 'lib/Benchmark/Apps.pm',
    ABSTRACT_FROM       => 'lib/Benchmark/Apps.pm',
    PL_FILES            => {},
    PREREQ_PM => {
			'Time::HiRes' => '0',
      'Test::More' => '0',
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'Benchmark-Apps-*' },
);
