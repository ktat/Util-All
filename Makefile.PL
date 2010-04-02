use strict;
use warnings;

use inc::Module::Install;

# Define metadata
name           'Util-All';
all_from       'lib/Util/All.pm';

# Specific dependencies
requires       'Util::Any'  => '0.18',
# requires       'Task::Email::PEP::NoStore' => 0,
#               'Errno::AnyString' => 0,
	'B::Deparse' => 0,
	'Benchmark' => 0,
	'CGI::Util' => 0,
	'Carp' => 0,
	'Class::Accessor::Fast' => 0,
	'Class::Data::Inheritable' => 0,
	'Clone' => 0,
	'Data::Dump' => 0,
	'Data::Dumper' => 0,
	'Data::Recursive::Encode' => 0,
	'Data::Serializer' => 0,
	'Date::Manip' => 0,
	'Date::Parse' => 0,
	'DateTime' => 0,
	'DateTime::Duration' => 0,
	'Devel::Cycle' => 0,
	'Devel::Size' => 0,
	'Digest::MD5' => 0,
	'Digest::SHA' => 0,
	'Email::MIME' => 0,
	'Email::Sender::Simple' => 0,
	'Encode' => 0,
	'File::Copy' => 0,
	'File::Find' => 0,
	'File::Path' => 0,
	'File::Slurp' => 0,
	'File::Temp' => 0,
	'HTML::Entities' => 0,
	'HTTP::Request::Common' => 0,
	'Hash::Util' => 0,
	'IO::Prompt' => 0,
	'IO::String' => 0,
	'Image::Info' => 0,
	'Imager' => 0,
	'JSON::XS' => 0,
	'LWP::UserAgent' => 0,
	'List::MoreUtils' => 0,
	'List::Pairwise' => 0,
	'List::Util' => 0,
	'MIME::Base64' => 0,
	'MIME::Base64::URLSafe' => 0,
	'MIME::Types' => 0,
	'Math::BaseCalc' => 0,
	'Number::Format' => 0,
	'Scalar::Util' => 0,
	'Storable' => 0,
	'String::CamelCase' => 0,
	'String::Util' => 0,
	'Template' => 0,
	'Text::CSV' => 0,
	'Tie::IxHash' => 0,
	'Tie::Trace' => 0,
	'Time::HiRes' => 0,
	'Try::Tiny' => 0,
	'URI' => 0,
	'URI::Escape' => 0,
	'URI::Split' => 0,
	'Unicode::Japanese' => 0,
	'XML::Parser' => 0,
	'XML::Simple' => 0,
	'YAML::XS' => 0,
	'utf8' => 0
;
test_requires  'Test::More'  => '0.88';
no_index       'directory'   => 'demos';
# install_script 'myscript';

tests_recursive;
# auto_install;
WriteAll;
