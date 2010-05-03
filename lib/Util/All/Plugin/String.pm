package Util::All::Plugin::String;

use warnings;
use strict;

sub utils {
  {
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
  ]
}
;
}

=head1 NAME

Util::All::Plugin::String; -  Util::All plugin for String

=cut

=head1 EXPORT

NOTE THAT: almost all of functions' explantion is cited from original modules' document.

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


=head3 to_fh

    my $fh = to_fh($scalar);
    print $_ while <$fh>;
    
    to_fh(url  => "http://example.co.jp/");
    to_fh(file => "/path/to/target.txt");
    to_fh(file => "/path/to/target.txt", '>');


create IO::String object, which can be used as filehandle.

=head3 strings

    strings("111\0111");

abstract printable character from scalar. just like strings command.



=head1 AUTHOR

Ktat, C<< <ktat at cpan.org> >>

=head1 REPOSITORY

Util::All is hosted at github.

L<http://github.com/ktat/Util-All>

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

 perldoc Util::All::String

=head1 SEE ALSO

=over 4

=item L<Util::All>

collect perl utilities and group them by appropriate kind.

=item L<Util::Any>

This module is based on Util::Any.
Util::Any helps you to create your own utility module.

=back

=head1 COPYRIGHT & LICENSE

Copyright 2009-2010 Ktat, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut

1;