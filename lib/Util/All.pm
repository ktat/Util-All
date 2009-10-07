package Util::All;

use warnings;
use strict;

use Util::Any -Base, -Pluggable;

our $Utils = {
  '-base64' => [
    [
      'MIME::Base64',
      '',
      {
        '-select' => [],
        'decode_base64' => 'base64_decode',
        'encode_base64' => 'base64_encode'
      }
    ]
  ],
  '-basecalc' => [
    [
      'Math::BaseCalc',
      '',
      {
        'to_base' => sub {
            my($pkg, $class, $func, $args, $kind_args) = @_;
            sub {
                'Math::BaseCalc'->new('digits', $$kind_args{'digits'} || $$args{'digits'})->to_base(shift @_);
            }
            ;
        },
        '-select' => [],
        'from_base' => sub {
            my($pkg, $class, $func, $args, $kind_args) = @_;
            sub {
                'Math::BaseCalc'->new('digits', $$kind_args{'digits'} || $$args{'digits'})->from_base(shift @_);
            }
            ;
        }
      }
    ]
  ],
  '-benchmark' => [
    [
      'Benchmark',
      '',
      {
        'timesamearg' => sub {
            sub {
                my($num, $codes, @args) = @_;
                Benchmark::timethese($num, {map({my $code = $$codes{$_};
                $_, sub {
                    &$code(@args);
                }
                ;} keys %$codes)});
            }
            ;
        },
        '-select' => [
          'timeit',
          'timethis',
          'timethese',
          'timediff',
          'timestr',
          'timesum',
          'cmpthese',
          'countit'
        ],
        'cmpsamearg' => sub {
            sub {
                my($num, $codes, @args) = @_;
                Benchmark::cmpthese($num, {map({my $code = $$codes{$_};
                $_, sub {
                    &$code(@args);
                }
                ;} keys %$codes)});
            }
            ;
        }
      }
    ]
  ],
  '-carp' => [
    [
      'Carp',
      '',
      {
        '-select' => [
          'croak',
          'cluck',
          'carp',
          'confess',
          'shortmess',
          'longmess'
        ]
      }
    ]
  ],
  '-cgi' => [
    [
      'CGI::Util',
      '',
      {
        '-select' => [],
        'unescape' => 'cgi_unescape',
        'escape' => 'cgi_escape'
      }
    ],
    [
      'HTML::Entities',
      '',
      {
        'encode_entities' => 'html_entity_encode',
        '-select' => [],
        'decode_entities' => 'html_entity_decode'
      }
    ]
  ],
  '-char_enc' => [
    [
      'Encode',
      '',
      {
        'from_to' => 'char_from_to',
        'decode' => 'char_decode',
        '-select' => [],
        'encode' => 'char_encode',
        'char_convert' => sub {
            my($pkg, $class, $func, $args) = @_;
            my $g_class = 0;
            if (exists $$args{'guess'}) {
                require Encode::Guess;
                'Encode::Guess'->import(@{$$args{'guess'};});
            }
            elsif (not $INC{'Encode/Detect.pm'} and not $INC{'Encode/Guess.pm'}) {
                require Encode::Guess unless eval {
                    do {
                        require Encode::Detect;
                        $g_class = 1
                    }
                };
            }
            sub {
                my($str, $to, $from) = @_;
                Encode::from_to(shift @_, $from ? $from : ($g_class ? 'DETECT' : 'GUESS'), $to);
            }
            ;
        }
      }
    ]
  ],
  '-datetime' => [
    [
      'DateTime',
      '',
      {
        'now' => sub {
            sub () {
                'DateTime'->now(@_);
            }
            ;
        },
        'today' => sub {
            sub () {
                'DateTime'->today(@_);
            }
            ;
        },
        '-select' => [],
        'datetime' => sub {
            sub {
                'DateTime'->new(@_);
            }
            ;
        }
      }
    ],
    [
      'DateTime::Duration',
      '',
      {
        'hour' => sub {
            my($pkg, $class, $func, $args, $kind_args) = @_;
            sub () {
                'DateTime::Duration'->new('hours', 1, 'end_of_month', $$kind_args{'end_of_month'} || $$args{'end_of_month'} || 'limit');
            }
            ;
        },
        'hours' => sub {
            my($pkg, $class, $func, $args, $kind_args) = @_;
            sub ($) {
                'DateTime::Duration'->new('hours', shift @_, 'end_of_month', $$kind_args{'end_of_month'} || $$args{'end_of_month'} || 'limit');
            }
            ;
        },
        '-select' => [],
        'second' => sub {
            my($pkg, $class, $func, $args, $kind_args) = @_;
            sub () {
                'DateTime::Duration'->new('seconds', 1, 'end_of_month', $$kind_args{'end_of_month'} || $$args{'end_of_month'} || 'limit');
            }
            ;
        },
        'month' => sub {
            my($pkg, $class, $func, $args, $kind_args) = @_;
            sub () {
                'DateTime::Duration'->new('months', 1, 'end_of_month', $$kind_args{'end_of_month'} || $$args{'end_of_month'} || 'limit');
            }
            ;
        },
        'minutes' => sub {
            my($pkg, $class, $func, $args, $kind_args) = @_;
            sub ($) {
                'DateTime::Duration'->new('minutes', shift @_, 'end_of_month', $$kind_args{'end_of_month'} || $$args{'end_of_month'} || 'limit');
            }
            ;
        },
        'days' => sub {
            my($pkg, $class, $func, $args, $kind_args) = @_;
            sub ($) {
                'DateTime::Duration'->new('days', shift @_, 'end_of_month', $$kind_args{'end_of_month'} || $$args{'end_of_month'} || 'limit');
            }
            ;
        },
        'seconds' => sub {
            my($pkg, $class, $func, $args, $kind_args) = @_;
            sub ($) {
                'DateTime::Duration'->new('seconds', shift @_, 'end_of_month', $$kind_args{'end_of_month'} || $$args{'end_of_month'} || 'limit');
            }
            ;
        },
        'minute' => sub {
            my($pkg, $class, $func, $args, $kind_args) = @_;
            sub () {
                'DateTime::Duration'->new('minutes', 1, 'end_of_month', $$kind_args{'end_of_month'} || $$args{'end_of_month'} || 'limit');
            }
            ;
        },
        'years' => sub {
            my($pkg, $class, $func, $args, $kind_args) = @_;
            sub ($) {
                'DateTime::Duration'->new('years', shift @_, 'end_of_month', $$kind_args{'end_of_month'} || $$args{'end_of_month'} || 'limit');
            }
            ;
        },
        'day' => sub {
            my($pkg, $class, $func, $args, $kind_args) = @_;
            sub () {
                'DateTime::Duration'->new('days', 1, 'end_of_month', $$kind_args{'end_of_month'} || $$args{'end_of_month'} || 'limit');
            }
            ;
        },
        'datetime_duration' => sub {
            my($pkg, $class, $func, $args, $kind_args) = @_;
            sub {
                'DateTime::Duration'->new('end_of_month', $$kind_args{'end_of_month'} || $$args{'end_of_month'} || 'limit', @_);
            }
            ;
        },
        'year' => sub {
            my($pkg, $class, $func, $args, $kind_args) = @_;
            sub () {
                'DateTime::Duration'->new('years', 1, 'end_of_month', $$kind_args{'end_of_month'} || $$args{'end_of_month'} || 'limit');
            }
            ;
        },
        'months' => sub {
            my($pkg, $class, $func, $args, $kind_args) = @_;
            sub ($) {
                'DateTime::Duration'->new('months', shift @_, 'end_of_month', $$kind_args{'end_of_month'} || $$args{'end_of_month'} || 'limit');
            }
            ;
        }
      }
    ],
    [
      'Date::Parse',
      '',
      {
        '-select' => [],
        'datetime_parse' => sub {
            my $i = 1;
            unless ($INC{'Date/Manip.pm'}) {
                require Date::Manip;
                $i = 0;
            }
            sub {
                unless ($i) {
                    $i = 1;
                    Date::Manip::Date_Init();
                }
                my($ss, $mm, $hh, $day, $month, $year, $zone) = Date::Parse::strptime(@_);
                'DateTime'->new('year', $year + 1900, 'month', ++$month, 'day', $day, 'hour', $hh || 0, 'minute', $mm || 0, 'second', $ss || 0, 'time_zone', $Date::Manip::Zone{'n2o'}{Time::Zone::tz_name($zone)});
            }
            ;
        }
      }
    ]
  ],
  '-debug' => [
    [
      'Data::Dump',
      '',
      {
        'p' => sub {
            sub {
                Data::Dump::dump(@_);
            }
            ;
        },
        '-select' => [
          'dump'
        ]
      }
    ],
    [
      'Data::Dumper',
      '',
      {
        'Dumper' => 'dumper',
        '-select' => [],
        'deparse' => sub {
            sub (&) {
                local $Data::Dumper::Deparse = 1;
                Data::Dumper::Dumper(@_);
            }
            ;
        }
      }
    ]
  ],
  '-file' => [
    [
      'File::Copy',
      '',
      {
        'copy' => 'file_copy',
        'move' => 'file_move',
        '-select' => []
      }
    ],
    [
      'File::Find',
      '',
      {
        '-select' => [],
        'find' => 'file_find'
      }
    ],
    [
      'File::Path',
      '',
      {
        '-select' => [
          'make_path',
          'remove_tree'
        ]
      }
    ],
    [
      'File::Slurp',
      '',
      {
        '-select' => [],
        'slurp' => 'file_slurp',
        'write_file' => 'file_write',
        'read_file' => 'file_read'
      }
    ]
  ],
  '-hash' => [
    [
      'Tie::IxHash',
      '',
      {
        'indexed' => sub {
            sub (\%@) {
                my $hash = shift @_;
                tie %$hash, 'Tie::IxHash';
                (%$hash) = @_;
            }
            ;
        },
        '-select' => []
      }
    ],
    [
      'Hash::Util',
      '',
      {
        '-select' => [
          'hash_seed',
          'lock_hash',
          'lock_keys',
          'lock_value',
          'unlock_hash',
          'unlock_keys',
          'unlock_value'
        ]
      }
    ]
  ],
  '-html' => [
    [
      'CGI::Util',
      '',
      {
        '-select' => [],
        'unescape' => 'cgi_unescape',
        'escape' => 'cgi_escape'
      }
    ],
    [
      'HTML::Entities',
      '',
      {
        'encode_entities' => 'html_entity_encode',
        '-select' => [],
        'decode_entities' => 'html_entity_decode'
      }
    ]
  ],
  '-http' => [
    [
      'HTTP::Request::Common',
      '',
      {
        'http_post' => sub {
            require WWW::Curl::Simple;
            sub {
                my $ua = 'WWW::Curl::Simple'->new;
                $ua->post(@_);
            }
            ;
        },
        'http_put' => sub {
            require LWP::UserAgent;
            sub {
                my $ua = 'LWP::UserAgent'->new;
                $ua->request(HTTP::Request::Common::PUT(@_));
            }
            ;
        },
        '-select' => [],
        'http_head' => sub {
            require LWP::UserAgent;
            sub {
                my $ua = 'LWP::UserAgent'->new;
                $ua->request(HTTP::Request::Common::HEAD(@_));
            }
            ;
        },
        'http_get' => sub {
            require WWW::Curl::Simple;
            sub {
                my $ua = 'WWW::Curl::Simple'->new;
                $ua->get(@_);
            }
            ;
        },
        'http_delete' => sub {
            require LWP::UserAgent;
            sub {
                my $ua = 'LWP::UserAgent'->new;
                $ua->request(HTTP::Request::Common::DELETE(@_));
            }
            ;
        }
      }
    ]
  ],
  '-json' => [
    [
      'JSON::XS',
      '',
      {
        'decode_json' => 'json_load',
        '-select' => [],
        'json_load_file' => sub {
            require File::Slurp;
            sub {
                JSON::XS::decode_json(File::Slurp::slurp(shift @_));
            }
            ;
        },
        'json_dump_file' => sub {
            require File::Slurp;
            sub {
                File::Slurp::write_file(shift @_, JSON::XS::encode_json(shift @_));
            }
            ;
        },
        'encode_json' => 'json_dump'
      }
    ]
  ],
  '-list' => [
    [
      'List::Util',
      '',
      {
        '-select' => [
          'first',
          'max',
          'maxstr',
          'min',
          'minstr',
          'reduce',
          'shuffle',
          'sum'
        ]
      }
    ],
    [
      'List::MoreUtils',
      '',
      {
        '-select' => [
          'after',
          'after_incl',
          'all',
          'any',
          'apply',
          'before',
          'before_incl',
          'each_array',
          'each_arrayref',
          'false',
          'first_index',
          'first_value',
          'firstidx',
          'firstval',
          'indexes',
          'insert_after',
          'insert_after_string',
          'last_index',
          'last_value',
          'lastidx',
          'lastval',
          'mesh',
          'minmax',
          'natatime',
          'none',
          'notall',
          'pairwise',
          'part',
          'true',
          'uniq',
          'zip'
        ]
      }
    ]
  ],
  '-mail' => [
    [
      'Mail::Sendmail',
      '',
      {
        '-select' => [],
        'mail_send' => sub {
            sub {
                my(%args) = @_;
                my %new;
                $new{ucfirst $_} = $args{$_} foreach (keys %args);
                Mail::Sendmail::sendmail(%new);
            }
            ;
        }
      }
    ]
  ],
  '-md5' => [
    [
      'Digest::MD5',
      '',
      {
        '-select' => [
          'md5',
          'md5_hex',
          'md5_base64'
        ]
      }
    ]
  ],
  '-number' => [
    [
      'Number::Format',
      '',
      {
        'number_price' => sub {
            my($pkg, $class, $func, $args, $kind_args) = @_;
            my $n = 'Number::Format'->new(%$kind_args, %$args);
            sub {
                $n->format_price(@_);
            }
            ;
        },
        'number_commify' => sub {
            sub {
                local $_ = shift @_;
                while (s/((?:\A|[^.0-9])[-+]?\d+)(\d{3})/$1,$2/s) {
                    ();
                }
                return $_;
            }
            ;
        },
        'number_unit' => sub {
            my($pkg, $class, $func, $args, $kind_args) = @_;
            my $n = 'Number::Format'->new(%$kind_args, %$args);
            sub {
                $n->format_unit(@_);
            }
            ;
        },
        '-select' => [],
        'to_number' => sub {
            my($pkg, $class, $func, $args, $kind_args) = @_;
            my $n = 'Number::Format'->new(%$kind_args, %$args);
            sub {
                $n->unformat_number(@_);
            }
            ;
        },
        'number_round' => sub {
            my($pkg, $class, $func, $args, $kind_args) = @_;
            my $n = 'Number::Format'->new(%$kind_args);
            sub {
                $n->round(@_);
            }
            ;
        },
        'number_format' => sub {
            my($pkg, $class, $func, $args, $kind_args) = @_;
            my $n = 'Number::Format'->new(%$kind_args, %$args);
            sub {
                $n->format_number(@_);
            }
            ;
        }
      }
    ]
  ],
  '-return' => [
    [
      'Return::Value',
      '',
      {
        '-select' => [
          'success',
          'failure'
        ]
      }
    ]
  ],
  '-scalar' => [
    [
      'Scalar::Util',
      '',
      {
        '-select' => [
          'blessed',
          'dualvar',
          'isvstring',
          'isweak',
          'looks_like_number',
          'openhandle',
          'readonly',
          'refaddr',
          'reftype',
          'set_prototype',
          'tainted',
          'weaken'
        ]
      }
    ]
  ],
  '-sha' => [
    [
      'Digest::SHA',
      '',
      {
        '-select' => [
          'sha1',
          'sha1_hex',
          'sha1_base64',
          'sha256',
          'sha256_hex',
          'sha256_base64',
          'sha384',
          'sha384_hex',
          'sha384_base64',
          'sha512',
          'sha512_hex',
          'sha512_base64'
        ]
      }
    ]
  ],
  '-string' => [
    [
      'String::CamelCase',
      '',
      {
        '-select' => [
          'camelize',
          'decamelize',
          'wordsplit'
        ]
      }
    ],
    [
      'String::Util',
      '',
      {
        '-select' => [
          'crunch',
          'define',
          'equndef',
          'fullchomp',
          'hascontent',
          'htmlesc',
          'neundef',
          'nospace',
          'randcrypt',
          'randword',
          'trim',
          'unquote'
        ]
      }
    ]
  ],
  '-time' => [
    [
      'Time::HiRes',
      '',
      {
        '-select' => [
          'usleep',
          'nanosleep',
          'ualarm'
        ]
      }
    ]
  ],
  '-uri' => [
    [
      'URI',
      '',
      {
        '-select' => [],
        'uri_make' => sub {
            sub {
                my($url, $form) = @_;
                my %form;
                foreach my $k (keys %$form) {
                    my($key, $value) = ($k, $$form{$k});
                    utf8::decode($key) unless utf8::is_utf8($k);
                    utf8::decode($value) unless utf8::is_utf8($value);
                    $form{$key} = $value;
                }
                my $u = 'URI'->new($url);
                $u->query_form(%form);
                $u->as_string;
            }
            ;
        }
      }
    ],
    [
      'URI::Escape',
      '',
      {
        '-select' => [
          'uri_escape',
          'uri_unescape'
        ]
      }
    ],
    [
      'URI::Split',
      '',
      {
        '-select' => [
          'uri_split',
          'uri_join'
        ]
      }
    ]
  ],
  '-utf8' => [
    [
      'Data::Visitor::Encode',
      '',
      {
        'utf8_off' => sub {
            sub {
                'Data::Visitor::Encode'->new->Utf8_off(@_);
            }
            ;
        },
        '-select' => [],
        'utf8_on' => sub {
            sub {
                'Data::Visitor::Encode'->new->utf8_on(@_);
            }
            ;
        }
      }
    ],
    [
      'utf8',
      '',
      {
        'downgrade' => 'utf8_downgrade',
        '-select' => [
          'is_utf8'
        ],
        'upgrade' => 'utf8_upgrade',
        'encode' => 'utf8_encode'
      }
    ]
  ],
  '-xml' => [
    [
      'XML::Simple',
      '',
      {
        'xml_dump' => sub {
            my($pkg, $class, $func, $args) = @_;
            $$args{'KeyAttr'} ||= $$kind_args{'key_attr'} || $$args{'key_attr'};
            sub {
                XML::Simple::XMLout(shift @_, %$args);
            }
            ;
        },
        'xml_load' => sub {
            my($pkg, $class, $func, $args) = @_;
            local $XML::Simple::XML_SIMPLE_PREFERRED_PARSER = $$kind_args{'parser'} || $$args{'parser'} || 'XML::Parser';
            $$args{'Forcearray'} ||= $$kind_args{'force_array'} || $$args{'force_array'};
            $$args{'KeyAttr'} ||= $$kind_args{'key_attr'} || $$args{'key_attr'};
            sub {
                XML::Simple::XMLin(shift @_, %$args);
            }
            ;
        },
        '-select' => []
      }
    ]
  ],
  '-yaml' => [
    [
      'YAML::XS',
      '',
      {
        '-select' => [],
        'yaml_load_file' => sub {
            require File::Slurp;
            sub {
                YAML::XS::Load(File::Slurp::slurp(shift @_));
            }
            ;
        },
        'Dump' => 'yaml_dump',
        'Load' => 'yaml_load',
        'yaml_dump_file' => sub {
            require File::Slurp;
            sub {
                File::Slurp::write_file(shift @_, YAML::XS::Dump(shift @_));
            }
            ;
        }
      }
    ]
  ]
}
;

=head1 NAME

Util::All - collect perl utilities and group them to appropriate kind.

=cut

our $VERSION = '0.01';

=head1 SYNOPSIS

When you want list utilities.

 use Util::All -list;
 my @uniq = uniq @list;

When you want string utilities.

 use Util::All -string;
 camelize('abc_def'); # AbcDef

When you want character encoding Utilities.

 use Util::All -char_enc;
 $encoded = char_encode('utf8', $str); # Encode::encode
 $decoded = char_decode('utf8', $str); # Encode::decode
 char_from_to($str, $icode, 'utf8');   # Encode::from_to
 char_convert($str, 'utf8'[, $icode]); # use Encode::Detect or Encode::Guess

 # use Encode::Guess and pass encoding to guess
 use Util::All -char_conv => {char_convert => {guess => ["sjis", "euc-jp"]}};
 char_convert($str, "euc-jp");

When you want CGI utilities.

 use Util::All -cgi;
 cgi_escape("/%"); # %2F%25
 cgi_unescape("%2F%25") # /%

When you want MD5 utilities

 use Util::All -md5;

 md5_base64($str);

When you want datetime utilities

 use Util::All -datetime;
 
 datetime(year => 2009, month => 9, day => 1); # eq DateTime->new(...)
 today; # today DateTime object
 now;   # now   DateTime object
 datetime_parse("2009-09-10") + year + month + day; # 2010-10-11T00:00:00 DateTime object

When you want all utilities

 use Util::All -all;

etc.

=head1 DESCRIPTION

Perl has many modules on CPAN and many modules provide utility functions.
Their utility functions are useful themselves.
But there are two problems to use these utility functions.

First, CPAN has too much modules to lookup useful utility functions.
Newbie or even intermediate level programmers don't know such functions very much.
Honestly speaking, I don't know so much utility functions, too.
Even if I could search such functions,
users have to remember its name and the module including it.

Second, utility functions are written by many authors.
So, its naming rule/grouping rule/interface is defined by each author.
It is hard to remember the name/usage.

It's very regrettable for Perl.

Util::All aims to collect utility functions on CPAN and group them to appropriate kind
and rename them by common naming rule.

If you know good utility functions, please tell me.
I want to add them into Util::All.

=head1 NAMING RULE

Current planned naming rule is:

 KIND_VERB(_OBJECT)

For example:

 YAML::Syck::Load ...  yml_load
 YAML::Syck::LoadFile ... yml_load_file
 Mail::Sendmail::sendmail ... mail_send

But, some functions, which I think no need to add kind, are exception.
For example:

 today ... return today's DateTime object
 now ... return now DateTime object

etc.

=head1 EXPORT

=head2 -base64

=head3 base64_encode

encode_base64 of MIME::Base64

=head3 base64_decode

decode_base64 of MIME::Base64

=head2 -basecalc

=head3 to_base *

  sub {
    my ( $pkg, $class, $func, $args, $kind_args ) = @_;
    sub {
        Math::BaseCalc->new( digits => $kind_args->{digits} || $args->{digits} )
          ->to_base(shift);
      }
  }


=head3 from_base *

  sub {
    my ( $pkg, $class, $func, $args, $kind_args ) = @_;
    sub {
        Math::BaseCalc->new( digits => $kind_args->{digits} || $args->{digits} )
          ->from_base(shift);
      }
  }


=head2 -benchmark

=head3 functions of Benchmark

=head4 timeit

=head4 timethis

=head4 timethese

=head4 timediff

=head4 timestr

=head4 timesum

=head4 cmpthese

=head4 countit

=head3 timesamearg *

  timesamearg($count, {name => \&code, name2 => \&code}, \%samearg)

=head3 cmpsamearg *

  cmpsamearg($count, {name => \&code, name2 => \&code}, \%samearg)

=head2 -carp

=head3 functions of Carp

=head4 croak

=head4 cluck

=head4 carp

=head4 confess

=head4 shortmess

=head4 longmess

=head2 -cgi

=head3 html_entity_decode

decode_entities of HTML::Entities

=head3 cgi_escape

escape of CGI::Util

=head3 cgi_unescape

unescape of CGI::Util

=head3 html_entity_encode

encode_entities of HTML::Entities

=head2 -char_enc

=head3 char_from_to

from_to of Encode

=head3 char_convert *

  sub {
    my ( $pkg, $class, $func, $args ) = @_;
    my $g_class = 0;
    if ( exists $args->{guess} ) {
        require Encode::Guess;
        Encode::Guess->import( @{ $args->{guess} } );
    }
    elsif ( not $INC{"Encode/Detect.pm"} and not $INC{"Encode/Guess.pm"} ) {
        eval { require Encode::Detect; $g_class = 1 } or require Encode::Guess;
    }
    sub {
        my ( $str, $to, $from ) = @_;
        Encode::from_to( shift, $from ? $from : $g_class ? "DETECT" : "GUESS",
            $to );
      }
  }


=head3 char_encode

encode of Encode

=head3 char_decode

decode of Encode

=head2 -datetime

=head3 functions to return DateTime object

  $dt = datetime(year => .., month => ..,);
  $dt = datetime_parse("2009/09/09");

=head3 functions to return DateTime::Duration object

  year
  month
  day
  hour
  minute
  second

They return DateTime::Duration object. So you can use them for calcuration.

  $duration = year + month + day

You can use plural form of these functions, too which can take number.

  years 5;
  months 5;


=head3 function enable to rename

now, today, datetime, hour, hours, second, month, minutes, days, seconds, minute, years, day, datetime_duration, year, months, datetime_parse

=head2 -debug

=head3 functions of Data::Dump

=head4 dump

=head3 p *

  p($variable)

as same as dumper(function name is as same as one in Ruby).

=head3 deparse *

  deparse(sub { print "hello World" })

dump code reference as string.

=head3 dumper

Dumper of Data::Dumper

=head2 -file

=head3 file_read

read_file of File::Slurp

=head3 file_write

write_file of File::Slurp

=head3 functions of File::Path

=head4 make_path

=head4 remove_tree

=head3 file_find

find of File::Find

=head3 file_copy

copy of File::Copy

=head3 file_move

move of File::Copy

=head3 file_slurp

slurp of File::Slurp

=head2 -hash

=head3 indexed *

  indexed my %hash = (a => 1, b => 2);

%hash is indexed.

=head3 functions of Hash::Util

=head4 hash_seed

=head4 lock_hash

=head4 lock_keys

=head4 lock_value

=head4 unlock_hash

=head4 unlock_keys

=head4 unlock_value

=head2 -html

=head3 html_entity_decode

decode_entities of HTML::Entities

=head3 cgi_escape

escape of CGI::Util

=head3 cgi_unescape

unescape of CGI::Util

=head3 html_entity_encode

encode_entities of HTML::Entities

=head2 -http

=head3 http_* functions

do http method and get HTTP::Response object.

  http_get($url, \%query);
  http_post($url, \%query);
  http_put($url, \%query);
  http_delete($url, \%query);
  http_head($url, \%query);


=head3 function enable to rename

http_post, http_put, http_head, http_get, http_delete

=head2 -json

=head3 json_dump

encode_json of JSON::XS

=head3 json_load_file *

  sub {
    require File::Slurp;
    sub { JSON::XS::decode_json( File::Slurp::slurp(shift) ) }
  }


=head3 json_dump_file *

  sub {
    require File::Slurp;
    sub { File::Slurp::write_file( shift, JSON::XS::encode_json(shift) ) }
  }


=head3 json_load

decode_json of JSON::XS

=head2 -list

=head3 functions of List::Util

=head4 first

=head4 max

=head4 maxstr

=head4 min

=head4 minstr

=head4 reduce

=head4 shuffle

=head4 sum

=head3 functions of List::MoreUtils

=head4 after

=head4 after_incl

=head4 all

=head4 any

=head4 apply

=head4 before

=head4 before_incl

=head4 each_array

=head4 each_arrayref

=head4 false

=head4 first_index

=head4 first_value

=head4 firstidx

=head4 firstval

=head4 indexes

=head4 insert_after

=head4 insert_after_string

=head4 last_index

=head4 last_value

=head4 lastidx

=head4 lastval

=head4 mesh

=head4 minmax

=head4 natatime

=head4 none

=head4 notall

=head4 pairwise

=head4 part

=head4 true

=head4 uniq

=head4 zip

=head2 -mail

=head3 mail_send *

  sub {
    sub {
        my (%args) = @_;
        my %new;
        $new{ ucfirst $_ } = $args{$_} for keys %args;
        Mail::Sendmail::sendmail(%new);

        # error $Mail::Sendmail::error;
        # log   $Mail::Sendmail::log;
      }
  }


=head2 -md5

=head3 functions of Digest::MD5

=head4 md5

=head4 md5_hex

=head4 md5_base64

=head2 -number

=head3 number_commify *

  sub {

    # code is borrowed from Template::Plugin::Comma
    sub {
        local $_ = shift;
        while (s/((?:\A|[^.0-9])[-+]?\d+)(\d{3})/$1,$2/s) { }
        return $_;
      }
  }


=head3 number_price *

  sub {
    my ( $pkg, $class, $func, $args, $kind_args ) = @_;
    my $n = Number::Format->new( %$kind_args, %$args );
    sub {
        $n->format_price(@_);
      }
  }


=head3 number_unit *

  sub {
    my ( $pkg, $class, $func, $args, $kind_args ) = @_;
    my $n = Number::Format->new( %$kind_args, %$args );
    sub {
        $n->format_unit(@_);
      }
  }


=head3 number_round *

  sub {
    my ( $pkg, $class, $func, $args, $kind_args ) = @_;
    my $n = Number::Format->new(%$kind_args);
    sub {
        $n->round(@_);
      }
  }


=head3 to_number *

  sub {
    my ( $pkg, $class, $func, $args, $kind_args ) = @_;
    my $n = Number::Format->new( %$kind_args, %$args );
    sub {
        $n->unformat_number(@_);
      }
  }


=head3 number_format *

  sub {
    my ( $pkg, $class, $func, $args, $kind_args ) = @_;
    my $n = Number::Format->new( %$kind_args, %$args );
    sub {
        $n->format_number(@_);
      }
  }


=head2 -return

=head3 functions of Return::Value

=head4 success

=head4 failure

=head2 -scalar

=head3 functions of Scalar::Util

=head4 blessed

=head4 dualvar

=head4 isvstring

=head4 isweak

=head4 looks_like_number

=head4 openhandle

=head4 readonly

=head4 refaddr

=head4 reftype

=head4 set_prototype

=head4 tainted

=head4 weaken

=head2 -sha

=head3 functions of Digest::SHA

=head4 sha1

=head4 sha1_hex

=head4 sha1_base64

=head4 sha256

=head4 sha256_hex

=head4 sha256_base64

=head4 sha384

=head4 sha384_hex

=head4 sha384_base64

=head4 sha512

=head4 sha512_hex

=head4 sha512_base64

=head2 -string

=head3 functions of String::CamelCase

=head4 camelize

=head4 decamelize

=head4 wordsplit

=head3 functions of String::Util

=head4 crunch

=head4 define

=head4 equndef

=head4 fullchomp

=head4 hascontent

=head4 htmlesc

=head4 neundef

=head4 nospace

=head4 randcrypt

=head4 randword

=head4 trim

=head4 unquote

=head2 -time

=head3 functions of Time::HiRes

=head4 usleep

=head4 nanosleep

=head4 ualarm

=head2 -uri

=head3 functions of URI::Escape

=head4 uri_escape

=head4 uri_unescape

=head3 functions of URI::Split

=head4 uri_split

=head4 uri_join

=head3 uri_make *

  sub {
    sub {
        use utf8;
        my ( $url, $form ) = @_;
        my %form;
        foreach my $k ( keys %$form ) {
            my ( $key, $value ) = ( $k, $form->{$k} );
            utf8::decode($key)   unless utf8::is_utf8($k);
            utf8::decode($value) unless utf8::is_utf8($value);
            $form{$key} = $value;
        }
        my $u = URI->new($url);
        $u->query_form(%form);
        $u->as_string;
      }
  }


=head2 -utf8

=head3 functions of utf8

=head4 is_utf8

=head3 utf8_encode

encode of utf8

=head3 utf8_off *

  sub {
    sub { Data::Visitor::Encode->new->Utf8_off(@_) }
  }


=head3 utf8_upgrade

upgrade of utf8

=head3 utf8_downgrade

downgrade of utf8

=head3 utf8_on *

  sub {
    sub { Data::Visitor::Encode->new->utf8_on(@_) }
  }


=head2 -xml

=head3 xml_dump *

  sub {
    my ( $pkg, $class, $func, $args ) = @_;
    $args->{KeyAttr} ||= $kind_args->{key_attr} || $args->{key_attr};
    sub {
        XML::Simple::XMLout( shift, %$args );
      }
  }


=head3 xml_load *

  sub {
    my ( $pkg, $class, $func, $args ) = @_;
    local $XML::Simple::XML_SIMPLE_PREFERRED_PARSER =
         $kind_args->{parser}
      || $args->{parser}
      || 'XML::Parser';
    $args->{Forcearray} ||= $kind_args->{force_array} || $args->{force_array};
    $args->{KeyAttr}    ||= $kind_args->{key_attr}    || $args->{key_attr};
    sub {
        XML::Simple::XMLin( shift, %$args );
      }
  }


=head2 -yaml

=head3 yaml_load

Load of YAML::XS

=head3 yaml_dump

Dump of YAML::XS

=head3 yaml_load_file *

  sub {
    require File::Slurp;
    sub { YAML::XS::Load( File::Slurp::slurp(shift) ) }
  }


=head3 yaml_dump_file *

  sub {
    require File::Slurp;
    sub { File::Slurp::write_file( shift, YAML::XS::Dump(shift) ) }
  }




=head1 YAML FILE STRUCTURE

Util::All is generated from YAML file(functions.yml in distribution file).

Its first level keys are kinds of functions.
hashes of the kinds has four kinds of structures.

First:

 Module::Name: *

All functions in @EXPORT, @EXPORT_OK of Module::Name can be imported.

Second:

 Module::Name:
   - function_a
   - function_b

function_a and function_b of module::Name can be imported.

Third:

 Module::Name:
   function_a: func_a

function_a of Module::Name can be imported as func_a.

Fourth:

 Module::Name:
   function_a: sub { sub { ... } }

function_a is function enable to generate function.
See L<Util::Any/Sub::Exporter's GENERATOR WAY>.

The following is all definition of Util::All.
This file is functions.yml in distribution.


=head1 CREATE PLUGINS

Create module whose package name is under Util::All::Plugin and
define utils method. for example.

  package Util::All::Plugin::Net;
  
  sub utils {
    # This structure is as same as $Utils.
    return {
        -net => [
                  [
                   'Net::Amazon', '',
                   {
                    amazon => sub {
                      my ($pkg, $class, $func, $args) = @_;
                      my $amazon = Net::Amazon->new(token => $args->{token});
                      sub { $amazon }
                    },
                   }
                  ]
                ]
       };
  }
  
  1;

=head1 QUESTIONS

=head2 ALL MODULE(S) IS/ARE LOADED WHEN USING Util::All?

No. the related module(s) of your selected kind(s) is/are loaded.

=head2 WHY '-all' IS SLOW?

Keyword '-all' as same as 'all' and ':all' is used,
L<Util::Any> checks exportable functions in  all modules defined in $Utils and
some of functions have to be generated on loading and which needs a bit heavy module like DateTime, Date::Manip.
So, it is slow a bit. But, it is only first time, not slow next C<use>.

=head1 CREATE YOUR OWN Util::All

If you want to put more functions in Util::All,
download distribution file and extract it and modify functions.yml and util-all.template(if needed).
And then do the following.

 perl create_util_all.pl
 perl Makefile.PL
 make
 make test
 make install

To do this, the following modules are required.

 YAML::Syck
 File::Slurp
 Tie::IxHash
 Perl::Tidy

If you think more functions should be in Util::All, please tell me them.

=head1 AUTHOR

Ktat, C<< <ktat at cpan.org> >>

=head1 REPOSITORY

Util::All is hosted at github.

L<http://github.com/ktat/Util-All>

=head1 BUGS

Please report any bugs or feature requests to C<bug-util-all at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Util-All>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Util::All


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Util-All>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Util-All>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Util-All>

=item * Search CPAN

L<http://search.cpan.org/dist/Util-All/>

=back

=head1 ACKNOWLEDGEMENTS

=head1 SEE ALSO

=over 4

=item L<Util::Any>

This module is based on Util::Any.
Util::Any helps you to create your own utility module.

=back

=head1 COPYRIGHT & LICENSE

Copyright 2009 Ktat, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut

"All utility function are belong to Util::All"; # End of Util::All
