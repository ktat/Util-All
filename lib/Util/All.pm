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
    ],
    [
      'MIME::Base64::URLSafe',
      '',
      {
        '-select' => [],
        'urlsafe_b64decode' => 'urlsafe_base64_decode',
        'urlsafe_b64encode' => 'urlsafe_base64_encode'
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
        'encode_html_entities' => sub {
            my($pkg, $class, $func, $args, $kind_args) = @_;
            my $_words = $$kind_args{'words'} || $$args{'words'};
            sub {
                my($str, $words) = @_;
                utf8::decode($str) if not utf8::is_utf8($str);
                $str = HTML::Entities::encode_entities($str, $words || $_words);
                unless (defined wantarray) {
                    my $ref = \$_[0];
                    $$ref = $str;
                }
                return $str;
            }
            ;
        },
        '-select' => [],
        'decode_entities' => 'decode_html_entities'
      }
    ]
  ],
  '-charset' => [
    [
      'Unicode::Japanese',
      '',
      {
        'h2z_sym' => sub {
            sub {
                my $str = shift @_;
                my $method = utf8::is_utf8($str) ? 'getu' : 'get';
                Unicode::Japanese::unijp($str)->h2zSym->$method;
            }
            ;
        },
        '-select' => [],
        'h2z' => sub {
            sub {
                my $str = shift @_;
                my $method = utf8::is_utf8($str) ? 'getu' : 'get';
                Unicode::Japanese::unijp($str)->h2z->$method;
            }
            ;
        },
        'z2h_alpha' => sub {
            sub {
                my $str = shift @_;
                my $method = utf8::is_utf8($str) ? 'getu' : 'get';
                Unicode::Japanese::unijp($str)->z2hAlpha->$method;
            }
            ;
        },
        'z2h_num' => sub {
            sub {
                my $str = shift @_;
                my $method = utf8::is_utf8($str) ? 'getu' : 'get';
                Unicode::Japanese::unijp($str)->z2hNum->$method;
            }
            ;
        },
        'h2z_num' => sub {
            sub {
                my $str = shift @_;
                my $method = utf8::is_utf8($str) ? 'getu' : 'get';
                Unicode::Japanese::unijp($str)->h2zNum->$method;
            }
            ;
        },
        'h2z_kana' => sub {
            sub {
                my $str = shift @_;
                my $method = utf8::is_utf8($str) ? 'getu' : 'get';
                Unicode::Japanese::unijp($str)->h2zKana->$method;
            }
            ;
        },
        'z2h_sym' => sub {
            sub {
                my $str = shift @_;
                my $method = utf8::is_utf8($str) ? 'getu' : 'get';
                Unicode::Japanese::unijp($str)->z2hSym->$method;
            }
            ;
        },
        'h2z_alpha' => sub {
            sub {
                my $str = shift @_;
                my $method = utf8::is_utf8($str) ? 'getu' : 'get';
                Unicode::Japanese::unijp($str)->h2zAlpha->$method;
            }
            ;
        },
        'z2h' => sub {
            sub {
                my $str = shift @_;
                my $method = utf8::is_utf8($str) ? 'getu' : 'get';
                Unicode::Japanese::unijp($str)->z2h->$method;
            }
            ;
        },
        'z2h_kana' => sub {
            sub {
                my $str = shift @_;
                my $method = utf8::is_utf8($str) ? 'getu' : 'get';
                Unicode::Japanese::unijp($str)->z2hKana->$method;
            }
            ;
        }
      }
    ],
    [
      'Encode',
      '',
      {
        'from_to' => 'char_from_to',
        'jfold' => sub {
            my($pkg, $class, $func, $args, $kind_args) = @_;
            sub {
                my($str, $width, $nl) = @_;
                $width ||= $$kind_args{'width'} || $$args{'width'};
                $nl ||= $$kind_args{'nl'} || $$args{'nl'} || "\n";
                my $is_utf8 = 0;
                utf8::decode($str) if not $is_utf8 = utf8::is_utf8($str);
                my $cnt = 0;
                my @lines;
                my $l = '';
                foreach my $s ($str =~ /(.)/g) {
                    if ($s =~ /\p{ASCII}/ or $s =~ /\p{InHalfwidthAndFullwidthForms}/ and not $s =~ /[\p{Lu}\p{Ll}\p{LC}\p{Lt}\p{Lm}\p{S}\p{P}\p{N}]/) {
                        ++$cnt;
                    }
                    else {
                        $cnt += 2;
                    }
                    $l .= $s;
                    if ($cnt >= $width) {
                        push @lines, $l;
                        $cnt = 0;
                        $l = '';
                    }
                }
                push @lines, $l if $l;
                return $is_utf8 ? join($nl, @lines) : Encode::encode('utf8', join($nl, @lines));
            }
            ;
        },
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
                if (ref $str and utf8::is_utf8($$str)) {
                    utf8::encode($$str);
                }
                elsif (utf8::is_utf8($str)) {
                    utf8::encode($str);
                }
                Encode::from_to(ref $str ? $$str : $str, $from ? $from : ($g_class ? 'DETECT' : 'GUESS'), $to);
                return $str;
            }
            ;
        }
      }
    ]
  ],
  '-data' => [
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
  '-debug' => [
    [
      'Devel::Cycle',
      '',
      {
        '-select' => [
          'find_cycle'
        ]
      }
    ],
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
        'deep_dump' => sub {
            sub (@) {
                local $Data::Dumper::Deparse = 1;
                if (not defined wantarray) {
                    print STDERR Data::Dumper::Dumper(@_);
                }
                else {
                    return Data::Dumper::Dumper(@_);
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
        'ex_dumper' => sub {
            sub {
                my $keys = pop @_;
                my %tmp;
                @tmp{@$keys} = ();
                local $Data::Dumper::Sortkeys = sub {
                    my($hash) = @_;
                    return [grep({not exists $tmp{$_};} keys %$hash)];
                }
                ;
                Data::Dumper::Dumper(@_);
            }
            ;
        },
        'deep_dumper' => sub {
            sub (@) {
                local $Data::Dumper::Deparse = 1;
                Data::Dumper::Dumper(@_);
            }
            ;
        }
      }
    ],
    [
      'Devel::Size',
      '',
      {
        '-select' => [
          'size',
          'total_size'
        ]
      }
    ]
  ],
  '-encode' => [
    [
      'Encode',
      '',
      {
        '-select' => [
          'encode',
          'decode',
          'from_to'
        ]
      }
    ]
  ],
  '-exception' => [
    [
      'Try::Tiny',
      '',
      {
        '-select' => [
          'try',
          'catch'
        ]
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
      'File::Temp',
      '',
      {
        '-select' => [],
        'tempfile' => sub {
            my($pkg, $class, $func, $args, $kind_args) = @_;
            sub {
                my(@args) = @_;
                my(%args) = (%$kind_args, %$args, @args % 2 ? ('TEMPLATE', @args) : @args);
                my(%new_args) = map({uc $_, $args{$_};} keys %args);
                if (exists $new_args{'TEMPLATE'}) {
                    if ($new_args{'TEMPLATE'} =~ s/(X{4}X*)(.+)?$/$1/ or $new_args{'TEMPLATE'} =~ s/(\*)(.+)?$/XXXX/) {
                        $new_args{'SUFFIX'} ||= $2;
                    }
                    if (not $new_args{'TEMPLATE'} =~ /XXXX$/) {
                        $new_args{'TEMPLATE'} .= 'XXXX';
                    }
                }
                'File::Temp'->new(%new_args);
            }
            ;
        }
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
  '-http' => [
    [
      'HTTP::Request::Common',
      '',
      {
        'http_post' => sub {
            require LWP::UserAgent;
            my $ua = 'LWP::UserAgent'->new;
            sub {
                $ua->request(HTTP::Request::Common::POST(@_));
            }
            ;
        },
        'http_put' => sub {
            require LWP::UserAgent;
            my $ua = 'LWP::UserAgent'->new;
            sub {
                $ua->request(HTTP::Request::Common::PUT(@_));
            }
            ;
        },
        '-select' => [],
        'http_get' => sub {
            require LWP::UserAgent;
            my $ua = 'LWP::UserAgent'->new;
            sub {
                $ua->request(HTTP::Request::Common::GET(@_));
            }
            ;
        },
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
        'from_json_file' => sub {
            require File::Slurp;
            sub ($) {
                JSON::XS::decode_json(scalar File::Slurp::slurp(shift @_));
            }
            ;
        },
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
      'List::Pairwise',
      '',
      {
        '-select' => [
          'mapp',
          'grepp',
          'firstp',
          'lastp',
          'pair'
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
  '-oo' => [
    [
      'Class::Data::Inheritable',
      '',
      {
        '-select' => [],
        'classdata' => sub {
            my($pkg, $class, $func, $args, $kind_args) = @_;
            my $cc = (caller 2)[0];
            unless ($cc->isa('Class::Data::Inheritable')) {
                eval "push \@${cc}::ISA, 'Class::Data::Inheritable'";
            }
            $func = "mk_$func";
            sub {
                $cc->$func(@_);
            }
            ;
        }
      }
    ],
    [
      'Class::Accessor::Fast',
      '',
      {
        'wo_accessors' => sub {
            my($pkg, $class, $func, $args, $kind_args) = @_;
            my $cc = (caller 2)[0];
            $func = "mk_$func";
            sub {
                $cc->$func(@_);
            }
            ;
        },
        '-select' => [],
        'ro_accessors' => sub {
            my($pkg, $class, $func, $args, $kind_args) = @_;
            my $cc = (caller 2)[0];
            $func = "mk_$func";
            sub {
                $cc->$func(@_);
            }
            ;
        },
        'accessors' => sub {
            my($pkg, $class, $func, $args, $kind_args) = @_;
            my $cc = (caller 2)[0];
            unless ($cc->isa('Class::Accessor::Fast')) {
                eval "push \@${cc}::ISA, 'Class::Accessor::Fast'";
            }
            $func = "mk_$func";
            sub {
                $cc->$func(@_);
            }
            ;
        }
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
      'IO::String',
      '',
      {
        'to_fh' => sub {
            sub {
                my $scalar = shift @_;
                'IO::String'->new(\$scalar);
            }
            ;
        },
        '-select' => []
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
        ],
        'strings' => sub {
            sub {
                my $str = shift @_;
                $str =~ s/\p{Cc}//g;
                return $str;
            }
            ;
        }
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
      'Data::Recursive::Encode',
      '',
      {
        'utf8_off' => sub {
            sub {
                'Data::Recursive::Encode'->encode_utf8(@_);
            }
            ;
        },
        '-select' => [],
        'utf8_on' => sub {
            sub {
                'Data::Recursive::Encode'->decode_utf8(@_);
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
  '-utime' => [
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
            sub ($) {
                YAML::XS::Load(scalar File::Slurp::slurp(shift @_));
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

$Utils->{'-html'} = Clone::clone($Utils->{'-cgi'});
$Utils->{'-yml'}  = Clone::clone($Utils->{'-yaml'});

=head1 NAME

Util::All -  (alpha software) collect perl utilities and group them by appropriate kind.

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

 use Util::All -encode;
 $encoded = encode('utf8', $str); # Encode::encode
 $decoded = decode('utf8', $str); # Encode::decode
 from_to($str, $icode, 'utf8');   # Encode::from_to

or

 use Util::All -charset;
 $encoded = char_encode('utf8', $str); # Encode::encode
 $decoded = char_decode('utf8', $str); # Encode::decode
 char_from_to($str, $icode, 'utf8');   # Encode::from_to
 
-charset has other functions.
 
 use Util::All -charset;
 # $str will not be modified
 my $new_str = char_convert($str, 'utf8'[, $icode]); # use Encode::Detect or Encode::Guess if not set $icode

 # use Encode::Guess and pass encoding to guess
 use Util::All -charaset => {char_convert => {guess => ["sjis", "euc-jp"]}};
 char_convert($str, "euc-jp");

 print h2z("A"); 
 print z2h("А");
 print z2h_alpha("Аあ"); # only A is z2hed.

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

When you want all utilities (it is slow a bit)

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

=head3 urlsafe_base64_decode

urlsafe_b64decode of L<MIME::Base64::URLSafe>

=head3 base64_encode

encode_base64 of L<MIME::Base64>

=head3 urlsafe_base64_encode

urlsafe_b64encode of L<MIME::Base64::URLSafe>

=head3 base64_decode

decode_base64 of L<MIME::Base64>

=head2 -basecalc

=head3 from_base / to_base

  use Util::All -basecalc => {-args => {digits => [0,1]}};
  to_base(4);     # 100
  from_base(100); # 4


=head3 function enable to rename *

to_base, from_base

=head3 test code

 package test_basecalc1;
 use Util::All -basecalc => {-args => {digits => [0,1]}};
 (to_base(4), from_base(100));
 # equal to: 100, 4

 package test_basecalc2;
 use Util::All -basecalc => [to_base => {digits => [0,1], -as => 'to_base2'}];
 to_base2(4);
 # equal to: 100

 package test_basecalc3;
 use Util::All -basecalc => [from_base => {digits => [0,1], -as => 'from_base2'}];
 from_base2(100);
 # equal to: 4

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

like timethese but compare 2 code with same argument.
if $count can be negative or 0, it means the number of CPU seconds(0 is regarded as 3).


=head3 cmpsamearg *

  cmpsamearg($count, {name => \&code, name2 => \&code}, \%samearg)

like cmpthese but compare 2 code with same argument.
if $count can be negative or 0, it means the number of CPU seconds(0 is regarded as 3).


=head2 -carp

=head3 functions of L<Carp>

=head4 croak

=head4 cluck

=head4 carp

=head4 confess

=head4 shortmess

=head4 longmess

=head2 -cgi

=head3 encode_html_entities

  my $new_str = encode_html_entities($str, $words);
  encode_html_entities($str, $words);

encode HTML entity. in void context, it modify argument itself.
this function assumes given argument charset is utf8(utf8 flag on or off).

=head3 decode_html_entities

  @new_args = decode_html_entities(@args);
  decode_html_entities(@args);

decode HTML entity.  in void context, it modify argument itself.


=head3 function enable to rename *

encode_html_entities

=head3 test code

 no utf8;
 use Util::All -cgi;
 encode_html_entities("あいうえお");
 # equal to: '&#x3042;&#x3044;&#x3046;&#x3048;&#x304A;'

 use utf8;
 use Util::All -cgi;
 encode_html_entities("あいうえお");
 # equal to: '&#x3042;&#x3044;&#x3046;&#x3048;&#x304A;'

 no utf8;
 use Util::All -cgi;
 encode_html_entities(my $s = "あいうえお");
 $s;
 # equal to: '&#x3042;&#x3044;&#x3046;&#x3048;&#x304A;'

 use utf8;
 use Util::All -cgi;
 encode_html_entities(my $s = "あいうえお");
 $s;
 # equal to: '&#x3042;&#x3044;&#x3046;&#x3048;&#x304A;'

 no utf8;
 use Util::All -cgi;
 decode_html_entities(encode_html_entities("あいうえお"));
 # equal to: use utf8; 'あいうえお'

 use utf8;
 use Util::All -cgi;
 decode_html_entities(encode_html_entities("あいうえお"));
 # equal to: use utf8; 'あいうえお'

 no utf8;
 use Util::All -cgi;
 my $str = "あいうえお";
 encode_html_entities($str);
 $str;
 # equal to: '&#x3042;&#x3044;&#x3046;&#x3048;&#x304A;'

 no utf8;
 use Util::All -cgi;
 my $str = "あいうえお";
 scalar encode_html_entities($str);
 $str;
 # equal to: no utf8; 'あいうえお'

 package BB;
 no utf8;
 use Util::All -cgi => [encode_html_entities => {words => "<>"}];
 my $str = "あいうえお<&>";
 encode_html_entities($str);
 # equal to: use utf8; 'あいうえお&lt;&&gt;'

 package CC;
 no utf8;
 use Util::All -cgi => [-args => {words => "<>"}];
 my $str = "あいうえお<&>";
 encode_html_entities($str);
 # equal to: use utf8; 'あいうえお&lt;&&gt;'

 package DD;
 no utf8;
 use Util::All -cgi => [-args => {words => "<>"}];
 my $str = "あいうえお<&>";
 encode_html_entities($str, "&");
 # equal to: use utf8; 'あいうえお<&amp;>'

=head2 -charset

=head3 char_encode / char_decode

They are encode / decode of Encode.

=head3 char_convert

old Jocde style function.

 $new_str = char_convert($str, "euc-jp"); # to euc-jp
 $new_str = char_convert($str, "euc-jp", "sjis"); # to euc-jp from sjis

convert $str to second argument charset. third argument is charset of $str.
when third argument is omitted, Encode::Detect(if installed) or Encode::Guess is used to detect charset.

=head3 z2h functions

 z2h($str);       # return the value replaced zenkaku to hankaku
 z2h_kana($str);  # return the value replaced zenkaku kana hankaku
 z2h_num($str);   # return the value replaced zenkaku number hankaku
 z2h_sym($str);   # return the value replaced zenkaku symbol hankaku
 z2h_alpha($str); # return the value replaced zenkaku alphabet hankaku

If $str is utf8 flag on, return utf flagged value, if not return byte string.

=head3 h2z functions

 h2z($str);       # return the value replaced hankaku to zenkaku
 h2z_kana($str);  # return the value replaced hankaku kana zenkaku
 h2z_num($str);   # return the value replaced hankaku number zenkaku
 h2z_sym($str);   # return the value replaced hankaku symbol zenkaku
 h2z_alpha($str); # return the value replaced hankaku alphabet zenkaku

If $str is utf8 flag on, return utf flagged value, if not return byte string.

=head3 jfold

 jfold($sentense, $width, $new_line_char);
 jfold("アイウエオ１２３４ABCD（）＊＆", 4); # "アイ\nウエ\nオ１\n２３\n４AB\nCD（\n）＊\n＆"

This folds sentense. This regrads full-width char as 2 and half-width char as 1.
The given string must be utf-8(flgged or non flagged).

You can give default $width and/or $new_line_char.

 use Util::All -charset => [jfold => {width => 4, nl => "\t"}];

 jfold($str);
 jfold("アイウエオ１２３４ABCD（）＊＆"); # "アイ\tウエ\tオ１\t２３\t４AB\tCD（\t）＊\t＆";


=head3 function enable to rename *

h2z_sym, h2z, z2h_alpha, z2h_num, h2z_num, h2z_kana, z2h_sym, h2z_alpha, z2h, z2h_kana, jfold, char_convert

=head3 test code

 use Util::All -charset;
 jfold("アイウエオ１２３４ABCD（）＊＆", 4);
 # equal to: "アイ\nウエ\nオ１\n２３\n４AB\nCD（\n）＊\n＆"

 use Util::All -charset;
 jfold("ｱｲｳｴｵ１２３４ＡＢＣＤ（）＊", 4);
 # equal to: "ｱｲｳｴ\nｵ１２\n３４\nＡＢ\nＣＤ\n（）\n＊"

 use Util::All -charset;
 jfold("～！＠＃＄％＾＆＊（）＿＋＝ー／＼；？＞＜。、，．：｛｝「」［］｜『』《》〔〕", 4);
 # equal to: "～！\n＠＃\n＄％\n＾＆\n＊（\n）＿\n＋＝\nー／\n＼；\n？＞\n＜。\n、，\n．：\n｛｝\n「」\n［］\n｜『\n』《\n》〔\n〕"

 use Util::All -charset;
 jfold("アイウエオ１２３４ABCD（）＊＆", 4, "\t");
 # equal to: "アイ\tウエ\tオ１\t２３\t４AB\tCD（\t）＊\t＆"

 use utf8;
 use Util::All -charset;
 jfold("アイウエオ１２３４ABCD（）＊＆", 4, "\t");
 # equal to: use utf8; "アイ\tウエ\tオ１\t２３\t４AB\tCD（\t）＊\t＆"

 no utf8;
 use Util::All -charset;
 jfold("アイウエオ１２３４ABCD（）＊＆", 4, "\t");
 # equal to: no utf8; "アイ\tウエ\tオ１\t２３\t４AB\tCD（\t）＊\t＆"

 package charset_jfold;
 use Util::All -charset => [jfold => {width => 4, nl => "\t"}];
 jfold("アイウエオ１２３４ABCD（）＊＆");
 # equal to: no utf8; "アイ\tウエ\tオ１\t２３\t４AB\tCD（\t）＊\t＆"

 my $ss = char_convert(my $s = "あ", "euc-jp");
 $ss
 # equal to: my $s = "あ"; Encode::from_to($s, "utf8", "euc-jp"); $s;

 my $ss = char_convert(my $s = "あ", "cp932", "utf8");
 $ss
 # equal to: my $s = "あ"; Encode::from_to($s, "utf8", "cp932"); $s;

 use utf8;
 my $ss = char_convert(my $s = "あ", "euc-jp");
 $ss
 # equal to: my $s = "あ"; Encode::from_to($s, "utf8", "euc-jp"); $s;

 use utf8;
 my $ss = char_convert(my $s = "あ", "cp932", "utf8");
 $ss
 # equal to: my $s = "あ"; Encode::from_to($s, "utf8", "cp932"); $s;

 my $ss = char_convert(\(my $s = "あ"), "euc-jp");
 $$ss eq $s
 # equal to: 1;

 z2h('アイウエオ１２３４ＡＢＣＤ（）＊＆')
 # equal to: 'ｱｲｳｴｵ1234ABCD()*&'

 z2h_alpha('アイウエオ１２３４ＡＢＣＤ（）＊＆')
 # equal to: 'アイウエオ１２３４ABCD（）＊＆'

 z2h_sym('アイウエオ１２３４ＡＢＣＤ（）＊＆')
 # equal to: 'アイウエオ１２３４ＡＢＣＤ()*&'

 z2h_num('アイウエオ１２３４ＡＢＣＤ（）＊＆')
 # equal to: 'アイウエオ1234ＡＢＣＤ（）＊＆'

 z2h_kana('アイウエオ１２３４ＡＢＣＤ（）＊＆')
 # equal to: 'ｱｲｳｴｵ１２３４ＡＢＣＤ（）＊＆'

 h2z('ｱｲｳｴｵ1234ABCD()*&')
 # equal to: 'アイウエオ１２３４ＡＢＣＤ（）＊＆'

 h2z_alpha('ｱｲｳｴｵ1234ABCD()*&')
 # equal to: 'ｱｲｳｴｵ1234ＡＢＣＤ()*&'

 h2z_sym('ｱｲｳｴｵ1234ABCD()*&')
 # equal to: 'ｱｲｳｴｵ1234ABCD（）＊＆'

 h2z_num('ｱｲｳｴｵ1234ABCD()*&')
 # equal to: 'ｱｲｳｴｵ１２３４ABCD()*&'

 h2z_kana('ｱｲｳｴｵ1234ABCD()*&')
 # equal to: 'アイウエオ1234ABCD()*&'

 use utf8;
 z2h('アイウエオ１２３４ＡＢＣＤ（）＊＆')
 # equal to: use utf8; 'ｱｲｳｴｵ1234ABCD()*&'

 use utf8;
 z2h('アイウエオ１２３４ＡＢＣＤ（）＊＆')
 # equal to: use utf8; 'ｱｲｳｴｵ1234ABCD()*&'

=head2 -data

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

=head2 -debug

=head3 functions of L<Tie::Trace>

=head4 watch

=head3 functions of L<Devel::Cycle>

=head4 find_cycle

=head3 functions of L<Data::Dump>

=head4 dump

=head4 pp

=head4 dd

=head4 ddx

=head3 functions of L<Devel::Size>

=head4 size

=head4 total_size

=head3 dump

  print dump(@vars);
  dump(@vars);

dump of L<Data::Dump>. 
dump strucutre. In later case, result is dumped to STDERR.


=head3 deep_dumper *

  deep_dumper([1 , 2, sub { print "hello World" }])

dump code reference as string.

=head3 ex_dumper *

  ex_dumper($data, \@keys);
  ex_dumper($data, ['__MOP__']);


dump $data except @keys of hash

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

=head3 deep_dump *

  deep_dump([1,2,3, sub { ... } ]);

as same as dump. but it dump code reference as string.

=head3 p *

  p($variable)

as same as dump(function name is borrowed from Ruby).

=head3 test code

 use Util::All -debug;
 my $d = ex_dumper({hoge => 1, fuga => 2, foo => {hoge => 3}}, ['hoge']);
 my $VAR1;
 eval "$d";
 # equal to: {fuga => 2, foo => {}}

=head2 -encode

=head3 functions of L<Encode>

=head4 encode

=head4 decode

=head4 from_to

=head2 -exception

=head3 functions of L<Try::Tiny>

=head4 try

=head4 catch

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

=head3 tempfile *

  $tmpfile = tempfile("anyname*.dat");
  $tmpfile = tempfile("anynameXXXX.dat"); # as same as the above
  $tmpfile = tempfile("anyname*.dat", dir => '/var/tmp');
  $tmpfile = tempfile("anyname*", dir => '/var/tmp', suffix => '.dat', exlock => 0);
  $tmpfile = tempfile(template => "anyname*", dir => '/var/tmp', suffix => '.dat', exlock => 0);
  
  my $filename = $tmpfile->filename;
  print $tmpfile "Test";


create temporary file. on BSD derived systems, O_EXLOCK is used(see File::Temp manual).
If you don't want to lock temporary file, give exlock => 0 for arguments.


=head3 copy_file

copy of L<File::Copy>

=head3 test code

 use Util::All -file;
 my $fh = tempfile("anyname*.dat", dir => "./t/data/", unlink => 1);
 $fh->filename =~m{^t/data/anyname\w{4}\.dat$} || $fh->filename;
 # equal to: 1

 use Util::All -file;
 my $fh = tempfile(template => "anyname", dir => "./t/data/", suffix => ".tmp", unlink => 1);
 $fh->filename =~m{^t/data/anyname\w{4}\.tmp$} || $fh->filename;
 # equal to: 1

 use Util::All -file;
 my $fh = tempfile("anynameXXXXXXXX", dir => "./t/data/", suffix => ".tmp", unlink => 1);
 $fh->filename =~m{^t/data/anyname\w{8}\.tmp$} || $fh->filename;
 # equal to: 1

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

=head3 test code

 indexed my %hash;
 %hash = qw/5 1 4 2 3 3 2 4 1 5 0 6/;
 keys %hash
 # equal to: qw/5 4 3 2 1 0/

=head2 -http

=head3 http_* functions

do http method and get HTTP::Response object.

  http_get($url, \%query);
  http_post($url, \%query);
  http_put($url, \%query);
  http_delete($url, \%query);
  http_head($url, \%query);


=head3 function enable to rename *

http_post, http_put, http_get, http_head, http_delete

=head2 -json

=head3 to_json_file *

  from_json_file($json_file);

load JSON data from file

=head3 from_json_file *

  from_json_file($json_file);

load JSON data from file

=head3 from_json

decode_json of L<JSON::XS>

=head3 to_json

encode_json of L<JSON::XS>

=head3 test code

 package test_json;
 use Util::All -json, -debug;
 dump from_json(to_json({hoge => 1}));
 # equal to: '{ hoge => 1 }'

 package test_json;
 use Util::All -json;
 to_json(from_json_file("t/data/test.json"));
 # equal to: qq{{"hoge":1}}

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

=head3 functions of L<List::Pairwise>

=head4 mapp

=head4 grepp

=head4 firstp

=head4 lastp

=head4 pair

=head2 -md5

=head3 functions of L<Digest::MD5>

=head4 md5

=head4 md5_hex

=head4 md5_base64

=head2 -oo

provides simple OO interface.
constructor and accessors(Classs::Accessor::Fast and Class::Data::Inheritable)

=head3 new

  my $o = YourClass->new({foo => 1, bar => 1, buz => 2});

constructor.

=head3 accessors

  accessors(qw/foo bar buz/);

create get/set accessors.

=head3 ro_accessors

  ro_accessors(qw/foo bar buz/);

create get accessors.

=head3 wo_accessors

  wo_accessors(qw/foo bar buz/);

create set accessors.

=head3 classdata

  classdata(qw/Foo/);

create class data(Class::Data::Inheritable).


=head3 function enable to rename *

classdata, wo_accessors, ro_accessors, accessors

=head3 test code

 package Hoge1;
 use Util::All -oo;
 accessors("foo", "bar");
 my $o = Hoge1->new;
 $o->foo(100);
 $o->bar("ABC");
 ($o->foo, $o->bar);
 # equal to: (100, "ABC");

 package Hoge2;
 use Util::All -oo;
 ro_accessors("foo", "bar");
 my $o = Hoge2->new({foo => 200, bar => 300});
 ($o->foo, $o->bar);
 # equal to: (200, 300);

 package Hoge3;
 use Util::All -oo;
 wo_accessors("foo", "bar");
 my $o = Hoge3->new;
 ($o->foo(300), $o->bar(400));
 # equal to: (300, 400);

 package Hoge4;
 use Util::All -oo;
 ro_accessors("foo", "bar");
 my $o = Hoge2->new({foo => 200, bar => 300});
 eval {($o->foo(300), $o->bar(400))};
 if($@){1}else{0};
 # equal to: 1;

 package Hoge5;
 use Util::All -oo;
 wo_accessors("foo", "bar");
 my $o = Hoge3->new;
 ($o->foo(300), $o->bar(400));
 eval {($o->foo, $o->bar)};
 if($@){1}else{0};
 # equal to: 1;

 package Hoge6;
 use Util::All -oo;
 classdata("Foo");
 Hoge6->Foo("foo!");
 Hoge6->Foo;
 # equal to: "foo!"

 package Hoge7;
 use Util::All -oo;
 classdata("Foo");
 Hoge7->Foo("foo!");
 package Hoge8;
 push @Hoge8::ISA, 'Hoge7';
 my $s = Hoge8->Foo;
 Hoge8->Foo(100);
 $s.= Hoge8->Foo . Hoge7->Foo;
 # equal to: "foo!100foo!"

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

=head3 to_fh *

  my $fh = to_fh($scalar);
  print $_ while <$fh>;


create IO::String object, which can be used as filehandle.

=head3 strings *

  strings("111\0111");

abstract printable characgter from scalar. just like strings command.

=head3 test code

 use Util::All -string;
 my $s = "1\n2\n3\n4\n5\n";
 my $fh = to_fh($s);
 my $sum = 0;
 while (<$fh>){ chomp;
 $sum += $_ ;
 $sum++};
 $sum;
 # equal to: 20

=head3 test code

 package test_strings1;
 use Util::All -string;
 strings('111' . "\0" . '111');
 # equal to: "111111"

=head2 -uri

=head3 functions of L<URI::Escape>

=head4 uri_escape

=head4 uri_unescape

=head3 functions of L<URI::Split>

=head4 uri_split

=head4 uri_join

=head3 uri_make *

  uri_make('http://example.com/', { foo => "あ", bar => "い"});

create URI with parameter.

=head3 test code

 uri_make('http://example.com/', { foo => "あ", bar => "い"});
 # equal to: ('http://example.com/?bar=%E3%81%84&foo=%E3%81%82')

 my $x = "あ";
 utf8::decode($x);
 uri_make('http://example.com/', { foo => $x});
 # equal to: ('http://example.com/?foo=%E3%81%82')

=head2 -utf8

=head3 functions of L<utf8>

=head4 is_utf8

=head3 utf8_encode

encode of L<utf8>

=head3 utf8_off *

  my $d = utf8_off($data);

recursively make utf8 flag off(not destructive)

=head3 utf8_upgrade

upgrade of L<utf8>

=head3 utf8_downgrade

downgrade of L<utf8>

=head3 utf8_on *

  my $d = utf8_on($data);

recursively make utf8 flag on(not destructive)

=head3 test code

 package test_utf8_1;
 use Util::All -utf8;
 my $data = { a => "あ", b => {c => "い"}};
 my $d = utf8_on($data);
 is_utf8($d->{a}) && is_utf8($d->{b}{c});
 # equal to: 1

 package test_utf8_2;
 use utf8;
 use Util::All -utf8;
 my $data = { a => "あ", b => {c => "い"}};
 my $d = utf8_off($data);
 is_utf8($d->{a}) || is_utf8($d->{b}{c});
 # equal to: ''

=head2 -utime

=head3 functions of L<Time::HiRes>

=head4 usleep

=head4 nanosleep

=head4 ualarm

=head2 -yaml

=head3 to_yaml

Dump of L<YAML::XS>

=head3 to_yaml_file *

  to_yaml_file($yaml_file);

dump YAML data to file

=head3 from_yaml_file *

  from_yaml_file($yaml_file);

load YAML data from file

=head3 from_yaml

Load of L<YAML::XS>

=head3 test code

 package test_yaml;
 use Util::All -yaml, -debug;
 dump from_yaml(to_yaml({hoge => 1}));
 # equal to: '{ hoge => 1 }'

 package test_yaml;
 use Util::All -yaml;
 to_yaml(from_yaml_file("t/data/test.yml"));
 # equal to: "---\nhoge: 1\n"



=head1 PLUGINS

=over 4

=item L<Util::All::Plugin::Email>

=item L<Util::All::Plugin::Number>

=item L<Util::All::Plugin::Csv>

=item L<Util::All::Plugin::Xml>

=item L<Util::All::Plugin::Prompt>

=item L<Util::All::Plugin::Image>

=item L<Util::All::Plugin::Datetime>

=back

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
   - test:
    -
       - test code
       - return value

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
     - test:
       -
         - test code
         - return value

example can be array ref like the following.

     - usage:
       -
         -  example1
         -  example2
       - explanation

you cnan write code to skip test as the following.

     - test:
       - skip: $^O eq 'MSWin32';
       -
         - test code
         - return value

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

=head2 write all tests for the kind?

use -test key.

 datetime:
   -test:
     -
       - test code
       - return value
     -
       - test code
       - return value

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
So, '-all' is slow a bit. But, it is only first time, not slow next C<use>.

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

Thanks to All Perl Users.
When I find useful code, I write it here as memo.

=head1 SEE ALSO

=over 4

=item L<Util::Any>

This module is based on Util::Any.
Util::Any helps you to create your own utility module.

=back

=head1 COPYRIGHT & LICENSE

Copyright 2009-2010 Ktat, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut

"All utility function are belong to Util::All";
