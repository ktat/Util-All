package Util::All;

use warnings;
use strict;

use Util::Any -Base, -Pluggable;

our $Utils = {
  '-argv' => [
    [
      'Encode::Argv',
      '',
      {
        '-select' => [],
        '.' => sub {
            my($pkg, $class, $func, $args, $kind_args) = @_;
            my($in, $to) = ('utf8', '');
            if (ref $kind_args eq 'ARRAY') {
                ($in, $to) = @$kind_args;
            }
            elsif (ref $kind_args eq 'HASH') {
                $in = $$kind_args{'in'} || 'utf8';
                $to = $$kind_args{'to'};
            }
            else {
                $in = $kind_args;
            }
            'Encode::Argv'->import($in, $to ? $to : ());
        }
      }
    ]
  ],
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
                'Math::BaseCalc'->new('digits', $$args{'digits'} || $$kind_args{'digits'})->to_base(shift @_);
            }
            ;
        },
        '-select' => [],
        'from_base' => sub {
            my($pkg, $class, $func, $args, $kind_args) = @_;
            sub {
                'Math::BaseCalc'->new('digits', $$args{'digits'} || $$kind_args{'digits'})->from_base(shift @_);
            }
            ;
        }
      }
    ],
    [
      'Toolbox::Simple',
      '',
      {
        '-select' => [
          'dec2hex',
          'hex2dec',
          'dec2bin',
          'dec2oct',
          'oct2dec'
        ]
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
            my $_words = $$args{'words'} || $$kind_args{'words'};
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
                $width ||= $$args{'width'} || $$kind_args{'width'};
                $nl ||= $$args{'nl'} || $$kind_args{'nl'} || "\n";
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
        'readonly' => 'is_readonly',
        'isweak' => 'is_weak',
        '-select' => [
          'dualvar',
          'looks_like_number',
          'openhandle',
          'refaddr',
          'reftype',
          'set_prototype',
          'weaken'
        ],
        'blessed' => 'is_blessed',
        'tainted' => 'is_tainted',
        'isvstring' => 'is_vstring'
      }
    ],
    [
      'Data::Structure::Util',
      '',
      {
        '-select' => [
          'has_utf8',
          'unbless'
        ]
      }
    ],
    [
      'Data::Util',
      '',
      {
        '-select' => [
          'is_scalar_ref',
          'is_array_ref',
          'is_hash_ref',
          'is_code_ref',
          'is_glob_ref',
          'is_rx',
          'is_instance',
          'is_invocant',
          'is_value',
          'is_string',
          'is_number',
          'is_integer'
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
  '-dumper' => [
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
      'Path::Class',
      '',
      {
        '-select' => [
          'file',
          'dir'
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
            require Encode;
            require Data::Structure::Util;
            sub {
                my $d = shift @_;
                my $f = shift @_;
                File::Slurp::write_file($f, Data::Structure::Util::has_utf8($d) ? JSON::XS::encode_json($d) : Encode::encode('latin1', Encode::decode('utf8', JSON::XS::encode_json($d))));
            }
            ;
        },
        '-select' => [
          'encode_json',
          'decode_json'
        ],
        'from_json_file' => sub {
            require File::Slurp;
            sub ($) {
                JSON::XS::decode_json(scalar File::Slurp::slurp(shift @_));
            }
            ;
        },
        'from_json' => sub {
            sub {
                my $d = shift @_;
                'JSON::XS'->new->utf8(!utf8::is_utf8($d))->decode($d);
            }
            ;
        },
        'to_json' => sub {
            require Data::Structure::Util;
            require Encode;
            sub {
                my $d = shift @_;
                Data::Structure::Util::has_utf8($d) ? JSON::XS::encode_json($d) : Encode::encode('latin1', Encode::decode('utf8', JSON::XS::encode_json($d)));
            }
            ;
        }
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
  '-math' => [
    [
      'Toolbox::Simple',
      '',
      {
        '-select' => [
          'lcm',
          'gcd',
          'gcf',
          'is_prime'
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
  '-modern' => [
    [
      'strict',
      '',
      {
        '-select' => [],
        '.' => sub {
            my($pkg, $class, $func, $args, $kind_args) = @_;
            unless ($$kind_args{'disable'}) {
                'warnings'->import;
                'strict'->import;
                if ($] < 5.009005) {
                    require MRO::Compat;
                    'MRO::Compat'->import;
                }
                if ($] >= 5.01) {
                    require feature;
                    'feature'->import(':5.10');
                    &mro::set_mro(scalar caller(), 'c3');
                }
            }
        }
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
  '-storable' => [
    [
      'Storable',
      '',
      {
        'freeze' => sub {
            sub {
                Storable::freeze(@_);
            }
            ;
        },
        '-select' => [],
        'thaw' => sub {
            sub {
                Storable::thaw(@_);
            }
            ;
        }
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
            require LWP::Simple;
            require IO::File;
            sub {
                my $opt = $_[-1] =~ /^[rw+<>]+$/ ? pop @_ : '<';
                if (@_ == 1) {
                    my $target = $_[0];
                    if (ref $target eq 'SCALAR') {
                        return 'IO::String'->new($target);
                    }
                    elsif (not $target =~ /[\r\n]/ and -e $target) {
                        return $IO::File->new($target, $opt);
                    }
                    else {
                        return 'IO::String'->new(\$_[0]);
                    }
                }
                else {
                    my(%type) = @_;
                    if (defined $type{'url'}) {
                        my $scalar = LWP::Simple::get($type{'url'});
                        return 'IO::String'->new(\$scalar);
                    }
                    elsif (defined $type{'file'}) {
                        return 'IO::File'->new($type{'file'}, $opt);
                    }
                }
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
  '-subroutine' => [
    [
      'Data::Util',
      '',
      {
        '-select' => [
          'install_subroutine',
          'uninstall_subroutine',
          'get_code_info',
          'get_code_ref',
          'curry',
          'modify_subroutine',
          'subroutine_modifier'
        ]
      }
    ]
  ],
  '-unicode' => [
    [
      'Unicode::String',
      '',
      {
        '-select' => [
          'utf32be',
          'utf32le',
          'utf16be',
          'utf16le',
          'utf8',
          'utf7',
          'latin1',
          'uhex',
          'uchr'
        ]
      }
    ],
    [
      'Unicode::CharName',
      '',
      {
        '-select' => [],
        'unicode_name' => sub {
            require Unicode::CharName;
            require Encode;
            sub {
                my $s = shift @_;
                Unicode::CharName::uname($s =~ /\D/ ? ord(utf8::is_utf8($s) ? $s : Encode::decode('utf8', $s)) : $s);
            }
            ;
        },
        'unicode_block' => sub {
            require Unicode::CharName;
            require Encode;
            sub {
                my $s = shift @_;
                Unicode::CharName::ublock($s =~ /\D/ ? ord(utf8::is_utf8($s) ? $s : Encode::decode('utf8', $s)) : $s);
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
            if ('URI'->VERSION <= 1.35) {
                sub {
                    my($url, $form) = @_;
                    my %form;
                    foreach my $k (keys %$form) {
                        my($key, $value) = ($k, $$form{$k});
                        utf8::encode($key) if utf8::is_utf8($k);
                        utf8::encode($value) if utf8::is_utf8($value);
                        $form{$key} = $value;
                    }
                    my $u = 'URI'->new($url);
                    $u->query_form(%form);
                    $u->as_string;
                }
                ;
            }
            else {
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
        'to_yaml' => sub {
            require Encode;
            require Data::Structure::Util;
            require Data::Recursive::Encode;
            sub {
                my $data = shift @_;
                $data = 'Data::Recursive::Encode'->decode('utf8', $data) unless Data::Structure::Util::has_utf8($data);
                YAML::XS::Dump($data);
            }
            ;
        },
        'to_yaml_file' => sub {
            require Encode;
            require Data::Structure::Util;
            require Data::Recursive::Encode;
            sub {
                my($data, $file) = @_;
                $data = 'Data::Recursive::Encode'->decode('utf8', $data) unless Data::Structure::Util::has_utf8($data);
                File::Slurp::write_file($file, YAML::XS::Dump($data));
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
        'from_yaml' => sub {
            require Encode;
            sub {
                my $yaml = shift @_;
                YAML::XS::Load(utf8::is_utf8($yaml) ? Encode::encode('utf8', $yaml) : $yaml);
            }
            ;
        },
        'Load' => 'decode_yaml',
        'Dump' => 'encode_yaml'
      }
    ]
  ],
  '-yml' => [
    [
      'YAML::XS',
      '',
      {
        'to_yaml_file' => sub {
            require Encode;
            require Data::Structure::Util;
            require Data::Recursive::Encode;
            sub {
                my($data, $file) = @_;
                $data = 'Data::Recursive::Encode'->decode('utf8', $data) unless Data::Structure::Util::has_utf8($data);
                File::Slurp::write_file($file, YAML::XS::Dump($data));
            }
            ;
        },
        'to_yaml' => sub {
            require Encode;
            require Data::Structure::Util;
            require Data::Recursive::Encode;
            sub {
                my $data = shift @_;
                $data = 'Data::Recursive::Encode'->decode('utf8', $data) unless Data::Structure::Util::has_utf8($data);
                YAML::XS::Dump($data);
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
        'Dump' => 'encode_yaml',
        'Load' => 'decode_yaml',
        'from_yaml' => sub {
            require Encode;
            sub {
                my $yaml = shift @_;
                YAML::XS::Load(utf8::is_utf8($yaml) ? Encode::encode('utf8', $yaml) : $yaml);
            }
            ;
        }
      }
    ]
  ]
}
;

sub _default_kinds { '-modern', '-dumper' }

$Utils->{'-yml'}    = Clone::clone($Utils->{'-yaml'});

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
 use Util::All -charset => {char_convert => {guess => ["sjis", "euc-jp"]}};
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
 KIND_VERB
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

=head2 -argv

make @ARGV's utf8 flag on/encode @ARGV.

  use Util::All -argv; # @ARGV's utf8 flag on (argument is regarded as UTF8)
  use Util::All -argv => [-args => 'euc-jp']; # @ARGV's utf8 flag on (argument is regarded as euc-jp)
  use Util::All -argv => [-args => ['utf8', 'euc-jp']]; # convert utf8 to euc-jp
  use Util::All -argv => [-args => { in => 'utf8', to => 'euc-jp'}]; # as same as the above


=head2 -base64

=head3 urlsafe_base64_decode

(urlsafe_b64decode of L<MIME::Base64::URLSafe>)

=head3 base64_encode

(encode_base64 of L<MIME::Base64>)





Encode data by calling the encode_base64() function.  The first
argument is the string to encode.  The second argument is the
line-ending sequence to use.  It is optional and defaults to "\n".  The
returned encoded string is broken into lines of no more than 76
characters each and it will end with $eol unless it is empty.  Pass an
empty string as second argument if you do not want the encoded string
to be broken into lines.



=head3 urlsafe_base64_encode

(urlsafe_b64encode of L<MIME::Base64::URLSafe>)

=head3 base64_decode

(decode_base64 of L<MIME::Base64>)



Decode a base64 string by calling the decode_base64() function.  This
function takes a single argument which is the string to decode and
returns the decoded data.

Any character not part of the 65-character base64 subset is
silently ignored.  Characters occurring after a '=' padding character
are never decoded.

If the length of the string to decode, after ignoring
non-base64 chars, is not a multiple of 4 or if padding occurs too early,
then a warning is generated if perl is running under C<-w>.



=head2 -basecalc

=head3 from_base / to_base

  use Util::All -basecalc => [-args => {digits => [0,1]}];
  to_base(4);     # 100
  from_base(100); # 4


=head3 test code

 package test_basecalc1;
 use Util::All -basecalc => [-args => {digits => [0,1]}];
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

=head4 timeit(COUNT, CODE)

Arguments: COUNT is the number of times to run the loop, and CODE is
the code to run.  CODE may be either a code reference or a string to
be eval'd; either way it will be run in the caller's package.

Returns: a Benchmark object.


=head4 timethis ( COUNT, CODE, [ TITLE, [ STYLE ]] )

Time COUNT iterations of CODE. CODE may be a string to eval or a
code reference; either way the CODE will run in the caller's package.
Results will be printed to STDOUT as TITLE followed by the times.
TITLE defaults to "timethis COUNT" if none is provided. STYLE
determines the format of the output, as described for timestr() below.

The COUNT can be zero or negative: this means the I<minimum number of
CPU seconds> to run.  A zero signifies the default of 3 seconds.  For
example to run at least for 10 seconds:

	timethis(-10, $code)

or to run two pieces of code tests for at least 3 seconds:

	timethese(0, { test1 => '...', test2 => '...'})

CPU seconds is, in UNIX terms, the user time plus the system time of
the process itself, as opposed to the real (wallclock) time and the
time spent by the child processes.  Less than 0.1 seconds is not
accepted (-0.01 as the count, for example, will cause a fatal runtime
exception).

Note that the CPU seconds is the B<minimum> time: CPU scheduling and
other operating system factors may complicate the attempt so that a
little bit more time is spent.  The benchmark output will, however,
also tell the number of C<$code> runs/second, which should be a more
interesting number than the actually spent seconds.

Returns a Benchmark object.


=head4 timethese ( COUNT, CODEHASHREF, [ STYLE ] )

The CODEHASHREF is a reference to a hash containing names as keys
and either a string to eval or a code reference for each value.
For each (KEY, VALUE) pair in the CODEHASHREF, this routine will
call

	timethis(COUNT, VALUE, KEY, STYLE)

The routines are called in string comparison order of KEY.

The COUNT can be zero or negative, see timethis().

Returns a hash reference of Benchmark objects, keyed by name.


=head4 timediff ( T1, T2 )

Returns the difference between two Benchmark times as a Benchmark
object suitable for passing to timestr().


=head4 timestr ( TIMEDIFF, [ STYLE, [ FORMAT ] ] )

Returns a string that formats the times in the TIMEDIFF object in
the requested STYLE. TIMEDIFF is expected to be a Benchmark object
similar to that returned by timediff().

STYLE can be any of 'all', 'none', 'noc', 'nop' or 'auto'. 'all' shows
each of the 5 times available ('wallclock' time, user time, system time,
user time of children, and system time of children). 'noc' shows all
except the two children times. 'nop' shows only wallclock and the
two children times. 'auto' (the default) will act as 'all' unless
the children times are both zero, in which case it acts as 'noc'.
'none' prevents output.

FORMAT is the L<printf(3)>-style format specifier (without the
leading '%') to use to print the times. It defaults to '5.2f'.


=head4 cmpthese ( COUNT, CODEHASHREF, [ STYLE ] )


=head4 cmpthese ( RESULTSHASHREF, [ STYLE ] )

Optionally calls timethese(), then outputs comparison chart.  This:

    cmpthese( -1, { a => "++\$i", b => "\$i *= 2" } ) ;

outputs a chart like:

           Rate    b    a
    b 2831802/s   -- -61%
    a 7208959/s 155%   --

This chart is sorted from slowest to fastest, and shows the percent speed
difference between each pair of tests.

c<cmpthese> can also be passed the data structure that timethese() returns:

    $results = timethese( -1, { a => "++\$i", b => "\$i *= 2" } ) ;
    cmpthese( $results );

in case you want to see both sets of results.
If the first argument is an unblessed hash reference,
that is RESULTSHASHREF; otherwise that is COUNT.

Returns a reference to an ARRAY of rows, each row is an ARRAY of cells from the
above chart, including labels. This:

    my $rows = cmpthese( -1, { a => '++$i', b => '$i *= 2' }, "none" );

returns a data structure like:

    [
        [ '',       'Rate',   'b',    'a' ],
        [ 'b', '2885232/s',  '--', '-59%' ],
        [ 'a', '7099126/s', '146%',  '--' ],
    ]

B<NOTE>: This result value differs from previous versions, which returned
the C<timethese()> result structure.  If you want that, just use the two
statement C<timethese>...C<cmpthese> idiom shown above.

Incidently, note the variance in the result values between the two examples;
this is typical of benchmarking.  If this were a real benchmark, you would
probably want to run a lot more iterations.


=head4 countit(TIME, CODE)

Arguments: TIME is the minimum length of time to run CODE for, and CODE is
the code to run.  CODE may be either a code reference or a string to
be eval'd; either way it will be run in the caller's package.

TIME is I<not> negative.  countit() will run the loop many times to
calculate the speed of CODE before running it for TIME.  The actual
time run for will usually be greater than TIME due to system clock
resolution, so it's best to look at the number of iterations divided
by the times that you are concerned with, not just the iterations.

Returns: a Benchmark object.


=head4 timesum ( T1, T2 )

Returns the sum of two Benchmark times as a Benchmark object suitable
for passing to timestr().


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





=over 8

=item carp

- warn of errors (from perspective of caller)

=item cluck

- warn of errors with stack backtrace

=item croak

- die of errors (from perspective of caller)

=item confess

- die of errors with stack backtrace


=back


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


=head3 test code

 package AAA;
 no utf8;
 use Util::All -cgi;
 encode_html_entities("あいうえお");
 # equal to: '&#x3042;&#x3044;&#x3046;&#x3048;&#x304A;'

 package BBB;
 use utf8;
 use Util::All -cgi;
 encode_html_entities("あいうえお");
 # equal to: '&#x3042;&#x3044;&#x3046;&#x3048;&#x304A;'

 package CCC;
 no utf8;
 use Util::All -cgi;
 encode_html_entities(my $s = "あいうえお");
 $s;
 # equal to: '&#x3042;&#x3044;&#x3046;&#x3048;&#x304A;'

 package DDD;
 use utf8;
 use Util::All -cgi;
 encode_html_entities(my $s = "あいうえお");
 $s;
 # equal to: '&#x3042;&#x3044;&#x3046;&#x3048;&#x304A;'

 package EEE;
 no utf8;
 use Util::All -cgi;
 decode_html_entities(encode_html_entities("あいうえお"));
 # equal to: use utf8; 'あいうえお'

 package FFF;
 use utf8;
 use Util::All -cgi;
 decode_html_entities(encode_html_entities("あいうえお"));
 # equal to: use utf8; 'あいうえお'

 package GGG;
 no utf8;
 use Util::All -cgi;
 my $str = "あいうえお";
 encode_html_entities($str);
 $str;
 # equal to: '&#x3042;&#x3044;&#x3046;&#x3048;&#x304A;'

 package HHH;
 no utf8;
 use Util::All -cgi;
 my $str = "あいうえお";
 scalar encode_html_entities($str);
 $str;
 # equal to: no utf8; 'あいうえお'

 package III;
 no utf8;
 use Util::All -cgi => [encode_html_entities => {words => "<>"}];
 my $str = "あいうえお<&>";
 encode_html_entities($str);
 # equal to: use utf8; 'あいうえお&lt;&&gt;'

 package JJJ;
 no utf8;
 use Util::All -cgi => [-args => {words => "<>"}];
 my $str = "あいうえお<&>";
 encode_html_entities($str);
 # equal to: use utf8; 'あいうえお&lt;&&gt;'

 package KKK;
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

 jfold($sentence, $width, $new_line_char);
 jfold("アイウエオ１２３４ABCD（）＊＆", 4); # "アイ\nウエ\nオ１\n２３\n４AB\nCD（\n）＊\n＆"

This folds sentence. This regards full-width char as 2 and half-width char as 1.
The given string must be utf-8(flagged or non flagged).

You can give default $width and/or $new_line_char.

 use Util::All -charset => [jfold => {width => 4, nl => "\t"}];

 jfold($str);
 jfold("アイウエオ１２３４ABCD（）＊＆"); # "アイ\tウエ\tオ１\t２３\t４AB\tCD（\t）＊\t＆";


=head3 test code

 package AAA;
 use Util::All -charset;
 jfold("アイウエオ１２３４ABCD（）＊＆", 4);
 # equal to: "アイ\nウエ\nオ１\n２３\n４AB\nCD（\n）＊\n＆"

 package BBB;
 use Util::All -charset;
 jfold("ｱｲｳｴｵ１２３４ＡＢＣＤ（）＊", 4);
 # equal to: "ｱｲｳｴ\nｵ１２\n３４\nＡＢ\nＣＤ\n（）\n＊"

 package CCC;
 use Util::All -charset;
 jfold("～！＠＃＄％＾＆＊（）＿＋＝ー／＼；？＞＜。、，．：｛｝「」［］｜『』《》〔〕", 4);
 # equal to: "～！\n＠＃\n＄％\n＾＆\n＊（\n）＿\n＋＝\nー／\n＼；\n？＞\n＜。\n、，\n．：\n｛｝\n「」\n［］\n｜『\n』《\n》〔\n〕"

 package DDD;
 use Util::All -charset;
 jfold("アイウエオ１２３４ABCD（）＊＆", 4, "\t");
 # equal to: "アイ\tウエ\tオ１\t２３\t４AB\tCD（\t）＊\t＆"

 package EEE;
 use utf8;
 use Util::All -charset;
 jfold("アイウエオ１２３４ABCD（）＊＆", 4, "\t");
 # equal to: use utf8; "アイ\tウエ\tオ１\t２３\t４AB\tCD（\t）＊\t＆"

 package FFF;
 no utf8;
 use Util::All -charset;
 jfold("アイウエオ１２３４ABCD（）＊＆", 4, "\t");
 # equal to: no utf8; "アイ\tウエ\tオ１\t２３\t４AB\tCD（\t）＊\t＆"

 package GGG;
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

=head3 is_readonly

(readonly of L<Scalar::Util>)



Returns true if SCALAR is readonly.

    sub foo { readonly($_[0]) }

    $readonly = foo($bar);              # false
    $readonly = foo(0);                 # true



=head3 functions of L<Scalar::Util>

=head4 dualvar NUM, STRING

Returns a scalar that has the value NUM in a numeric context and the
value STRING in a string context.

    $foo = dualvar 10, "Hello";
    $num = $foo + 2;                    # 12
    $str = $foo . " world";             # Hello world


=head4 looks_like_number EXPR

Returns true if perl thinks EXPR is a number. See
L<perlapi/looks_like_number>.


=head4 openhandle FH

Returns FH if FH may be used as a filehandle and is open, or FH is a tied
handle. Otherwise C<undef> is returned.

    $fh = openhandle(*STDIN);		# \*STDIN
    $fh = openhandle(\*STDIN);		# \*STDIN
    $fh = openhandle(*NOTOPEN);		# undef
    $fh = openhandle("scalar");		# undef
    

=head4 refaddr EXPR

If EXPR evaluates to a reference the internal memory address of
the referenced value is returned. Otherwise C<undef> is returned.

    $addr = refaddr "string";           # undef
    $addr = refaddr \$var;              # eg 12345678
    $addr = refaddr [];                 # eg 23456784

    $obj  = bless {}, "Foo";
    $addr = refaddr $obj;               # eg 88123488


=head4 reftype EXPR

If EXPR evaluates to a reference the type of the variable referenced
is returned. Otherwise C<undef> is returned.

    $type = reftype "string";           # undef
    $type = reftype \$var;              # SCALAR
    $type = reftype [];                 # ARRAY

    $obj  = bless {}, "Foo";
    $type = reftype $obj;               # HASH


=head4 set_prototype CODEREF, PROTOTYPE

Sets the prototype of the given function, or deletes it if PROTOTYPE is
undef. Returns the CODEREF.

    set_prototype \&foo, '$$';


=head4 weaken REF

REF will be turned into a weak reference. This means that it will not
hold a reference count on the object it references. Also when the reference
count on that object reaches zero, REF will be set to undef.

This is useful for keeping copies of references , but you don't want to
prevent the object being DESTROY-ed at its usual time.

    {
      my $var;
      $ref = \$var;
      weaken($ref);                     # Make $ref a weak reference
    }
    # $ref is now undef

Note that if you take a copy of a scalar with a weakened reference,
the copy will be a strong reference.

    my $var;
    my $foo = \$var;
    weaken($foo);                       # Make $foo a weak reference
    my $bar = $foo;                     # $bar is now a strong reference

This may be less obvious in other situations, such as C<grep()>, for instance
when grepping through a list of weakened references to objects that may have
been destroyed already:

    @object = grep { defined } @object;

This will indeed remove all references to destroyed objects, but the remaining
references to objects will be strong, causing the remaining objects to never
be destroyed because there is now always a strong reference to them in the
@object array.


=head3 functions of L<Data::Structure::Util>

=head4 unbless($ref)

Remove the blessing from any objects found within the passed data
structure. For example:

    my $foo = {
        'a' => bless( { 'b' => bless( {}, "c" ), }, "d" ),
        'e' => [ bless( [], "f" ), bless( [], "g" ), ]
    };

    use Data::Dumper;
    use Data::Structure::Util qw(unbless);
    print Dumper( unbless( $foo ) );

    $VAR1 = {
        'a' => { 'b' => {} },
        'e' => [ [], [] ]
    };

Note that the structure looks inside blessed objects for other
objects to unbless.


=head4 has_utf8($var)

Returns C<$var> if the utf8 flag is enabled for C<$var> or any scalar
that a data structure passed in C<$var> contains.

    print "this will be printed"  if defined has_utf8( "\x{1234}" );
    print "this won't be printed" if defined has_utf8( "foo bar" );

Note that you should not check the truth of the return value of this
function when calling it with a single scalar as it is possible to
have a string "0" or "" for which the utf8 flag set; Since C<undef>
can never have the utf8 flag set the function will never return a
defined value if the data structure does not contain a utf8 flagged
scalar.


=head3 functions of L<Data::Util>

=head4 is_scalar_ref(value)

For a SCALAR reference.


=head4 is_array_ref(value)

For an ARRAY reference.


=head4 is_hash_ref(value)

For a HASH reference.


=head4 is_code_ref(value)

For a CODE reference.


=head4 is_glob_ref(value)

For a GLOB reference.


=head4 is_rx(value)

For a regular expression reference generated by the C<qr//> operator.


=head4 is_instance(value, class)

For an instance of I<class>.

It is equivalent to something like
C<< Scalar::Util::blessed($value) && $value->isa($class) >>.


=head4 is_invocant(value)

For an invocant, i.e. a blessed reference or existent package name.

If I<value> is a valid class name but does not exist, it will return false.


=head4 is_value(value)

Checks whether I<value> is a primitive value, i.e. a defined, non-ref, and
non-type-glob value.

This function has no counterpart for validation.


=head4 is_string(value)

Checks whether I<value> is a string with non-zero-length contents,
equivalent to C<< is_value($value) && length($value) > 0 >>.

This function has no counterpart for validation.


=head4 is_number(value)

Checks whether I<value> is a number.
Here, a B<number> means that the perl parser can understand it and that
the perl numeric converter (e.g. invoked by C<< sprintf '%g', $value >>)
doesn't complain about it.

It is similar to C<Scalar::Util::looks_like_number()>
but refuses C<infinity>, C<not a number> and C<"0 but true">.
Note that C<9**9**9> makes C<infinity> and C<9**9**9 - 9**9**9> makes
C<not a number>.

This function has no counterpart for validation.


=head4 is_integer(value)

Checks whether I<value> is an integer.
An B<integer> is also a B<number>, so this function
refuses C<infinity> and C<not a number>. See also C<is_number()>.

This function has no counterpart for validation.


=head3 is_weak

(isweak of L<Scalar::Util>)



If EXPR is a scalar which is a weak reference the result is true.

    $ref  = \$foo;
    $weak = isweak($ref);               # false
    weaken($ref);
    $weak = isweak($ref);               # true

B<NOTE>: Copying a weak reference creates a normal, strong, reference.

    $copy = $ref;
    $weak = isweak($ref);               # false



=head3 is_vstring

(isvstring of L<Scalar::Util>)



If EXPR is a scalar which was coded as a vstring the result is true.

    $vs   = v49.46.48;
    $fmt  = isvstring($vs) ? "%vd" : "%s"; #true
    printf($fmt,$vs);



=head3 is_tainted

(tainted of L<Scalar::Util>)



Return true if the result of EXPR is tainted

    $taint = tainted("constant");       # false
    $taint = tainted($ENV{PWD});        # true if running under -T



=head3 is_blessed

(blessed of L<Scalar::Util>)



If EXPR evaluates to a blessed reference the name of the package
that it is blessed into is returned. Otherwise C<undef> is returned.

   $scalar = "foo";
   $class  = blessed $scalar;           # undef

   $ref    = [];
   $class  = blessed $ref;              # undef

   $obj    = bless [], "Foo";
   $class  = blessed $obj;              # "Foo"



=head2 -debug

=head3 functions of L<Tie::Trace>

=head4 watch

 watch $variables;

 watch $scalar, %options;
 watch @array, %options;
 watch %hash, %options;

When you C<watch> variables and value is stored/delete in the variables,
warn the message like as the following.

 main:: %hash => {key} => value at ...

If the variables has values before C<watch>, it is no problem. Tie::Trace work well.

 my %hash = (key => 'value');
 watch %hash;


=head3 functions of L<Devel::Cycle>

=head4 find_cycle($object_reference,[$callback])

The find_cycle() function will traverse the object reference and print
a report to STDOUT identifying any memory cycles it finds.

If an optional callback code reference is provided, then this callback
will be invoked on each cycle that is found.  The callback will be
passed an array reference pointing to a list of lists with the
following format:

 $arg = [ ['REFTYPE',$index,$reference,$reference_value],
          ['REFTYPE',$index,$reference,$reference_value],
          ['REFTYPE',$index,$reference,$reference_value],
           ...
        ]

Each element in the array reference describes one edge in the memory
cycle.  'REFTYPE' describes the type of the reference and is one of
'SCALAR','ARRAY' or 'HASH'.  $index is the index affected by the
reference, and is undef for a scalar, an integer for an array
reference, or a hash key for a hash.  $reference is the memory
reference, and $reference_value is its dereferenced value.  For
example, if the edge is an ARRAY, then the following relationship
holds:

   $reference->[$index] eq $reference_value

The first element of the array reference is the $object_reference that
you pased to find_cycle() and may not be directly involved in the
cycle.

If a reference is a weak ref produced using Scalar::Util's weaken()
function then it won't contribute to cycles.


=head3 functions of L<Data::Dump>

=head4 dump( ... )


=head4 pp( ... )

Returns a string containing a Perl expression.  If you pass this
string to Perl's built-in eval() function it should return a copy of
the arguments you passed to dump().

If you call the function with multiple arguments then the output will
be wrapped in parenthesis "( ..., ... )".  If you call the function with a
single argument the output will not have the wrapping.  If you call the function with
a single scalar (non-reference) argument it will just return the
scalar quoted if needed, but never break it into multiple lines.  If you
pass multiple arguments or references to arrays of hashes then the
return value might contain line breaks to format it for easier
reading.  The returned string will never be "\n" terminated, even if
contains multiple lines.  This allows code like this to place the
semicolon in the expected place:

   print '$obj = ', dump($obj), ";\n";

If dump() is called in void context, then the dump is printed on
STDERR and then "\n" terminated.  You might find this useful for quick
debug printouts, but the dd*() functions might be better alternatives
for this.

There is no difference between dump() and pp(), except that dump()
shares its name with a not-so-useful perl builtin.  Because of this
some might want to avoid using that name.


=head4 dd( ... )


=head4 ddx( ... )

These functions will call dump() on their argument and print the
result to STDOUT (actually, it's the currently selected output handle, but
STDOUT is the default for that).

The difference between them is only that ddx() will prefix the lines
it prints with "# " and mark the first line with the file and line
number where it was called.  This is meant to be useful for debug
printouts of state within programs.


=head3 functions of L<Devel::Size>

=head4 size($ref)

The C<size> function returns the amount of memory the variable
returns.  If the variable is a hash or an array, it only reports
the amount used by the structure, I<not> the contents.


=head4 total_size($ref)

The C<total_size> function will traverse the variable and look
at the sizes of contents.  Any references contained in the variable
will also be followed, so this function can be used to get the
total size of a multidimensional data structure.  At the moment
there is no way to get the size of an array or a hash and its
elements without using this function.


=head3 dump

  print dump(@vars);
  dump(@vars);

dump of L<Data::Dump>. 
dump structure. In later case, result is dumped to STDERR.


=head3 deep_dumper *

  deep_dumper([1 , 2, sub { print "hello World" }])

dump code reference as string.

=head3 ex_dumper *

  ex_dumper($data, \@keys);
  ex_dumper($data, ['__MOP__']);


dump $data except @keys of hash

=head3 dumper

(Dumper of L<Data::Dumper>)



Returns the stringified form of the values in the list, subject to the
configuration options below.  The values will be named C<$VAR>I<n> in the
output, where I<n> is a numeric suffix.  Will return a list of strings
in a list context.





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

=head2 -dumper

=head3 functions of L<Data::Dump>

=head4 dump( ... )


=head4 pp( ... )

Returns a string containing a Perl expression.  If you pass this
string to Perl's built-in eval() function it should return a copy of
the arguments you passed to dump().

If you call the function with multiple arguments then the output will
be wrapped in parenthesis "( ..., ... )".  If you call the function with a
single argument the output will not have the wrapping.  If you call the function with
a single scalar (non-reference) argument it will just return the
scalar quoted if needed, but never break it into multiple lines.  If you
pass multiple arguments or references to arrays of hashes then the
return value might contain line breaks to format it for easier
reading.  The returned string will never be "\n" terminated, even if
contains multiple lines.  This allows code like this to place the
semicolon in the expected place:

   print '$obj = ', dump($obj), ";\n";

If dump() is called in void context, then the dump is printed on
STDERR and then "\n" terminated.  You might find this useful for quick
debug printouts, but the dd*() functions might be better alternatives
for this.

There is no difference between dump() and pp(), except that dump()
shares its name with a not-so-useful perl builtin.  Because of this
some might want to avoid using that name.


=head4 dd( ... )


=head4 ddx( ... )

These functions will call dump() on their argument and print the
result to STDOUT (actually, it's the currently selected output handle, but
STDOUT is the default for that).

The difference between them is only that ddx() will prefix the lines
it prints with "# " and mark the first line with the file and line
number where it was called.  This is meant to be useful for debug
printouts of state within programs.


=head3 dump

  print dump(@vars);
  dump(@vars);

dump of L<Data::Dump>. 
dump structure. In later case, result is dumped to STDERR.


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

=head2 -encode

=head3 functions of L<Encode>

=head4 $octets  = encode(ENCODING, $string [, CHECK])

Encodes a string from Perl's internal form into I<ENCODING> and returns
a sequence of octets.  ENCODING can be either a canonical name or
an alias.  For encoding names and aliases, see L<Encode/"Defining Aliases">.
For CHECK, see L<Encode/"Handling Malformed Data">.

For example, to convert a string from Perl's internal format to
iso-8859-1 (also known as Latin1),

  $octets = encode("iso-8859-1", $string);

B<CAVEAT>: When you run C<$octets = encode("utf8", $string)>, then
$octets B<may not be equal to> $string.  Though they both contain the
same data, the UTF8 flag for $octets is B<always> off.  When you
encode anything, UTF8 flag of the result is always off, even when it
contains completely valid utf8 string. See L<Encode/"The UTF8 flag"> below.

If the $string is C<undef> then C<undef> is returned.


=head4 $string = decode(ENCODING, $octets [, CHECK])

Decodes a sequence of octets assumed to be in I<ENCODING> into Perl's
internal form and returns the resulting string.  As in encode(),
ENCODING can be either a canonical name or an alias. For encoding names
and aliases, see L<Encode/"Defining Aliases">.  For CHECK, see
L<Encode/"Handling Malformed Data">.

For example, to convert ISO-8859-1 data to a string in Perl's internal format:

  $string = decode("iso-8859-1", $octets);

B<CAVEAT>: When you run C<$string = decode("utf8", $octets)>, then $string
B<may not be equal to> $octets.  Though they both contain the same data,
the UTF8 flag for $string is on unless $octets entirely consists of
ASCII data (or EBCDIC on EBCDIC machines).  See L<Encode/"The UTF8 flag">
below.

If the $string is C<undef> then C<undef> is returned.


=head4 [$length =] from_to($octets, FROM_ENC, TO_ENC [, CHECK])

Converts B<in-place> data between two encodings. The data in $octets
must be encoded as octets and not as characters in Perl's internal
format. For example, to convert ISO-8859-1 data to Microsoft's CP1250
encoding:

  from_to($octets, "iso-8859-1", "cp1250");

and to convert it back:

  from_to($octets, "cp1250", "iso-8859-1");

Note that because the conversion happens in place, the data to be
converted cannot be a string constant; it must be a scalar variable.

from_to() returns the length of the converted string in octets on
success, I<undef> on error.

B<CAVEAT>: The following operations look the same but are not quite so;

  from_to($data, "iso-8859-1", "utf8"); #1
  $data = decode("iso-8859-1", $data);  #2

Both #1 and #2 make $data consist of a completely valid UTF-8 string
but only #2 turns UTF8 flag on.  #1 is equivalent to

  $data = encode("utf8", decode("iso-8859-1", $data));

See L<Encode/"The UTF8 flag"> below.

Also note that

  from_to($octets, $from, $to, $check);

is equivalent to

  $octets = encode($to, decode($from, $octets), $check);

Yes, it does not respect the $check during decoding.  It is
deliberately done that way.  If you need minute control, C<decode>
then C<encode> as follows;

  $octets = encode($to, decode($from, $octets, $check_from), $check_to);


=head2 -exception

=head3 functions of L<Try::Tiny>

=head4 try (&;@)

Takes one mandatory try subroutine, an optional catch subroutine & finally
subroutine.

The mandatory subroutine is evaluated in the context of an C<eval> block.

If no error occurred the value from the first block is returned, preserving
list/scalar context.

If there was an error and the second subroutine was given it will be invoked
with the error in C<$_> (localized) and as that block's first and only
argument.

Note that the error may be false, but if that happens the C<catch> block will
still be invoked.

Once all execution is finished then the finally block if given will execute.


=head4 catch (&;$)

Intended to be used in the second argument position of C<try>.

Returns a reference to the subroutine it was given but blessed as
C<Try::Tiny::Catch> which allows try to decode correctly what to do
with this code reference.

	catch { ... }

Inside the catch block the previous value of C<$@> is still available for use.
This value may or may not be meaningful depending on what happened before the
C<try>, but it might be a good idea to preserve it in an error stack.


=head2 -file

=head3 functions of L<Path::Class>

=head4 file

A synonym for C<< Path::Class::File->new >>.


=head4 dir

A synonym for C<< Path::Class::Dir->new >>.


=head3 functions of L<File::Path>

=head4 make_path( $dir1, $dir2, .... )


=head4 make_path( $dir1, $dir2, ...., \%opts )

The C<make_path> function creates the given directories if they don't
exists before, much like the Unix command C<mkdir -p>.

The function accepts a list of directories to be created. Its
behaviour may be tuned by an optional hashref appearing as the last
parameter on the call.

The function returns the list of directories actually created during
the call; in scalar context the number of directories created.

The following keys are recognised in the option hash:

=over

=item mode => $num

The numeric permissions mode to apply to each created directory
(defaults to 0777), to be modified by the current C<umask>. If the
directory already exists (and thus does not need to be created),
the permissions will not be modified.

C<mask> is recognised as an alias for this parameter.

=item verbose => $bool

If present, will cause C<make_path> to print the name of each directory
as it is created. By default nothing is printed.

=item error => \$err

If present, it should be a reference to a scalar.
This scalar will be made to reference an array, which will
be used to store any errors that are encountered.  See the L<File::Path/"ERROR
HANDLING"> section for more information.

If this parameter is not used, certain error conditions may raise
a fatal error that will cause the program will halt, unless trapped
in an C<eval> block.

=item owner => $owner

=item user => $owner

=item uid => $owner

If present, will cause any created directory to be owned by C<$owner>.
If the value is numeric, it will be interpreted as a uid, otherwise
as username is assumed. An error will be issued if the username cannot be
mapped to a uid, or the uid does not exist, or the process lacks the
privileges to change ownership.

Ownwership of directories that already exist will not be changed.

C<user> and C<uid> are aliases of C<owner>.

=item group => $group

If present, will cause any created directory to be owned by the group C<$group>.
If the value is numeric, it will be interpreted as a gid, otherwise
as group name is assumed. An error will be issued if the group name cannot be
mapped to a gid, or the gid does not exist, or the process lacks the
privileges to change group ownership.

Group ownwership of directories that already exist will not be changed.

    make_path '/var/tmp/webcache', {owner=>'nobody', group=>'nogroup'};

=back


=head4 remove_tree( $dir1, $dir2, .... )


=head4 remove_tree( $dir1, $dir2, ...., \%opts )

The C<remove_tree> function deletes the given directories and any
files and subdirectories they might contain, much like the Unix
command C<rm -r> or C<del /s> on Windows.

The function accepts a list of directories to be
removed. Its behaviour may be tuned by an optional hashref
appearing as the last parameter on the call.

The functions returns the number of files successfully deleted.

The following keys are recognised in the option hash:

=over

=item verbose => $bool

If present, will cause C<remove_tree> to print the name of each file as
it is unlinked. By default nothing is printed.

=item safe => $bool

When set to a true value, will cause C<remove_tree> to skip the files
for which the process lacks the required privileges needed to delete
files, such as delete privileges on VMS. In other words, the code
will make no attempt to alter file permissions. Thus, if the process
is interrupted, no filesystem object will be left in a more
permissive mode.

=item keep_root => $bool

When set to a true value, will cause all files and subdirectories
to be removed, except the initially specified directories. This comes
in handy when cleaning out an application's scratch directory.

  remove_tree( '/tmp', {keep_root => 1} );

=item result => \$res

If present, it should be a reference to a scalar.
This scalar will be made to reference an array, which will
be used to store all files and directories unlinked
during the call. If nothing is unlinked, the array will be empty.

  remove_tree( '/tmp', {result => \my $list} );
  print "unlinked $_\n" for @$list;

This is a useful alternative to the C<verbose> key.

=item error => \$err

If present, it should be a reference to a scalar.
This scalar will be made to reference an array, which will
be used to store any errors that are encountered.  See the L<File::Path/"ERROR
HANDLING"> section for more information.

Removing things is a much more dangerous proposition than
creating things. As such, there are certain conditions that
C<remove_tree> may encounter that are so dangerous that the only
sane action left is to kill the program.

Use C<error> to trap all that is reasonable (problems with
permissions and the like), and let it die if things get out
of hand. This is the safest course of action.

=back


=head3 functions of L<File::Slurp>

=head4 B<read_file>

This sub reads in an entire file and returns its contents to the
caller. In list context it will return a list of lines (using the
current value of $/ as the separator including support for paragraph
mode when it is set to ''). In scalar context it returns the entire
file as a single scalar.

  my $text = read_file( 'filename' ) ;
  my @lines = read_file( 'filename' ) ;

The first argument to C<read_file> is the filename and the rest of the
arguments are key/value pairs which are optional and which modify the
behavior of the call. Other than binmode the options all control how
the slurped file is returned to the caller.

If the first argument is a file handle reference or I/O object (if ref
is true), then that handle is slurped in. This mode is supported so
you slurp handles such as C<DATA>, C<STDIN>. See the test handle.t
for an example that does C<open( '-|' )> and child process spews data
to the parant which slurps it in.  All of the options that control how
the data is returned to the caller still work in this case.

NOTE: as of version 9999.06, read_file works correctly on the C<DATA>
handle. It used to need a sysseek workaround but that is now handled
when needed by the module itself.

You can optionally request that C<slurp()> is exported to your code. This
is an alias for read_file and is meant to be forward compatible with
Perl 6 (which will have slurp() built-in).

The options are:



=over 8

=item binmode

If you set the binmode option, then the file will be slurped in binary
mode.

	my $bin_data = read_file( $bin_file, binmode => ':raw' ) ;

NOTE: this actually sets the O_BINARY mode flag for sysopen. It
probably should call binmode and pass its argument to support other
file modes.

=item array_ref

If this boolean option is set, the return value (only in scalar
context) will be an array reference which contains the lines of the
slurped file. The following two calls are equivalent:

	my $lines_ref = read_file( $bin_file, array_ref => 1 ) ;
	my $lines_ref = [ read_file( $bin_file ) ] ;

=item scalar_ref

If this boolean option is set, the return value (only in scalar
context) will be an scalar reference to a string which is the contents
of the slurped file. This will usually be faster than returning the
plain scalar.

	my $text_ref = read_file( $bin_file, scalar_ref => 1 ) ;

=item buf_ref

You can use this option to pass in a scalar reference and the slurped
file contents will be stored in the scalar. This can be used in
conjunction with any of the other options.

	my $text_ref = read_file( $bin_file, buf_ref => \$buffer,
					     array_ref => 1 ) ;
	my @lines = read_file( $bin_file, buf_ref => \$buffer ) ;

=item blk_size

You can use this option to set the block size used when slurping from an already open handle (like \*STDIN). It defaults to 1MB.

	my $text_ref = read_file( $bin_file, blk_size => 10_000_000,
					     array_ref => 1 ) ;

=item err_mode

You can use this option to control how read_file behaves when an error
occurs. This option defaults to 'croak'. You can set it to 'carp' or
to 'quiet to have no error handling. This code wants to carp and then
read abother file if it fails.

	my $text_ref = read_file( $file, err_mode => 'carp' ) ;
	unless ( $text_ref ) {

		# read a different file but croak if not found
		$text_ref = read_file( $another_file ) ;
	}
	
	# process ${$text_ref}


=back


=head4 B<write_file>

This sub writes out an entire file in one call.

  write_file( 'filename', @data ) ;

The first argument to C<write_file> is the filename. The next argument
is an optional hash reference and it contains key/values that can
modify the behavior of C<write_file>. The rest of the argument list is
the data to be written to the file.

  write_file( 'filename', {append => 1 }, @data ) ;
  write_file( 'filename', {binmode => ':raw' }, $buffer ) ;

As a shortcut if the first data argument is a scalar or array
reference, it is used as the only data to be written to the file. Any
following arguments in @_ are ignored. This is a faster way to pass in
the output to be written to the file and is equivilent to the
C<buf_ref> option. These following pairs are equivilent but the pass
by reference call will be faster in most cases (especially with larger
files).

  write_file( 'filename', \$buffer ) ;
  write_file( 'filename', $buffer ) ;

  write_file( 'filename', \@lines ) ;
  write_file( 'filename', @lines ) ;

If the first argument is a file handle reference or I/O object (if ref
is true), then that handle is slurped in. This mode is supported so
you spew to handles such as \*STDOUT. See the test handle.t for an
example that does C<open( '-|' )> and child process spews data to the
parant which slurps it in.  All of the options that control how the
data is passes into C<write_file> still work in this case.

C<write_file> returns 1 upon successfully writing the file or undef if
it encountered an error.

The options are:



=over 8

=item binmode

If you set the binmode option, then the file will be written in binary
mode.

	write_file( $bin_file, {binmode => ':raw'}, @data ) ;

NOTE: this actually sets the O_BINARY mode flag for sysopen. It
probably should call binmode and pass its argument to support other
file modes.

=item buf_ref

You can use this option to pass in a scalar reference which has the
data to be written. If this is set then any data arguments (including
the scalar reference shortcut) in @_ will be ignored. These are
equivilent:

	write_file( $bin_file, { buf_ref => \$buffer } ) ;
	write_file( $bin_file, \$buffer ) ;
	write_file( $bin_file, $buffer ) ;

=item atomic

If you set this boolean option, the file will be written to in an
atomic fashion. A temporary file name is created by appending the pid
($$) to the file name argument and that file is spewed to. After the
file is closed it is renamed to the original file name (and rename is
an atomic operation on most OS's). If the program using this were to
crash in the middle of this, then the file with the pid suffix could
be left behind.

=item append

If you set this boolean option, the data will be written at the end of
the current file.

	write_file( $file, {append => 1}, @data ) ;

C<write_file> croaks if it cannot open the file. It returns true if it
succeeded in writing out the file and undef if there was an
error. (Yes, I know if it croaks it can't return anything but that is
for when I add the options to select the error handling mode).

=item no_clobber

If you set this boolean option, an existing file will not be overwritten.

	write_file( $file, {no_clobber => 1}, @data ) ;

=item err_mode

You can use this option to control how C<write_file> behaves when an
error occurs. This option defaults to 'croak'. You can set it to
'carp' or to 'quiet' to have no error handling other than the return
value. If the first call to C<write_file> fails it will carp and then
write to another file. If the second call to C<write_file> fails, it
will croak.

	unless ( write_file( $file, { err_mode => 'carp', \$data ) ;

		# write a different file but croak if not found
		write_file( $other_file, \$data ) ;
	}


=back


=head3 find_file

(find of L<File::Find>)



  find(\&wanted,  @directories);
  find(\%options, @directories);

C<find()> does a depth-first search over the given C<@directories> in
the order they are given.  For each file or directory found, it calls
the C<&wanted> subroutine.  (See below for details on how to use the
C<&wanted> function).  Additionally, for each directory found, it will
C<chdir()> into that directory and continue the search, invoking the
C<&wanted> function on each file or subdirectory in the directory.



=head3 move_file

(move of L<File::Copy>)


X<move> X<mv> X<rename>

The C<move> function also takes two parameters: the current name
and the intended name of the file to be moved.  If the destination
already exists and is a directory, and the source is not a
directory, then the source file will be renamed into the directory
specified by the destination.

If possible, move() will simply rename the file.  Otherwise, it copies
the file to the new location and deletes the original.  If an error occurs
during this copy-and-delete process, you may be left with a (possibly partial)
copy of the file under the destination name.

You may use the "mv" alias for this function in the same way that
you may use the "cp" alias for C<copy>.


X<move> X<mv> X<rename>

The C<move> function also takes two parameters: the current name
and the intended name of the file to be moved.  If the destination
already exists and is a directory, and the source is not a
directory, then the source file will be renamed into the directory
specified by the destination.

If possible, move() will simply rename the file.  Otherwise, it copies
the file to the new location and deletes the original.  If an error occurs
during this copy-and-delete process, you may be left with a (possibly partial)
copy of the file under the destination name.

You may use the "mv" alias for this function in the same way that
you may use the "cp" alias for C<copy>.



=head3 slurp_file

(slurp of L<File::Slurp>)

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

(copy of L<File::Copy>)


X<copy> X<cp>

The C<copy> function takes two
parameters: a file to copy from and a file to copy to. Either
argument may be a string, a FileHandle reference or a FileHandle
glob. Obviously, if the first argument is a filehandle of some
sort, it will be read from, and if it is a file I<name> it will
be opened for reading. Likewise, the second argument will be
written to (and created if need be).  Trying to copy a file on top
of itself is a fatal error.

B<Note that passing in
files as handles instead of names may lead to loss of information
on some operating systems; it is recommended that you use file
names whenever possible.>  Files are opened in binary mode where
applicable.  To get a consistent behaviour when copying from a
filehandle to a file, use C<binmode> on the filehandle.

An optional third parameter can be used to specify the buffer
size used for copying. This is the number of bytes from the
first file, that will be held in memory at any given time, before
being written to the second file. The default buffer size depends
upon the file, but will generally be the whole file (up to 2MB), or
1k for filehandles that do not reference files (eg. sockets).

You may use the syntax C<use File::Copy "cp"> to get at the
"cp" alias for this function. The syntax is I<exactly> the same.


X<copy> X<cp>

The C<copy> function takes two
parameters: a file to copy from and a file to copy to. Either
argument may be a string, a FileHandle reference or a FileHandle
glob. Obviously, if the first argument is a filehandle of some
sort, it will be read from, and if it is a file I<name> it will
be opened for reading. Likewise, the second argument will be
written to (and created if need be).  Trying to copy a file on top
of itself is a fatal error.

B<Note that passing in
files as handles instead of names may lead to loss of information
on some operating systems; it is recommended that you use file
names whenever possible.>  Files are opened in binary mode where
applicable.  To get a consistent behaviour when copying from a
filehandle to a file, use C<binmode> on the filehandle.

An optional third parameter can be used to specify the buffer
size used for copying. This is the number of bytes from the
first file, that will be held in memory at any given time, before
being written to the second file. The default buffer size depends
upon the file, but will generally be the whole file (up to 2MB), or
1k for filehandles that do not reference files (eg. sockets).

You may use the syntax C<use File::Copy "cp"> to get at the
"cp" alias for this function. The syntax is I<exactly> the same.



=head3 test code

 my $fh = tempfile("anyname*.dat", dir => "./t/data/", unlink => 1);
 $fh->filename =~m{^t/data/anyname\w{4}\.dat$} || $fh->filename;
 # equal to: 1

 my $fh = tempfile(template => "anyname", dir => "./t/data/", suffix => ".tmp", unlink => 1);
 $fh->filename =~m{^t/data/anyname\w{4}\.tmp$} || $fh->filename;
 # equal to: 1

 my $fh = tempfile("anynameXXXXXXXX", dir => "./t/data/", suffix => ".tmp", unlink => 1);
 $fh->filename =~m{^t/data/anyname\w{8}\.tmp$} || $fh->filename;
 # equal to: 1

=head2 -hash

=head3 indexed *

  indexed my %hash = (a => 1, b => 2);

%hash is indexed.

=head3 functions of L<Hash::Util>

=head4 B<lock_keys>


=head4 B<unlock_keys>

  lock_keys(%hash);
  lock_keys(%hash, @keys);

Restricts the given %hash's set of keys to @keys.  If @keys is not
given it restricts it to its current keyset.  No more keys can be
added. delete() and exists() will still work, but will not alter
the set of allowed keys. B<Note>: the current implementation prevents
the hash from being bless()ed while it is in a locked state. Any attempt
to do so will raise an exception. Of course you can still bless()
the hash before you call lock_keys() so this shouldn't be a problem.

  unlock_keys(%hash);

Removes the restriction on the %hash's keyset.

B<Note> that if any of the values of the hash have been locked they will not be unlocked
after this sub executes.

Both routines return a reference to the hash operated on.


=head4 B<lock_value>


=head4 B<unlock_value>

  lock_value  (%hash, $key);
  unlock_value(%hash, $key);

Locks and unlocks the value for an individual key of a hash.  The value of a
locked key cannot be changed.

Unless %hash has already been locked the key/value could be deleted
regardless of this setting.

Returns a reference to the %hash.


=head4 B<lock_hash>


=head4 B<unlock_hash>

    lock_hash(%hash);

lock_hash() locks an entire hash, making all keys and values read-only.
No value can be changed, no keys can be added or deleted.

    unlock_hash(%hash);

unlock_hash() does the opposite of lock_hash().  All keys and values
are made writable.  All values can be changed and keys can be added
and deleted.

Returns a reference to the %hash.


=head4 B<hash_seed>

    my $hash_seed = hash_seed();

hash_seed() returns the seed number used to randomise hash ordering.
Zero means the "traditional" random hash ordering, non-zero means the
new even more random hash ordering introduced in Perl 5.8.1.

B<Note that the hash seed is sensitive information>: by knowing it one
can craft a denial-of-service attack against Perl code, even remotely,
see L<perlsec/"Algorithmic Complexity Attacks"> for more information.
B<Do not disclose the hash seed> to people who don't need to know it.
See also L<perlrun/PERL_HASH_SEED_DEBUG>.


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


=head2 -json

=head3 to_json_file *

  to_json_file($data, $file);

write JSON to file.

=head3 functions of L<JSON::XS>

=head4 $json_text = encode_json $perl_scalar

Converts the given Perl data structure to a UTF-8 encoded, binary string
(that is, the string contains octets only). Croaks on error.

This function call is functionally identical to:

   $json_text = JSON::XS->new->utf8->encode ($perl_scalar)

Except being faster.


=head4 $perl_scalar = decode_json $json_text

The opposite of C<encode_json>: expects an UTF-8 (binary) string and tries
to parse that as an UTF-8 encoded JSON text, returning the resulting
reference. Croaks on error.

This function call is functionally identical to:

   $perl_scalar = JSON::XS->new->utf8->decode ($json_text)

Except being faster.


=head3 from_json_file *

  from_json_file($json_file);

load JSON data from file. returns Perl data whose utf8 flag is off.

=head3 from_json *

  from_json($json_text);

from json text to perl data(utf8 flagged).

=head3 to_json *

  to_json($perl_data);

from perl data to json text(utf8 encoded).

=head3 test code

 no utf8;
 from_json(q/{"hoge":"あ"}/);
 # equal to: use utf8; {hoge => "あ"}

 use utf8;
 from_json(q/{"hoge":"あ"}/);
 # equal to: use utf8; {hoge => "あ"}

 no utf8;
 to_json({hoge => 'あ'});
 # equal to: no utf8; qq{{"hoge":"あ"}}

 use utf8;
 to_json({hoge => 'あ'});
 # equal to: no utf8; qq{{"hoge":"あ"}}

 no utf8;
 to_json_file({hoge => "あいうえお"}, "t/data/test.out.json");
 from_json_file("t/data/test.out.json");
 # equal to: use utf8; {hoge => "あいうえお"}

=head2 -list

=head3 functions of L<List::Util>

=head4 first BLOCK LIST

Similar to C<grep> in that it evaluates BLOCK setting C<$_> to each element
of LIST in turn. C<first> returns the first element where the result from
BLOCK is a true value. If BLOCK never returns true or LIST was empty then
C<undef> is returned.

    $foo = first { defined($_) } @list    # first defined value in @list
    $foo = first { $_ > $value } @list    # first value in @list which
                                          # is greater than $value

This function could be implemented using C<reduce> like this

    $foo = reduce { defined($a) ? $a : wanted($b) ? $b : undef } undef, @list

for example wanted() could be defined() which would return the first
defined value in @list


=head4 max LIST

Returns the entry in the list with the highest numerical value. If the
list is empty then C<undef> is returned.

    $foo = max 1..10                # 10
    $foo = max 3,9,12               # 12
    $foo = max @bar, @baz           # whatever

This function could be implemented using C<reduce> like this

    $foo = reduce { $a > $b ? $a : $b } 1..10


=head4 maxstr LIST

Similar to C<max>, but treats all the entries in the list as strings
and returns the highest string as defined by the C<gt> operator.
If the list is empty then C<undef> is returned.

    $foo = maxstr 'A'..'Z'          # 'Z'
    $foo = maxstr "hello","world"   # "world"
    $foo = maxstr @bar, @baz        # whatever

This function could be implemented using C<reduce> like this

    $foo = reduce { $a gt $b ? $a : $b } 'A'..'Z'


=head4 min LIST

Similar to C<max> but returns the entry in the list with the lowest
numerical value. If the list is empty then C<undef> is returned.

    $foo = min 1..10                # 1
    $foo = min 3,9,12               # 3
    $foo = min @bar, @baz           # whatever

This function could be implemented using C<reduce> like this

    $foo = reduce { $a < $b ? $a : $b } 1..10


=head4 minstr LIST

Similar to C<min>, but treats all the entries in the list as strings
and returns the lowest string as defined by the C<lt> operator.
If the list is empty then C<undef> is returned.

    $foo = minstr 'A'..'Z'          # 'A'
    $foo = minstr "hello","world"   # "hello"
    $foo = minstr @bar, @baz        # whatever

This function could be implemented using C<reduce> like this

    $foo = reduce { $a lt $b ? $a : $b } 'A'..'Z'


=head4 reduce BLOCK LIST

Reduces LIST by calling BLOCK, in a scalar context, multiple times,
setting C<$a> and C<$b> each time. The first call will be with C<$a>
and C<$b> set to the first two elements of the list, subsequent
calls will be done by setting C<$a> to the result of the previous
call and C<$b> to the next element in the list.

Returns the result of the last call to BLOCK. If LIST is empty then
C<undef> is returned. If LIST only contains one element then that
element is returned and BLOCK is not executed.

    $foo = reduce { $a < $b ? $a : $b } 1..10       # min
    $foo = reduce { $a lt $b ? $a : $b } 'aa'..'zz' # minstr
    $foo = reduce { $a + $b } 1 .. 10               # sum
    $foo = reduce { $a . $b } @bar                  # concat


=head4 shuffle LIST

Returns the elements of LIST in a random order

    @cards = shuffle 0..51      # 0..51 in a random order


=head4 sum LIST

Returns the sum of all the elements in LIST. If LIST is empty then
C<undef> is returned.

    $foo = sum 1..10                # 55
    $foo = sum 3,9,12               # 24
    $foo = sum @bar, @baz           # whatever

This function could be implemented using C<reduce> like this

    $foo = reduce { $a + $b } 1..10


=head3 functions of L<List::MoreUtils>

=head4 any BLOCK LIST

Returns a true value if any item in LIST meets the criterion given through
BLOCK. Sets C<$_> for each item in LIST in turn:

    print "At least one value undefined"
        if any { !defined($_) } @list;

Returns false otherwise, or C<undef> if LIST is empty.


=head4 all BLOCK LIST

Returns a true value if all items in LIST meet the criterion given through
BLOCK. Sets C<$_> for each item in LIST in turn:

    print "All items defined"
        if all { defined($_) } @list;

Returns false otherwise, or C<undef> if LIST is empty.


=head4 none BLOCK LIST

Logically the negation of C<any>. Returns a true value if no item in LIST meets the
criterion given through BLOCK. Sets C<$_> for each item in LIST in turn:

    print "No value defined"
        if none { defined($_) } @list;

Returns false otherwise, or C<undef> if LIST is empty.


=head4 notall BLOCK LIST

Logically the negation of C<all>. Returns a true value if not all items in LIST meet
the criterion given through BLOCK. Sets C<$_> for each item in LIST in turn:

    print "Not all values defined"
        if notall { defined($_) } @list;

Returns false otherwise, or C<undef> if LIST is empty.


=head4 true BLOCK LIST

Counts the number of elements in LIST for which the criterion in BLOCK is true. Sets C<$_> for 
each item in LIST in turn:

    printf "%i item(s) are defined", true { defined($_) } @list;


=head4 false BLOCK LIST

Counts the number of elements in LIST for which the criterion in BLOCK is false. Sets C<$_> for
each item in LIST in turn:

    printf "%i item(s) are not defined", false { defined($_) } @list;


=head4 firstidx BLOCK LIST


=head4 first_index BLOCK LIST

Returns the index of the first element in LIST for which the criterion in BLOCK is true. Sets C<$_>
for each item in LIST in turn:

    my @list = (1, 4, 3, 2, 4, 6);
    printf "item with index %i in list is 4", firstidx { $_ == 4 } @list;
    __END__
    item with index 1 in list is 4
    
Returns C<-1> if no such item could be found.

C<first_index> is an alias for C<firstidx>.


=head4 lastidx BLOCK LIST


=head4 last_index BLOCK LIST

Returns the index of the last element in LIST for which the criterion in BLOCK is true. Sets C<$_>
for each item in LIST in turn:

    my @list = (1, 4, 3, 2, 4, 6);
    printf "item with index %i in list is 4", lastidx { $_ == 4 } @list;
    __END__
    item with index 4 in list is 4

Returns C<-1> if no such item could be found.

C<last_index> is an alias for C<lastidx>.


=head4 insert_after BLOCK VALUE LIST

Inserts VALUE after the first item in LIST for which the criterion in BLOCK is true. Sets C<$_> for
each item in LIST in turn.

    my @list = qw/This is a list/;
    insert_after { $_ eq "a" } "longer" => @list;
    print "@list";
    __END__
    This is a longer list


=head4 insert_after_string STRING VALUE LIST

Inserts VALUE after the first item in LIST which is equal to STRING. 

    my @list = qw/This is a list/;
    insert_after_string "a", "longer" => @list;
    print "@list";
    __END__
    This is a longer list


=head4 apply BLOCK LIST

Applies BLOCK to each item in LIST and returns a list of the values after BLOCK
has been applied. In scalar context, the last element is returned.  This
function is similar to C<map> but will not modify the elements of the input
list:

    my @list = (1 .. 4);
    my @mult = apply { $_ *= 2 } @list;
    print "\@list = @list\n";
    print "\@mult = @mult\n";
    __END__
    @list = 1 2 3 4
    @mult = 2 4 6 8

Think of it as syntactic sugar for

    for (my @mult = @list) { $_ *= 2 }


=head4 after BLOCK LIST

Returns a list of the values of LIST after (and not including) the point
where BLOCK returns a true value. Sets C<$_> for each element in LIST in turn.

    @x = after { $_ % 5 == 0 } (1..9);    # returns 6, 7, 8, 9


=head4 after_incl BLOCK LIST

Same as C<after> but also inclues the element for which BLOCK is true.


=head4 before BLOCK LIST

Returns a list of values of LIST upto (and not including) the point where BLOCK
returns a true value. Sets C<$_> for each element in LIST in turn.


=head4 before_incl BLOCK LIST

Same as C<before> but also includes the element for which BLOCK is true.


=head4 indexes BLOCK LIST

Evaluates BLOCK for each element in LIST (assigned to C<$_>) and returns a list
of the indices of those elements for which BLOCK returned a true value. This is
just like C<grep> only that it returns indices instead of values:

    @x = indexes { $_ % 2 == 0 } (1..10);   # returns 1, 3, 5, 7, 9


=head4 firstval BLOCK LIST


=head4 first_value BLOCK LIST

Returns the first element in LIST for which BLOCK evaluates to true. Each
element of LIST is set to C<$_> in turn. Returns C<undef> if no such element
has been found.

C<first_val> is an alias for C<firstval>.


=head4 lastval BLOCK LIST


=head4 last_value BLOCK LIST

Returns the last value in LIST for which BLOCK evaluates to true. Each element
of LIST is set to C<$_> in turn. Returns C<undef> if no such element has been
found.

C<last_val> is an alias for C<lastval>.


=head4 pairwise BLOCK ARRAY1 ARRAY2

Evaluates BLOCK for each pair of elements in ARRAY1 and ARRAY2 and returns a
new list consisting of BLOCK's return values. The two elements are set to C<$a>
and C<$b>.  Note that those two are aliases to the original value so changing
them will modify the input arrays.

    @a = (1 .. 5);
    @b = (11 .. 15);
    @x = pairwise { $a + $b } @a, @b;	# returns 12, 14, 16, 18, 20

    # mesh with pairwise
    @a = qw/a b c/;
    @b = qw/1 2 3/;
    @x = pairwise { ($a, $b) } @a, @b;	# returns a, 1, b, 2, c, 3


=head4 each_array ARRAY1 ARRAY2 ...

Creates an array iterator to return the elements of the list of arrays ARRAY1,
ARRAY2 throughout ARRAYn in turn.  That is, the first time it is called, it
returns the first element of each array.  The next time, it returns the second
elements.  And so on, until all elements are exhausted.

This is useful for looping over more than one array at once:

    my $ea = each_array(@a, @b, @c);
    while ( my ($a, $b, $c) = $ea->() )   { .... }

The iterator returns the empty list when it reached the end of all arrays.

If the iterator is passed an argument of 'C<index>', then it retuns
the index of the last fetched set of values, as a scalar.


=head4 each_arrayref LIST

Like each_array, but the arguments are references to arrays, not the
plain arrays.


=head4 natatime BLOCK LIST

Creates an array iterator, for looping over an array in chunks of
C<$n> items at a time.  (n at a time, get it?).  An example is
probably a better explanation than I could give in words.

Example:

    my @x = ('a' .. 'g');
    my $it = natatime 3, @x;
    while (my @vals = $it->())
    {
        print "@vals\n";
    }

This prints

    a b c
    d e f
    g


=head4 mesh ARRAY1 ARRAY2 [ ARRAY3 ... ]


=head4 zip ARRAY1 ARRAY2 [ ARRAY3 ... ]

Returns a list consisting of the first elements of each array, then
the second, then the third, etc, until all arrays are exhausted.

Examples:

    @x = qw/a b c d/;
    @y = qw/1 2 3 4/;
    @z = mesh @x, @y;	    # returns a, 1, b, 2, c, 3, d, 4

    @a = ('x');
    @b = ('1', '2');
    @c = qw/zip zap zot/;
    @d = mesh @a, @b, @c;   # x, 1, zip, undef, 2, zap, undef, undef, zot

C<zip> is an alias for C<mesh>.


=head4 uniq LIST

Returns a new list by stripping duplicate values in LIST. The order of
elements in the returned list is the same as in LIST. In scalar context,
returns the number of unique elements in LIST.

    my @x = uniq 1, 1, 2, 2, 3, 5, 3, 4; # returns 1 2 3 5 4
    my $x = uniq 1, 1, 2, 2, 3, 5, 3, 4; # returns 5


=head4 minmax LIST

Calculates the minimum and maximum of LIST and returns a two element list with
the first element being the minimum and the second the maximum. Returns the empty
list if LIST was empty.

The minmax algorithm differs from a naive iteration over the list where each element
is compared to two values being the so far calculated min and max value in that it
only requires 3n/2 - 2 comparisons. Thus it is the most efficient possible algorithm.

However, the Perl implementation of it has some overhead simply due to the fact
that there are more lines of Perl code involved. Therefore, LIST needs to be
fairly big in order for minmax to win over a naive implementation. This
limitation does not apply to the XS version.


=head4 part BLOCK LIST

Partitions LIST based on the return value of BLOCK which denotes into which partition
the current value is put.

Returns a list of the partitions thusly created. Each partition created is a
reference to an array.

    my $i = 0;
    my @part = part { $i++ % 2 } 1 .. 8;   # returns [1, 3, 5, 7], [2, 4, 6, 8]

You can have a sparse list of partitions as well where non-set partitions will
be undef:

    my @part = part { 2 } 1 .. 10;	    # returns undef, undef, [ 1 .. 10 ]

Be careful with negative values, though:

    my @part = part { -1 } 1 .. 10;
    __END__
    Modification of non-creatable array value attempted, subscript -1 ...

Negative values are only ok when they refer to a partition previously created:

    my @idx = (0, 1, -1);
    my $i = 0;
    my @part = part { $idx[$++ % 3] } 1 .. 8;	# [1, 4, 7], [2, 3, 5, 6, 8]


=head3 functions of L<List::Pairwise>

=head4 mapp BLOCK LIST


=head4 grepp BLOCK LIST


=head4 firstp BLOCK LIST


=head4 lastp BLOCK LIST


=head4 * Johan Lodin for the C<pair> idea and implementation, as well as numerous other
contributions (see changelog)


=head2 -math

=head3 functions of L<Toolbox::Simple>

=head4 B<gcd(num, num, num)  /  gcf(num, num, num)>

Both (identical) functions return the greatest common divisor/factor
for the numbers given in their arguments.



=head4 B<lcm(num, num, num)>

Returns the lowest common multiple for the numbers in its argument.



=head4 B<is_prime(num)>

Tests a number for primeness. If it is, returns 1. If it isn't prime, returns 0.



=head2 -md5

=head3 functions of L<Digest::MD5>

=head4 md5($data,...)

This function will concatenate all arguments, calculate the MD5 digest
of this "message", and return it in binary form.  The returned string
will be 16 bytes long.

The result of md5("a", "b", "c") will be exactly the same as the
result of md5("abc").


=head4 md5_hex($data,...)

Same as md5(), but will return the digest in hexadecimal form. The
length of the returned string will be 32 and it will only contain
characters from this set: '0'..'9' and 'a'..'f'.


=head4 md5_base64($data,...)

Same as md5(), but will return the digest as a base64 encoded string.
The length of the returned string will be 22 and it will only contain
characters from this set: 'A'..'Z', 'a'..'z', '0'..'9', '+' and
'/'.

Note that the base64 encoded string returned is not padded to be a
multiple of 4 bytes long.  If you want interoperability with other
base64 encoded md5 digests you might want to append the redundant
string "==" to the result.


=head2 -modern

this is automatically used. no need to call it.
It affects the the following to the source of caller package.

   use strict;
   use warnings;
   use feature (':5.10'); # if your perl version > 5.10

If you want to disable this.

  use Util::All -modern => [-args => {disable => 1}];


=head2 -oo

provides simple OO interface.
constructor and accessors is provided as wrapper of L<Class::Accessor::Fast> and L<Class::Data::Inheritable>.

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

=head4 B<sha1($data, ...)>


=head4 B<sha256($data, ...)>


=head4 B<sha384($data, ...)>


=head4 B<sha512($data, ...)>

Logically joins the arguments into a single string, and returns
its SHA-1/224/256/384/512 digest encoded as a binary string.


=head4 B<sha1_hex($data, ...)>


=head4 B<sha256_hex($data, ...)>


=head4 B<sha384_hex($data, ...)>


=head4 B<sha512_hex($data, ...)>

Logically joins the arguments into a single string, and returns
its SHA-1/224/256/384/512 digest encoded as a hexadecimal string.


=head4 B<sha1_base64($data, ...)>


=head4 B<sha256_base64($data, ...)>


=head4 B<sha384_base64($data, ...)>


=head4 B<sha512_base64($data, ...)>

Logically joins the arguments into a single string, and returns
its SHA-1/224/256/384/512 digest encoded as a Base64 string.

It's important to note that the resulting string does B<not> contain
the padding characters typical of Base64 encodings.  This omission is
deliberate, and is done to maintain compatibility with the family of
CPAN Digest modules.  See L<Digest::SHA/"PADDING OF BASE64 DIGESTS"> for details.


=head2 -storable

=head3 freeze *

  $storable_data = freeze($data);

serialize $storable_data

=head3 thaw *

  $data = thaw($storable_data);

retrieve data from stroable.

=head3 test code

 thaw(freeze({a => 1}))->{a}
 # equal to: 1

 thaw(freeze({a => 123}))->{a}
 # equal to: 123

 use Util::All -base64;
 thaw(base64_decode('BAcIMTIzNDU2NzgECAgIAwEAAAAI5AEAAABi'))->{b};
 # equal to: 100

=head2 -string

=head3 functions of L<String::CamelCase>

=head4 camelize($under_score)

convert from under_score text to CamelCase one.


=head4 decamelize($CamelCase)

convert from CamelCase text to under_score one.


=head4 wordsplit($str)


=head3 functions of L<String::Util>

=head4 crunch(string)

Crunches all whitespace in the string down to single spaces.  Also removes all
leading and trailing whitespace.  Undefined input results in undefined output.


=head4 hascontent(scalar)

Returns true if the given argument contains something besides whitespace.

This function tests if the given value is defined and, if it is, if that
defined value contains something besides whitespace.

An undefined value returns false.  An empty string returns false.  A value
containing nothing but whitespace (spaces, tabs, carriage returns,
newlines, backspace) returns false.  A string containing any other
characers (including zero) returns true.


=head4 trim(string)

Returns the string with all leading and trailing whitespace removed.
Trim on undef returns undef.


=head4 nospace(string)

Removes all whitespace characters from the given string.


=head4 htmlesc(string)

Formats a string for literal output in HTML.  An undefined value is
returned as an empty string.

htmlesc is very similar to CGI.pm's escapeHTML.  If your script already
loads CGI.pm, you may well not need htmlesc.  However, there are a few
differences.  htmlesc changes an undefined value to an empty string, whereas
escapeHTML returns undefs as undefs and also results in a warning.  Also,
escapeHTML will not modify a value in place: you always have to store the
return value, even in you're putting it back in to the variable the value
came from.  It's a matter of taste.



=head4 unquote(string)

If the given string starts and ends with quotes, removes them.
Recognizes single quotes and double quotes.  The value must begin
and end with same type of quotes or nothing is done to the value.
Undef input results in undef output.  


=head4 define(scalar)

Takes a single value as input. If the value is defined, it is
returned unchanged.  If it is not defined, an empty string is returned.

This subroutine is useful for printing when an undef should simply be represented
as an empty string.  Granted, Perl already treats undefs as empty strings in
string context, but this sub makes -w happy.  And you ARE using -w, right?


=head4 randword(length, %options)

Returns a random string of characters. String will not contain any vowels (to
avoid distracting dirty words). First argument is the length of the return
string.  



=over 8

=item option: numerals

If the numerals option is true, only numerals are returned, no alphabetic
characters.

=item option: strip_vowels

This option is true by default.  If true, vowels are not included in the
returned random string.


=back

 

=head4 equndef($str1, $str2)

Returns true if the two given strings are equal.  Also returns true if both
are undef.  If only one is undef, or if they are both defined but different,
returns false.


=head4 neundef($str1, $str2)

The opposite of equndef, returns true if the two strings are *not* the same.


=head4 fullchomp(string)

Works like chomp, but is a little more thorough about removing \n's and \r's
even if they aren't part of the OS's standard end-of-line.

Undefs are returned as undefs.


=head4 randcrypt(string)

Crypts the given string, seeding the encryption with a random
two character seed.


=head3 to_fh *

  my $fh = to_fh($scalar);
  print $_ while <$fh>;
  
  to_fh(url  => "http://example.co.jp/");
  to_fh(file => "/path/to/target.txt");
  to_fh(file => "/path/to/target.txt", '>');


create IO::String object, which can be used as filehandle.

=head3 strings *

  strings("111\0111");

abstract printable character from scalar. just like strings command.

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

 use Util::All -string;
 my $s = "1\n2\n3\n4\n5\n";
 my $fh = to_fh(\$s);
 my $sum = 0;
 while (<$fh>){ chomp;
 $sum += $_ ;
 $sum++};
 $sum;
 # equal to: 20

 use Util::All -string;
 my $fh = to_fh(url => "http://rwds.net/");
 my $c = '';
 while (<$fh>){m{<h1>(.+)</h1>} and do {$c = $1;
 last} };
 $c;
 # equal to: "rwds.net"

=head3 test code

 package test_strings1;
 use Util::All -string;
 strings('111' . "\0" . '111');
 # equal to: "111111"

=head2 -subroutine

=head3 functions of L<Data::Util>

=head4 install_subroutine(package, name => subr [, ...])

Installs I<subr> into I<package> as I<name>.

It is similar to
C<< do{ no strict 'refs'; *{$package.'::'.$name} = \&subr; } >>.
In addition, if I<subr> is an anonymous subroutine, it is located into
I<package> as a named subroutine I<&package::name>.

For example:

	install_subroutine($pkg,   say => sub{ print @_, "\n" });
	install_subroutine($pkg,
		one => \&_one,
		two => \&_two,
	);

	# accepts a HASH reference
	install_subroutine($pkg, { say => sub{ print @_, "\n" }); # 

To re-install I<subr>, use C<< no warnings 'redefine' >> directive:

	no warnings 'redefine';
	install_subroutine($package, $name => $subr);


=head4 uninstall_subroutine(package, names...)

Uninstalls I<names> from I<package>.

It is similar to C<Sub::Delete::delete_sub()>, but uninstall multiple
subroutines at a time.

If you want to specify deleted subroutines, you can supply 
C<< name => \&subr >> pairs.

For example:

	uninstall_subroutine('Foo', 'hello');

	uninstall_subroutine('Foo', hello => \&Bar::hello);

	uninstall_subroutine($pkg,
		one => \&_one,
		two => \&_two,
	);

	# accepts a HASH reference
	uninstall_subroutine(\$pkg, { hello => \&Bar::hello });


=head4 get_code_info(subr)

Returns a pair of elements, the package name and the subroutine name of I<subr>.

It is similar to C<Sub::Identify::get_code_info()>, but it returns the fully
qualified name in scalar context.


=head4 get_code_ref(package, name, flag?)

Returns I<&package::name> if it exists, not touching the symbol in the stash.

if I<flag> is a string C<-create>, it returns I<&package::name> regardless of
its existence. That is, it is equivalent to
C<< do{ no strict 'refs'; \&{package . '::' . $name} } >>.

For example:

	$code = get_code_ref($pkg, $name);          # like  *{$pkg.'::'.$name}{CODE}
	$code = get_code_ref($pkg, $name, -create); # like \&{$pkg.'::'.$name}


=head4 curry(subr, args and/or placeholders)

Makes I<subr> curried and returns the curried subroutine.

This is also considered as lightweight closures.

See also L<Data::Util::Curry>.


=head4 modify_subroutine(subr, ...)

Modifies I<subr> with subroutine modifiers and returns the modified subroutine.
This is also considered as lightweight closures.

I<subr> must be a code reference or callable object.

Optional arguments:
C<< before => [subroutine(s)] >> called before I<subr>.
C<< around => [subroutine(s)] >> called around I<subr>.
C<< after  => [subroutine(s)] >> called after  I<subr>.

This seems a constructor of modified subroutines and
C<subroutine_modifier()> is property accessors, but it does not bless the 
modified subroutines.


=head4 subroutine_modifier(subr)

Returns whether I<subr> is a modified subroutine.


=head4 subroutine_modifier(modified_subr, property)

Gets I<property> from I<modified>.

Valid properties are: C<before>, C<around>, C<after>.


=head4 subroutine_modifier(modified_subr, modifier => [subroutine(s)])

Adds subroutine I<modifier> to I<modified_subr>.

Valid modifiers are: C<before>, C<around>, C<after>.


=head2 -unicode

Unicode operation using Unicode::Stirng.

  utf32be($str)->utf8;      # utf32be -> utf8 (byte string)
  utf32le($str)->utf16le;   # utf32le -> utf16le (byte string)
  utf16be($str)->utf8;      # utf16be -> utf8 (byte string)
  utf16le($str)->utf32be;   # utf16le -> utf32be (byte string)
  uhex(2026)->utf8;         # equal to "…"
  uchr(8230)->utf8;         # equal to "…"

If you want unicode name/block.

  nicode_name(ord("\x{2026}"));  # equal to 'HORIZONTAL ELLIPSIS'
  nicode_name('…');              # equal to 'HORIZONTAL ELLIPSIS'
  nicode_block(8230);            # equal to 'General Punctuation'
  nicode_block('…');            # equal to 'General Punctuation'


=head2 -uri

=head3 functions of L<URI::Escape>

=head4 uri_escape( $string )


=head4 uri_escape( $string, $unsafe )

Replaces each unsafe character in the $string with the corresponding
escape sequence and returns the result.  The $string argument should
be a string of bytes.  The uri_escape() function will croak if given a
characters with code above 255.  Use uri_escape_utf8() if you know you
have such chars or/and want chars in the 128 .. 255 range treated as
UTF-8.

The uri_escape() function takes an optional second argument that
overrides the set of characters that are to be escaped.  The set is
specified as a string that can be used in a regular expression
character class (between [ ]).  E.g.:

  "\x00-\x1f\x7f-\xff"          # all control and hi-bit characters
  "a-z"                         # all lower case characters
  "^A-Za-z"                     # everything not a letter

The default set of characters to be escaped is all those which are
I<not> part of the C<uric> character class shown above as well as the
reserved characters.  I.e. the default is:

  "^A-Za-z0-9\-_.!~*'()"


=head4 uri_unescape($string,...)

Returns a string with each %XX sequence replaced with the actual byte
(octet).

This does the same as:

   $string =~ s/%([0-9A-Fa-f]{2})/chr(hex($1))/eg;

but does not modify the string in-place as this RE would.  Using the
uri_unescape() function instead of the RE might make the code look
cleaner and is a few characters less to type.

In a simple benchmark test I did,
calling the function (instead of the inline RE above) if a few chars
were unescaped was something like 40% slower, and something like 700% slower if none were.  If
you are going to unescape a lot of times it might be a good idea to
inline the RE.

If the uri_unescape() function is passed multiple strings, then each
one is returned unescaped.


=head3 functions of L<URI::Split>

=head4 ($scheme, $auth, $path, $query, $frag) = uri_split($uri)

Breaks up a URI string into its component
parts.  An C<undef> value is returned for those parts that are not
present.  The $path part is always present (but can be the empty
string) and is thus never returned as C<undef>.

No sensible value is returned if this function is called in a scalar
context.


=head4 $uri = uri_join($scheme, $auth, $path, $query, $frag)

Puts together a URI string from its parts.
Missing parts are signaled by passing C<undef> for the corresponding
argument.

Minimal escaping is applied to parts that contain reserved chars
that would confuse a parser.  For instance, any occurrence of '?' or '#'
in $path is always escaped, as it would otherwise be parsed back
as a query or fragment.


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

(encode of L<utf8>)

=head3 utf8_off *

  my $d = utf8_off($data);

recursively make utf8 flag off(not destructive)

=head3 utf8_upgrade

(upgrade of L<utf8>)

=head3 utf8_downgrade

(downgrade of L<utf8>)

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

=head4 usleep ( $useconds )

Sleeps for the number of microseconds (millionths of a second)
specified.  Returns the number of microseconds actually slept.
Can sleep for more than one second, unlike the C<usleep> system call.
Can also sleep for zero seconds, which often works like a I<thread yield>.
See also C<Time::HiRes::usleep()>, C<Time::HiRes::sleep()>, and
C<Time::HiRes::clock_nanosleep()>.

Do not expect usleep() to be exact down to one microsecond.


=head4 nanosleep ( $nanoseconds )

Sleeps for the number of nanoseconds (1e9ths of a second) specified.
Returns the number of nanoseconds actually slept (accurate only to
microseconds, the nearest thousand of them).  Can sleep for more than
one second.  Can also sleep for zero seconds, which often works like
a I<thread yield>.  See also C<Time::HiRes::sleep()>,
C<Time::HiRes::usleep()>, and C<Time::HiRes::clock_nanosleep()>.

Do not expect nanosleep() to be exact down to one nanosecond.
Getting even accuracy of one thousand nanoseconds is good.


=head4 ualarm ( $useconds [, $interval_useconds ] )

Issues a C<ualarm> call; the C<$interval_useconds> is optional and
will be zero if unspecified, resulting in C<alarm>-like behaviour.

ualarm(0) will cancel an outstanding ualarm().

Note that the interaction between alarms and sleeps is unspecified.


=head2 -yaml

=head3 to_yaml_file *

  to_yaml_file($data, $yaml_file);

dump YAML data to file

=head3 to_yaml *

  sub {
      require Encode;
      require Data::Structure::Util;
      require Data::Recursive::Encode;
      sub {
          my $data = shift;
          $data = Data::Recursive::Encode->decode( 'utf8', $data )
            unless Data::Structure::Util::has_utf8($data);
          YAML::XS::Dump($data);
        }
    }


=head3 decode_yaml

(Load of L<YAML::XS>)

=head3 encode_yaml

(Dump of L<YAML::XS>)

=head3 from_yaml_file *

  from_yaml_file($yaml_file);

load YAML data from file

=head3 from_yaml *

  sub {
      require Encode;
      sub {
          my $yaml = shift;
          YAML::XS::Load(
              utf8::is_utf8($yaml) ? Encode::encode( "utf8", $yaml ) : $yaml );
        }
    }


=head3 test code

 no utf8;
 from_yaml( qq{---\nhoge: あ\n} );
 # equal to: use utf8; { hoge => 'あ' };

 use utf8;
 from_yaml( qq{---\nhoge: あ\n} );
 # equal to: use utf8; { hoge => 'あ' };

 no utf8;
 decode_yaml( qq{---\nhoge: あ\n} );
 # equal to: use utf8; { hoge => 'あ' };

 no utf8;
 to_yaml({hoge => 'あ'})
 # equal to: no utf8; qq{---\nhoge: あ\n}

 use utf8;
 to_yaml({hoge => 'あ'})
 # equal to: no utf8; qq{---\nhoge: あ\n}

 use utf8;
 encode_yaml({hoge => 'あ'})
 # equal to: no utf8; qq{---\nhoge: あ\n}

 from_yaml_file("t/data/test.yml");
 # equal to: use utf8; {hoge => 'あ'};

 use utf8;
 to_yaml_file({hoge => "あいうえお"}, "t/data/test.out.yml");
 from_yaml_file("t/data/test.out.yml");
 # equal to: use utf8; {hoge => "あいうえお"}

 no utf8;
 to_yaml_file({hoge => "あいうえお"}, "t/data/test.out.yml");
 from_yaml_file("t/data/test.out.yml");
 # equal to: use utf8; {hoge => "あいうえお"}

=head2 -yml

=head3 to_yaml *

  sub {
      require Encode;
      require Data::Structure::Util;
      require Data::Recursive::Encode;
      sub {
          my $data = shift;
          $data = Data::Recursive::Encode->decode( 'utf8', $data )
            unless Data::Structure::Util::has_utf8($data);
          YAML::XS::Dump($data);
        }
    }


=head3 to_yaml_file *

  to_yaml_file($data, $yaml_file);

dump YAML data to file

=head3 decode_yaml

(Load of L<YAML::XS>)

=head3 encode_yaml

(Dump of L<YAML::XS>)

=head3 from_yaml_file *

  from_yaml_file($yaml_file);

load YAML data from file

=head3 from_yaml *

  sub {
      require Encode;
      sub {
          my $yaml = shift;
          YAML::XS::Load(
              utf8::is_utf8($yaml) ? Encode::encode( "utf8", $yaml ) : $yaml );
        }
    }


=head3 test code

 no utf8;
 from_yaml( qq{---\nhoge: あ\n} );
 # equal to: use utf8; { hoge => 'あ' };

 use utf8;
 from_yaml( qq{---\nhoge: あ\n} );
 # equal to: use utf8; { hoge => 'あ' };

 no utf8;
 decode_yaml( qq{---\nhoge: あ\n} );
 # equal to: use utf8; { hoge => 'あ' };

 no utf8;
 to_yaml({hoge => 'あ'})
 # equal to: no utf8; qq{---\nhoge: あ\n}

 use utf8;
 to_yaml({hoge => 'あ'})
 # equal to: no utf8; qq{---\nhoge: あ\n}

 use utf8;
 encode_yaml({hoge => 'あ'})
 # equal to: no utf8; qq{---\nhoge: あ\n}

 from_yaml_file("t/data/test.yml");
 # equal to: use utf8; {hoge => 'あ'};

 use utf8;
 to_yaml_file({hoge => "あいうえお"}, "t/data/test.out.yml");
 from_yaml_file("t/data/test.out.yml");
 # equal to: use utf8; {hoge => "あいうえお"}

 no utf8;
 to_yaml_file({hoge => "あいうえお"}, "t/data/test.out.yml");
 from_yaml_file("t/data/test.out.yml");
 # equal to: use utf8; {hoge => "あいうえお"}



=head1 PLUGINS

=head2 L<Util::All::Plugin::Email>

=head2 L<Util::All::Plugin::Number>

=head2 L<Util::All::Plugin::Csv>

=head2 L<Util::All::Plugin::Xml>

=head2 L<Util::All::Plugin::Serialize>

=head2 L<Util::All::Plugin::Prompt>

=head2 L<Util::All::Plugin::Image>

=head2 L<Util::All::Plugin::Datetime>

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
     - example
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

you can write code to skip test as the following.

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

If you want to embed usage

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
But, of course, -all loads all modules.

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
 IO::String;
 Pod::Abstract;

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

Thanks to the authors of the following modules which Util::All depends on.

L<Benchmark>, L<CGI::Util>, L<Carp>, L<Class::Accessor::Fast>, L<Class::Data::Inheritable>, L<Clone>, L<Data::Dump>, L<Data::Dumper>, L<Data::Recursive::Encode>, L<Data::Structure::Util>, L<Data::Util>, L<Date::Manip>, L<Devel::Cycle>, L<Devel::Size>, L<Digest::MD5>, L<Digest::SHA>, L<Encode>, L<Encode::Argv>, L<File::Copy>, L<File::Find>, L<File::Path>, L<File::Slurp>, L<File::Temp>, L<HTML::Entities>, L<HTTP::Request::Common>, L<Hash::Util>, L<IO::String>, L<JSON::XS>, L<LWP::UserAgent>, L<List::MoreUtils>, L<List::Pairwise>, L<List::Util>, L<MIME::Base64>, L<MIME::Base64::URLSafe>, L<MIME::Types>, L<Math::BaseCalc>, L<Path::Class>, L<Scalar::Util>, L<Storable>, L<String::CamelCase>, L<String::Util>, L<Template>, L<Term::Encoding>, L<Tie::IxHash>, L<Time::HiRes>, L<Toolbox::Simple>, L<Try::Tiny>, L<URI>, L<URI::Escape>, L<URI::Split>, L<Unicode::CharName>, L<Unicode::Japanese>, L<Unicode::String>, L<XML::Parser>, L<YAML::XS>

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
