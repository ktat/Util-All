use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'Util::All',
    AUTHOR              => 'Ktat <ktat@cpan.org>',
    VERSION_FROM        => 'lib/Util/All.pm',
    ABSTRACT_FROM       => 'lib/Util/All.pm',
    ($ExtUtils::MakeMaker::VERSION >= 6.3002
      ? ('LICENSE'=> 'perl')
      : ()),
    PL_FILES            => {},
    PREREQ_PM => {
        'Test::More' => 0,
        'Util::Any'  => 0.13,
        'Date::Manip' => 0,
        'LWP::UserAgent' => 0,
	'Benchmark' => 0,
	'CGI::Util' => 0,
	'Carp' => 0,
	'Data::Dump' => 0,
	'Data::Dumper' => 0,
	'Date::Parse' => 0,
	'DateTime' => 0,
	'DateTime::Duration' => 0,
	'Digest::MD5' => 0,
	'Digest::SHA' => 0,
	'Encode' => 0,
	'File::Copy' => 0,
	'File::Find' => 0,
	'File::Path' => 0,
	'File::Slurp' => 0,
	'HTTP::Request::Common' => 0,
	'Hash::Util' => 0,
	'JSON::Syck' => 0,
	'List::MoreUtils' => 0,
	'List::Util' => 0,
	'MIME::Base64' => 0,
	'Mail::Sendmail' => 0,
	'Return::Value' => 0,
	'Scalar::Util' => 0,
	'String::CamelCase' => 0,
	'String::Util' => 0,
	'URI::Escape' => 0,
	'URI::Split' => 0,
	'YAML::Syck' => 0,
	'utf8' => 0
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'Util-All-*' },
);
