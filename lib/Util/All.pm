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
      'Tie::Trace',
      '',
      {
        '-select' => [
          'watch'
        ]
      }
    ],
    [
      'Data::Dump',
      '',
      {
        'p' => sub {
            sub (@) {
                Data::Dump::dump(@_);
            }
            ;
        },
        '-select' => [
          'dump',
          'pp',
          'dd',
          'ddx'
        ],
        'dump_code' => sub {
            sub (&) {
                if (wantarray) {
                    local $Data::Dumper::Deparse = 1;
                    Data::Dumper::Dumper(@_);
                }
                else {
                    print STDERR Data::Dumper::Dumper(@_);
                }
            }
            ;
        }
      }
    ],
    [
      'Data::Dumper',
      '',
      {
        'Dumper' => 'dumper',
        '-select' => [],
        'code_dumper' => sub {
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
        'copy' => 'copy_file',
        'move' => 'move_file',
        '-select' => []
      }
    ],
    [
      'File::Find',
      '',
      {
        '-select' => [],
        'find' => 'find_file'
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
        'slurp' => 'slurp_file',
        '-select' => [
          'read_file',
          'write_file'
        ]
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
      'WWW::Curl::Simple',
      '',
      {
        'http_post' => sub {
            require WWW::Curl::Simple;
            my $ua = 'WWW::Curl::Simple'->new;
            sub {
                $ua->post(@_);
            }
            ;
        },
        '-select' => [],
        'http_get' => sub {
            require WWW::Curl::Simple;
            my $ua = 'WWW::Curl::Simple'->new;
            sub {
                $ua->get(@_);
            }
            ;
        }
      }
    ],
    [
      'HTTP::Request::Common',
      '',
      {
        'http_put' => sub {
            require LWP::UserAgent;
            my $ua = 'LWP::UserAgent'->new;
            sub {
                $ua->request(HTTP::Request::Common::PUT(@_));
            }
            ;
        },
        '-select' => [],
        'http_head' => sub {
            require LWP::UserAgent;
            my $ua = 'LWP::UserAgent'->new;
            sub {
                $ua->request(HTTP::Request::Common::HEAD(@_));
            }
            ;
        },
        'http_delete' => sub {
            require LWP::UserAgent;
            my $ua = 'LWP::UserAgent'->new;
            sub {
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
        'to_json_file' => sub {
            require File::Slurp;
            sub {
                File::Slurp::write_file(shift @_, JSON::XS::encode_json(shift @_));
            }
            ;
        },
        'decode_json' => 'from_json',
        '-select' => [],
        'encode_json' => 'to_json'
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
        'send_mail' => sub {
            sub {
                my(%args) = @_;
                my %new;
                $new{ucfirst $_} = $args{$_} foreach (keys %args);
                Mail::Sendmail::sendmail(%new);
            }
            ;
        }
      }
    ],
    [
      'Email::MIME',
      '',
      {
        'parse_mail' => sub {
            sub {
                my $message = 'Email::MIME'->new(@_);
            }
            ;
        },
        '-select' => []
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
            my($pkg, $class, $func, $args, $kind_args) = @_;
            $$args{'KeyAttr'} ||= $$kind_args{'key_attr'} || $$args{'key_attr'};
            sub {
                XML::Simple::XMLout(shift @_, %$args);
            }
            ;
        },
        'xml_load' => sub {
            my($pkg, $class, $func, $args, $kind_args) = @_;
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
        'to_yaml_file' => sub {
            require File::Slurp;
            sub {
                File::Slurp::write_file(shift @_, YAML::XS::Dump(shift @_));
            }
            ;
        },
        '-select' => [],
        'from_yaml_file' => sub {
            require File::Slurp;
            sub {
                YAML::XS::Load(File::Slurp::slurp(shift @_));
            }
            ;
        },
        'Dump' => 'to_yaml',
        'Load' => 'from_yaml'
      }
    ]
  ]
}
;

=head1 NAME

Util::All - collect perl utilities and group them by appropriate kind.

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
But there are three problems to use these utility functions.

First, CPAN has too much modules to lookup useful utility functions.
Newbie or even intermediate level programmers don't know such functions very much.
Honestly speaking, I don't know so much utility functions, too.
Even if I could search such functions,
users have to remember its name and the module including it.

Second, utility functions are written by many authors.
So, its naming rule/grouping rule/interface is defined by each author.
It is hard to remember the name/usage.

Third, in CPAN, new module are released daily.
One module is fast, but new faster one will be released(like JSON::Syck and JSON::XS).
If it's api is different, can you check and replace all of existing code? 

It's very regrettable for Perl.

Util::All aims to collect utility functions on CPAN and group them to appropriate kind
and rename them and/or change their api by common way.

If you know good utility functions, please tell me.
I want to add them into Util::All.

=head1 NAMING RULE

Current planned naming rule is:

 MODIFICATION_VERB(_OBJECT)
 KIND_VERBE
 to_OBJECT
 from_OBJECT

For example:

 cgi_escape ... CGI's escape
 cgi_unescape ... CGI's unescape
 base64_encode ... encode string by base64
 base64_unencode ... decode string by base64
 decode_html_entities  ... decode html entities
 encode_html_entities  ... encode html entities
 YAML::Syck::Load ...  from_yaml
 YAML::Syck::LoadFile ... to_yaml_file
 Mail::Sendmail::sendmail ... send_mail

But, some functions, which I think no need to add kind, are exception.
For example:

 today ... return today's DateTime object
 now ... return now DateTime object

etc.

=head1 EXPORT

functions which C<*> follows are generated by the way like Sub::Exporter.
see L<Util::Any/"USE Sub::Exporter's GENERATOR WAY">

=head2 -base64

=head3 base64_encode

encode_base64 of L<MIME::Base64>

=head3 base64_decode

decode_base64 of L<MIME::Base64>

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

=head3 functions of L<Benchmark>

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

like timethese but compare 2 code with same argument

=head3 cmpsamearg *

  cmpsamearg($count, {name => \&code, name2 => \&code}, \%samearg)

like cmpthese but compare 2 code with same argument

=head2 -carp

=head3 functions of L<Carp>

=head4 croak

=head4 cluck

=head4 carp

=head4 confess

=head4 shortmess

=head4 longmess

=head2 -cgi

=head3 html_entity_decode

decode_entities of L<HTML::Entities>

=head3 cgi_escape

escape of L<CGI::Util>

=head3 cgi_unescape

unescape of L<CGI::Util>

=head3 html_entity_encode

encode_entities of L<HTML::Entities>

=head2 -char_enc

=head3 char_from_to

from_to of L<Encode>

=head3 char_convert *

  char_convert($str, "euc-jp");
  char_convert($str, "euc-jp", "sjis");

convert $str to second argument charset. third argument is charset of $str.
when third argument is omitted, Encode::Detect(if installed) or Encode::Guess is used.


=head3 char_encode

encode of L<Encode>

=head3 char_decode

decode of L<Encode>

=head2 -datetime

=head3 functions to return DateTime object

  $dt = datetime(year => .., month => ..,);
  $dt = datetime_parse("2009/09/09");
  $dt = now;
  $dt = today;

=head3 functions to return DateTime::Duration object

NOTE THAT: end_of_month is set as limit.

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

example:

  $after_five_year_from_now = now + years 5;


=head3 function enable to rename *

now, today, datetime, hour, hours, second, month, minutes, days, seconds, minute, years, day, datetime_duration, year, months, datetime_parse

=head2 -debug

=head3 functions of L<Tie::Trace>

=head4 watch

=head3 functions of L<Data::Dump>

=head4 dump

=head4 pp

=head4 dd

=head4 ddx

=head3 dump

  print dump(@vars);
  dump(@vars);

dump of L<Data::Dumper>. 
dump strucutre. In later case, result is dumped to STDERR.


=head3 code_dumper *

  code_dumper(sub { print "hello World" })

dump code reference as string.

=head3 dumper

Dumper of L<Data::Dumper>

=head3 ddx

  dd(@vars);

as same as dd but output to STDOUT with line number.

=head3 dd

  dd(@vars);

as same as dump but output to STDOUT.

=head3 pp

  pp("{ x => 1, y => 2, z => 3}");

dump after given string is evaled.

=head3 dump_code *

  dump_code( sub { ... } );

dump code reference as string.

=head3 p *

  p($variable)

as same as dump(function name is borrowed from Ruby).

=head2 -file

=head3 functions of L<File::Path>

=head4 make_path

=head4 remove_tree

=head3 functions of L<File::Slurp>

=head4 read_file

=head4 write_file

=head3 find_file

find of L<File::Find>

=head3 move_file

move of L<File::Copy>

=head3 slurp_file

slurp of L<File::Slurp>

=head3 copy_file

copy of L<File::Copy>

=head2 -hash

=head3 indexed *

  indexed my %hash = (a => 1, b => 2);

%hash is indexed.

=head3 functions of L<Hash::Util>

=head4 hash_seed

=head4 lock_hash

=head4 lock_keys

=head4 lock_value

=head4 unlock_hash

=head4 unlock_keys

=head4 unlock_value

=head2 -html

=head3 html_entity_decode

decode_entities of L<HTML::Entities>

=head3 cgi_escape

escape of L<CGI::Util>

=head3 cgi_unescape

unescape of L<CGI::Util>

=head3 html_entity_encode

encode_entities of L<HTML::Entities>

=head2 -http

=head3 http_* functions

do http method and get HTTP::Response object.

  http_get($url, \%query);
  http_post($url, \%query);
  http_put($url, \%query);
  http_delete($url, \%query);
  http_head($url, \%query);


=head3 function enable to rename *

http_post, http_get, http_put, http_head, http_delete

=head2 -json

=head3 to_json_file *

  sub {
      require File::Slurp;
      sub { File::Slurp::write_file( shift, JSON::XS::encode_json(shift) ) }
    }


=head3 from_json

decode_json of L<JSON::XS>

=head3 to_json

encode_json of L<JSON::XS>

=head2 -list

=head3 functions of L<List::Util>

=head4 first

=head4 max

=head4 maxstr

=head4 min

=head4 minstr

=head4 reduce

=head4 shuffle

=head4 sum

=head3 functions of L<List::MoreUtils>

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

=head3 parse_mail *

  sub {
      sub { my $message = Email::MIME->new(@_) }
    }


=head3 send_mail *

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

=head3 functions of L<Digest::MD5>

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

=head3 functions of L<Return::Value>

=head4 success

=head4 failure

=head2 -scalar

=head3 functions of L<Scalar::Util>

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

=head3 functions of L<Digest::SHA>

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

=head3 functions of L<String::CamelCase>

=head4 camelize

=head4 decamelize

=head4 wordsplit

=head3 functions of L<String::Util>

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

=head3 functions of L<Time::HiRes>

=head4 usleep

=head4 nanosleep

=head4 ualarm

=head2 -uri

=head3 functions of L<URI::Escape>

=head4 uri_escape

=head4 uri_unescape

=head3 functions of L<URI::Split>

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

=head3 functions of L<utf8>

=head4 is_utf8

=head3 utf8_encode

encode of L<utf8>

=head3 utf8_off *

  sub {
      sub { Data::Visitor::Encode->new->Utf8_off(@_) }
    }


=head3 utf8_upgrade

upgrade of L<utf8>

=head3 utf8_downgrade

downgrade of L<utf8>

=head3 utf8_on *

  sub {
      sub { Data::Visitor::Encode->new->utf8_on(@_) }
    }


=head2 -xml

=head3 xml_dump *

  sub {
      my ( $pkg, $class, $func, $args, $kind_args ) = @_;
      $args->{KeyAttr} ||= $kind_args->{key_attr} || $args->{key_attr};
      sub {
          XML::Simple::XMLout( shift, %$args );
        }
    }


=head3 xml_load *

  sub {
      my ( $pkg, $class, $func, $args, $kind_args ) = @_;
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

=head3 to_yaml

Dump of L<YAML::XS>

=head3 to_yaml_file *

  sub {
      require File::Slurp;
      sub { File::Slurp::write_file( shift, YAML::XS::Dump(shift) ) }
    }


=head3 from_yaml_file *

  sub {
      require File::Slurp;
      sub { YAML::XS::Load( File::Slurp::slurp(shift) ) }
    }


=head3 from_yaml

Load of L<YAML::XS>



=head1 YAML FILE STRUCTURE

Util::All is generated from YAML file(functions.yml in distribution file).

Its first level keys are kinds of functions.
hashes of the kinds has four kinds of structures.

=head2 First:

All functions in @EXPORT, @EXPORT_OK of Module::Name can be imported.

 Module::Name: *

=head2 Second:

function_a and function_b of module::Name can be imported.

 Module::Name:
   - function_a
   - function_b

If you want to embed usage.

 Module::Name:
   - function_a
   - usage: 
     - exapmle
     - explanation
   - function_b
   - usage:
     - 
       - example1
       - example2
     - explanation

=head2 Third:

function_a of Module::Name can be imported as func_a.

 Module::Name:
   function_a: func_a

If you want to embed usage.

 Module::Name:
   function_a:
     - func_a
     - usage:
       - example
       - explanation

example can be array ref.

=head2 Fourth:

function_a is function enable to generate function.
See L<Util::Any/Sub::Exporter's GENERATOR WAY>.

 Module::Name:
   function_a: sub { sub { ... } }

If you want ot embed usage

 Module::Name:
   - function_a: sub { sub { ... } }
   - usage:
     - example
     - explanation

example can be array ref.

=head2 Automatically generated document

If not defined usage for functions, usage is automatically generated.

=over 4

=item selected functions

Module name is written.

=item renamed functions

Module name and original name are written.

=item generator functions

The source code is written.

=back

=head2 write all of usage for the kind?

use -usage key.

 datetime:
   -usage: |
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
     

If this is defined, all of other usage expressions, I showed you then in this section, are ignored.

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
But, of cource, -all loads all modules.

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

"All utility function are belong to Util::All";
