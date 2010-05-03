package Util::All::Plugin::Uri;

use warnings;
use strict;

sub utils {
  {
  '-uri' => [
    [
      'URI',
      '',
      {
        'make_uri' => sub {
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
        },
        '-select' => [],
        'make_query' => sub {
            require URI::QueryParam;
            sub {
                my($form) = @_;
                my $u = 'URI'->new('', 'http');
                foreach my $k (keys %$form) {
                    my($key, $value) = ($k, $$form{$k});
                    utf8::encode($key) if utf8::is_utf8($k);
                    my(@value) = ref $value ? @$value : $value;
                    foreach $_ (@value) {
                        utf8::encode($_) if utf8::is_utf8($_);
                    }
                    $u->query_param($key, @value);
                }
                $u->query;
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
  ]
}
;
}

=head1 NAME

Util::All::Plugin::Uri; -  Util::All plugin for Uri

=cut

=head1 EXPORT

NOTE THAT: almost all of functions' explantion is cited from original modules' document.

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
I<not> part of the C<unreserved> character class shown above as well
as the reserved characters.  I.e. the default is:

    "^A-Za-z0-9\-\._~"


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


=head3 make_uri

    uri_make('http://example.com/', { foo => "あ", bar => "い"});

create URI with parameter.

=head3 make_query

    make_query({foo => "あ", bar => ["い", "う"]});

create query parameter from hash.



=head1 AUTHOR

Ktat, C<< <ktat at cpan.org> >>

=head1 REPOSITORY

Util::All is hosted at github.

L<http://github.com/ktat/Util-All>

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

 perldoc Util::All::Uri

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