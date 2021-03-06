package Util::All;

use warnings;
use strict;

use Util::Any -Base, -Pluggable;

our $Utils = {
  '-carp' => [
    [
      'Carp',
      '',
      {
        '-select' => [
          'croak',
          'cluck',
          'carp',
          'confess'
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
            require Data::Dumper;
            sub (@) {
                local $Data::Dumper::Deparse = 1;
                local $Data::Dumper::Terse = 1;
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
  '-modern' => [
    [
      'strict',
      '',
      {
        '-select' => [],
        '.' => sub {
            my($pkg, $class, $func, $args, $kind_args) = @_;
            'warnings'->import;
            'strict'->import;
            if ($] < 5.009005) {
                require MRO::Compat;
                'MRO::Compat'->import;
            }
            elsif ($] >= 5.01) {
                require feature;
                require mro;
                'feature'->import(':5.10');
                &mro::set_mro(scalar caller 2, 'c3');
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
        'time' => 'utime',
        '-select' => [
          'usleep',
          'nanosleep',
          'ualarm'
        ]
      }
    ]
  ]
}
;

sub _default_kinds { '-modern', '-dumper' }

=head1 NAME

Util::All -  (alpha software) collect perl utilities and group them by appropriate kind.

=cut

our $VERSION = '0.01';

=head1 SYNOPSIS

See L<Util::All::Manual> to check complete list of functions that Util::All provides.

 use Util::All;
 # automatically use strict, use warnings, mro c3
 # -dumper is automatically imported.
 
 dump({1 => 2});
 deep_dump(sub { return 1 });

When you want list utilities.

 use Util::All -list;
 my @uniq = uniq @list;

Only you want list any

 use Util::All -list => ['any'];
 my $any = any {$_ > 10} @array;

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
 print z2h_alpha("Аあ"); # only A is to be z2h

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
 Mail::Sendmail::sendmail ... send_mail

But, some functions, which I think no need to add kind, are exception.
For example:

 today ... return today's DateTime object
 now ... return now DateTime object

etc.

=head1 EXPORT

NOTE THAT: -modern & -dumper is automatically imported.

NOTE THAT: almost all of functions' explantion is cited from original modules' document.

=head2 -carp





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


(This explanation is cited from L<Carp>)

=head2 -dumper

=head3 dump

  print dump(@vars);
  dump(@vars);

dump of L<Data::Dump>. 
dump structure. In later case, result is dumped to STDERR.


=head3 ddx

  ddx(@vars);

ddx of L<Data::Dump>.
as same as dd but output to STDOUT with line number.


=head3 dd

  dd(@vars);

dd of L<Data::Dump>.
as same as dump but output to STDOUT.


=head3 pp

  pp("{ x => 1, y => 2, z => 3}");

dump after given string is evaled.

=head3 deep_dump

  deep_dump([1,2,3, sub { ... } ]);

as same as dump. but it dump code reference as string.

=head3 p

  p($variable)

as same as dump(function name is borrowed from Ruby).

=head2 -encode

=head3 $octets  = encode(ENCODING, $string [, CHECK])

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


(This explanation is cited from L<Encode>)

=head3 $string = decode(ENCODING, $octets [, CHECK])

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


(This explanation is cited from L<Encode>)

=head3 [$length =] from_to($octets, FROM_ENC, TO_ENC [, CHECK])

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


(This explanation is cited from L<Encode>)

=head2 -modern

this is automatically used. no need to call it.
It affects the the following to the source of caller package.

   use strict;
   use warnings;
   use feature (':5.10'); # if your perl version > 5.10
   mro::set_mro( scalar caller(), 'c3' );
   # or MRO::Compat->import

If you want to disable this.

  use Util::All -modern => [];

This is similar to L<Modern::Perl>, the difference is this checking Perl version.


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


=head2 -utf8

=head3  $flag = utf8::is_utf8(STRING)

(Since Perl 5.8.1)  Test whether STRING is in UTF-8 internally.
Functionally the same as Encode::is_utf8().


(This explanation is cited from L<utf8>)

=head3 utf8_encode

(encode of L<utf8>)



Converts in-place the character sequence to the corresponding octet
sequence in I<UTF-X>.  The UTF8 flag is turned off, so that after this
operation, the string is a byte string.  Returns nothing.

B<Note that this function does not handle arbitrary encodings.>
Therefore Encode is recommended for the general purposes; see also
L<Encode>.

(This explanation is cited from L<utf8>)



=head3 utf8_off

  my $d = utf8_off($data);

recursively make utf8 flag off(not destructive)

=head3 utf8_upgrade

(upgrade of L<utf8>)



Converts in-place the internal octet sequence in the native encoding
(Latin-1 or EBCDIC) to the equivalent character sequence in I<UTF-X>.
I<$string> already encoded as characters does no harm.  Returns the
number of octets necessary to represent the string as I<UTF-X>.  Can be
used to make sure that the UTF-8 flag is on, so that C<\w> or C<lc()>
work as Unicode on strings containing characters in the range 0x80-0xFF
(on ASCII and derivatives).

B<Note that this function does not handle arbitrary encodings.>
Therefore Encode is recommended for the general purposes; see also
L<Encode>.

(This explanation is cited from L<utf8>)



=head3 utf8_downgrade

(downgrade of L<utf8>)



Converts in-place the internal octet sequence in I<UTF-X> to the
equivalent octet sequence in the native encoding (Latin-1 or EBCDIC).
I<$string> already encoded as native 8 bit does no harm.  Can be used to
make sure that the UTF-8 flag is off, e.g. when you want to make sure
that the substr() or length() function works with the usually faster
byte algorithm.

Fails if the original I<UTF-X> sequence cannot be represented in the
native 8 bit encoding. On failure dies or, if the value of C<FAIL_OK> is
true, returns false. 

Returns true on success.

B<Note that this function does not handle arbitrary encodings.>
Therefore Encode is recommended for the general purposes; see also
L<Encode>.

(This explanation is cited from L<utf8>)



=head3 utf8_on

  my $d = utf8_on($data);

recursively make utf8 flag on(not destructive)

=head2 -utime

=head3 usleep ( $useconds )

Sleeps for the number of microseconds (millionths of a second)
specified.  Returns the number of microseconds actually slept.
Can sleep for more than one second, unlike the C<usleep> system call.
Can also sleep for zero seconds, which often works like a I<thread yield>.
See also C<Time::HiRes::usleep()>, C<Time::HiRes::sleep()>, and
C<Time::HiRes::clock_nanosleep()>.

Do not expect usleep() to be exact down to one microsecond.


(This explanation is cited from L<Time::HiRes>)

=head3 nanosleep ( $nanoseconds )

Sleeps for the number of nanoseconds (1e9ths of a second) specified.
Returns the number of nanoseconds actually slept (accurate only to
microseconds, the nearest thousand of them).  Can sleep for more than
one second.  Can also sleep for zero seconds, which often works like
a I<thread yield>.  See also C<Time::HiRes::sleep()>,
C<Time::HiRes::usleep()>, and C<Time::HiRes::clock_nanosleep()>.

Do not expect nanosleep() to be exact down to one nanosecond.
Getting even accuracy of one thousand nanoseconds is good.


(This explanation is cited from L<Time::HiRes>)

=head3 ualarm ( $useconds [, $interval_useconds ] )

Issues a C<ualarm> call; the C<$interval_useconds> is optional and
will be zero if unspecified, resulting in C<alarm>-like behaviour.

Returns the remaining time in the alarm in microseconds, or C<undef>
if an error occurred.

ualarm(0) will cancel an outstanding ualarm().

Note that the interaction between alarms and sleeps is unspecified.


(This explanation is cited from L<Time::HiRes>)

=head3 utime

(time of L<Time::HiRes>)

=head2 negative time not invented yet

You tried to use a negative time argument.

(This explanation is cited from L<Time::HiRes>)





=head1 PLUGINS

=head2 L<Util::All::Plugin::Argv>

=head2 L<Util::All::Plugin::Base64>

=head2 L<Util::All::Plugin::Basecalc>

=head2 L<Util::All::Plugin::Benchmark>

=head2 L<Util::All::Plugin::Cgi>

=head2 L<Util::All::Plugin::Charset>

=head2 L<Util::All::Plugin::Csv>

=head2 L<Util::All::Plugin::Data>

=head2 L<Util::All::Plugin::Datetime>

=head2 L<Util::All::Plugin::Debug>

=head2 L<Util::All::Plugin::Email>

=head2 L<Util::All::Plugin::Exception>

=head2 L<Util::All::Plugin::File>

=head2 L<Util::All::Plugin::Hash>

=head2 L<Util::All::Plugin::Http>

=head2 L<Util::All::Plugin::Image>

=head2 L<Util::All::Plugin::Json>

=head2 L<Util::All::Plugin::List>

=head2 L<Util::All::Plugin::Math>

=head2 L<Util::All::Plugin::Md5>

=head2 L<Util::All::Plugin::Number>

=head2 L<Util::All::Plugin::Prompt>

=head2 L<Util::All::Plugin::Serialize>

=head2 L<Util::All::Plugin::Sha>

=head2 L<Util::All::Plugin::Storable>

=head2 L<Util::All::Plugin::String>

=head2 L<Util::All::Plugin::Subroutine>

=head2 L<Util::All::Plugin::Unicode>

=head2 L<Util::All::Plugin::Uri>

=head2 L<Util::All::Plugin::Xml>

=head2 L<Util::All::Plugin::Yaml>

=head2 L<Util::All::Plugin::Yml>

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
 IO::String
 Pod::Section

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

L<Benchmark>, L<CGI::Util>, L<Carp>, L<Class::Accessor::Fast>, L<Class::Data::Inheritable>, L<Clone>, L<Data::Dump>, L<Data::Dumper>, L<Data::Recursive::Encode>, L<Data::Serializer>, L<Data::Structure::Util>, L<Data::Util>, L<Date::Manip>, L<Date::Parse>, L<DateTime>, L<DateTime::Duration>, L<Devel::Cycle>, L<Devel::Size>, L<Digest::MD5>, L<Digest::SHA>, L<Email::MIME>, L<Email::Sender::Simple>, L<Encode>, L<Encode::Argv>, L<File::Copy>, L<File::Find>, L<File::Path>, L<File::Slurp>, L<File::Temp>, L<HTML::Entities>, L<HTTP::Request::Common>, L<Hash::Util>, L<IO::Prompt>, L<IO::String>, L<Image::Info>, L<Imager>, L<JSON::XS>, L<LWP::UserAgent>, L<List::MoreUtils>, L<List::Pairwise>, L<List::Util>, L<MIME::Base64>, L<MIME::Base64::URLSafe>, L<MIME::Types>, L<Math::BaseCalc>, L<Number::Format>, L<Path::Class>, L<Scalar::Util>, L<Storable>, L<String::CamelCase>, L<String::Util>, L<Template>, L<Term::Encoding>, L<Text::CSV>, L<Tie::IxHash>, L<Time::HiRes>, L<Toolbox::Simple>, L<Try::Tiny>, L<URI>, L<URI::Escape>, L<URI::Split>, L<Unicode::CharName>, L<Unicode::Japanese>, L<Unicode::String>, L<XML::Parser>, L<XML::Simple>, L<YAML::XS>

=head1 SEE ALSO

=over 4

=item L<Util::All::Manual>

complete list of All functions(including Util::ALL plugins') .

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
