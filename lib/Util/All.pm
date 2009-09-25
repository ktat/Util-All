package Util::All;

use warnings;
use strict;

use Util::Any -Base;

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
  '-benchmark' => [
    [
      'Benchmark',
      '',
      {
        '-select' => [
          'timeit',
          'timethis',
          'timethese',
          'timediff',
          'timestr',
          'timesum',
          'cmpthese',
          'countit'
        ]
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
    ]
  ],
  '-char_enc' => [
    [
      'Encode',
      '',
      {
        'from_to' => 'char_convert',
        'decode' => 'char_decode',
        '-select' => [],
        'encode' => 'char_encode'
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
            sub () {
                'DateTime::Duration'->new('hours', 1);
            }
            ;
        },
        '-select' => [],
        'second' => sub {
            sub () {
                'DateTime::Duration'->new('seconds', 1);
            }
            ;
        },
        'month' => sub {
            sub () {
                'DateTime::Duration'->new('months', 1);
            }
            ;
        },
        'minute' => sub {
            sub () {
                'DateTime::Duration'->new('minutes', 1);
            }
            ;
        },
        'day' => sub {
            sub () {
                'DateTime::Duration'->new('days', 1);
            }
            ;
        },
        'datetime_duration' => sub {
            sub {
                'DateTime::Duration'->new(@_);
            }
            ;
        },
        'year' => sub {
            sub () {
                'DateTime::Duration'->new('years', 1);
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
        '-select' => []
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
            sub {
                my $ua = 'LWP::UserAgent'->new;
                $ua->request(HTTP::Request::Common::POST(@_));
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
            require LWP::UserAgent;
            sub {
                my $ua = 'LWP::UserAgent'->new;
                $ua->request(HTTP::Request::Common::GET(@_));
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
      'JSON::Syck',
      '',
      {
        'DumpFile' => 'json_dump_file',
        '-select' => [],
        'Dump' => 'json_dump',
        'Load' => 'json_load',
        'LoadFile' => 'json_load_file'
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
        'sendmail' => 'mail_send',
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
  '-uri' => [
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
  '-yaml' => [
    [
      'YAML::Syck',
      '',
      {
        'DumpFile' => 'yaml_dump_file',
        '-select' => [],
        'Dump' => 'yaml_dump',
        'Load' => 'yaml_load',
        'LoadFile' => 'yaml_load_file'
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

When you want encode Utilities.

 use Util::All -char_enc;
 char_encode('utf8', $str);
 char_decode('utf8', $str);

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

If you know good functions, please tell me. I want to add them into Util::All.

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

Instead of writing document,
I'll show YAML file below.

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

   ---
   scalar:
     Scalar::Util:
       - blessed
       - dualvar
       - isvstring
       - isweak
       - looks_like_number
       - openhandle
       - readonly
       - refaddr
       - reftype
       - set_prototype
       - tainted
       - weaken
   
   list:
     List::Util:
       - first
       - max
       - maxstr
       - min
       - minstr
       - reduce
       - shuffle
       - sum
     List::MoreUtils:
       - after
       - after_incl
       - all
       - any
       - apply
       - before
       - before_incl
       - each_array
       - each_arrayref
       - false
       - first_index
       - first_value
       - firstidx
       - firstval
       - indexes
       - insert_after
       - insert_after_string
       - last_index
       - last_value
       - lastidx
       - lastval
       - mesh
       - minmax
       - natatime
       - none
       - notall
       - pairwise
       - part
       - true
       - uniq
       - zip
   
   hash:
     Hash::Util:
      - hash_seed
      - lock_hash
      - lock_keys
      - lock_value
      - unlock_hash
      - unlock_keys
      - unlock_value
   
   debug:
     Data::Dumper:
       Dumper: dumper
     Data::Dump:
       dump: dump
       p   : sub { sub { Data::Dump::dump(@_) } }
   
   string:
     String::Util:
       - crunch
       - define
       - equndef
       - fullchomp
       - hascontent
       - htmlesc
       - neundef
       - nospace
       - randcrypt
       - randword
       - trim
       - unquote
     String::CamelCase:
       - camelize
       - decamelize
       - wordsplit
   
   md5:
     Digest::MD5:
       - md5
       - md5_hex
       - md5_base64
   sha:
     Digest::SHA:
       - sha1
       - sha1_hex
       - sha1_base64
       - sha256
       - sha256_hex
       - sha256_base64
       - sha384
       - sha384_hex
       - sha384_base64
       - sha512
       - sha512_hex
       - sha512_base64
   
   utf8:
     utf8:
       is_utf8  : is_utf8
       upgrade  : utf8_upgrade
       downgrade: utf8_downgrade
       encode   : utf8_encode
   
   cgi:
     CGI::Util:
       escape: cgi_escape
       unescape: cgi_unescape
   
   char_enc:
     Encode:
       encode : char_encode
       decode : char_decode
       from_to: char_convert
   
   uri:
     URI::Escape:
       - uri_escape
       - uri_unescape
     URI::Split:
       - uri_split
       - uri_join
   
   base64:
     MIME::Base64:
       encode_base64: base64_encode
       decode_base64: base64_decode
   
   http:
     HTTP::Request::Common:
       http_get   : sub { require LWP::UserAgent; sub { my $ua = LWP::UserAgent->new(); $ua->request(HTTP::Request::Common::GET(@_)) } }
       http_post  : sub { require LWP::UserAgent; sub { my $ua = LWP::UserAgent->new(); $ua->request(HTTP::Request::Common::POST(@_)) } }
       http_put   : sub { require LWP::UserAgent; sub { my $ua = LWP::UserAgent->new(); $ua->request(HTTP::Request::Common::PUT(@_)) } }
       http_delete: sub { require LWP::UserAgent; sub { my $ua = LWP::UserAgent->new(); $ua->request(HTTP::Request::Common::DELETE(@_)) } }
       http_head  : sub { require LWP::UserAgent; sub { my $ua = LWP::UserAgent->new(); $ua->request(HTTP::Request::Common::HEAD(@_)) } }
   
   mail:
     Mail::Sendmail:
       sendmail: mail_send
   
   carp:
     Carp:
       - croak
       - cluck
       - carp
       - confess
       - shortmess
       - longmess
   
   yaml:
     YAML::Syck:
       LoadFile: yaml_load_file
       Load:     yaml_load
       DumpFile: yaml_dump_file
       Dump:     yaml_dump
   
   json:
     JSON::Syck:
       LoadFile: json_load_file
       Load:     json_load	    
       DumpFile: json_dump_file
       Dump:     json_dump	    
   
   datetime:
     DateTime::Duration:
       year   : sub {sub () { DateTime::Duration->new(years   => 1) }}
       month  : sub {sub () { DateTime::Duration->new(months  => 1) }}
       day    : sub {sub () { DateTime::Duration->new(days    => 1) }}
       hour   : sub {sub () { DateTime::Duration->new(hours   => 1) }}
       minute : sub {sub () { DateTime::Duration->new(minutes => 1) }}
       second : sub {sub () { DateTime::Duration->new(seconds => 1) }}
       datetime_duration: sub {sub {DateTime::Duration->new(@_)}}
     Date::Parse:
       datetime_parse: |
         sub {
           my $i = 1;
           unless ($INC{"Date/Manip.pm"}) {
             require Date::Manip;
             $i = 0;
           }
           sub {
             unless ($i) {
               $i = 1;
               Date::Manip::Date_Init();
             }
             my ($ss,$mm,$hh,$day,$month,$year,$zone) = Date::Parse::strptime(@_);
             DateTime->new(year => $year + 1900, month => ++$month, day => $day,
               hour => $hh || 0, minute => $mm || 0, second => $ss || 0,
               time_zone => $Date::Manip::Zone{n2o}->{Time::Zone::tz_name($zone)});
           }
         }
     DateTime:
       today   : sub {sub () { DateTime->today(@_) }}
       now     : sub {sub () { DateTime->now(@_) }}
       datetime: sub {sub { DateTime->new(@_) }}
   
   benchmark:
     Benchmark:
       - timeit
       - timethis
       - timethese
       - timediff
       - timestr
       - timesum
       - cmpthese
       - countit
   
   file:
     File::Find:
       find : file_find
     File::Path:
       - make_path
       - remove_tree
     File::Slurp:
       slurp     : file_slurp
       read_file : file_read
       write_file: file_write
     File::Copy:
       copy: file_copy
       move: file_move
   
   return:
     Return::Value:
       - success
       - failure


=head1 QUESTIONS

=head2 ALL MODULE(S) IS/ARE LOADED WHEN USING Util::All?

No. the related module(s) of your selected kind(s) is/are loaded.

=head2 WHY '-all' IS SLOW?

Keyword '-all' as same as 'all' and ':all' is used,
L<Util::Any> check exportable functions in  all modules defined in $Utils and
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
