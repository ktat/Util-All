use strict;
use warnings;

use inc::Module::Install;

# Define metadata
name           'Util-All';
all_from       'lib/Util/All.pm';

# Specific dependencies
requires       'Util::Any'  => '0.14',
	'B::Deparse' => 0,
	'Benchmark' => 0,
	'CGI::Util' => 0,
	'Carp' => 0,
	'Data::Dump' => 0,
	'Data::Dumper' => 0,
	'Data::Visitor::Encode' => 0,
	'Date::Manip' => 0,
	'Date::Parse' => 0,
	'DateTime' => 0,
	'DateTime::Duration' => 0,
	'Digest::MD5' => 0,
	'Digest::SHA' => 0,
	'Email::MIME' => 0,
	'Encode' => 0,
	'File::Copy' => 0,
	'File::Find' => 0,
	'File::Path' => 0,
	'File::Slurp' => 0,
	'File::Temp' => 0,
	'HTML::Entities' => 0,
	'HTTP::Request::Common' => 0,
	'Hash::Util' => 0,
	'Image::Info' => 0,
	'Imager' => 0,
	'JSON::XS' => 0,
	'LWP::UserAgent' => 0,
	'List::MoreUtils' => 0,
	'List::Util' => 0,
	'MIME::Base64' => 0,
	'MIME::Base64::URLSafe' => 0,
	'Mail::Sendmail' => 0,
	'Math::BaseCalc' => 0,
	'Number::Format' => 0,
	'Return::Value' => 0,
	'Scalar::Util' => 0,
	'String::CamelCase' => 0,
	'String::Util' => 0,
	'Text::CSV_XS' => 0,
	'Tie::IxHash' => 0,
	'Tie::Trace' => 0,
	'Time::HiRes' => 0,
	'Try::Tiny' => 0,
	'URI' => 0,
	'URI::Escape' => 0,
	'URI::Split' => 0,
	'WWW::Curl::Simple' => 0,
	'XML::Parser' => 0,
	'XML::Simple' => 0,
	'YAML::XS' => 0,
	'utf8' => 0
;
test_requires  'Test::More'  => '0.42';
no_index       'directory'   => 'demos';
# install_script 'myscript';

auto_install;
WriteAll;
