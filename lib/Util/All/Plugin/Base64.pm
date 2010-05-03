package Util::All::Plugin::Base64;

use warnings;
use strict;

sub utils {
  {
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
  ]
}
;
}

=head1 NAME

Util::All::Plugin::Base64; -  Util::All plugin for Base64

=cut

=head1 EXPORT

NOTE THAT: almost all of functions' explantion is cited from original modules' document.

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





=head1 AUTHOR

Ktat, C<< <ktat at cpan.org> >>

=head1 REPOSITORY

Util::All is hosted at github.

L<http://github.com/ktat/Util-All>

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

 perldoc Util::All::Base64

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