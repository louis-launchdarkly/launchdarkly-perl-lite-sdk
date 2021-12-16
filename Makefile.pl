use 5.034000;
use ExtUtils::MakeMaker 7.12; # for XSMULTI option

WriteMakefile(
  NAME           => 'XS::LaunchDarkly',
  VERSION_FROM   => 'lib/XS/LaunchDarkly.pm',
  PREREQ_PM      => { 'ExtUtils::MakeMaker' => '7.12' },
  ABSTRACT_FROM  => 'lib/XS/LaunchDarkly.pm',
  AUTHOR         => 'Steve Glass',
  CCFLAGS        => '-I ../osx-clang-64bit-dynamic-2.2/include -Wall -std=c99',
  OPTIMIZE       => '-O3',
  LICENSE        => 'freebsd',
  XSMULTI        => 1,
  LIBS           => '-L../osx-clang-64bit-dynamic-2.2/lib -lldserverapi -lcurl -lpthread -lpcre -lm',
);
