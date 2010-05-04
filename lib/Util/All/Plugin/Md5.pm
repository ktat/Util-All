package Util::All::Plugin::Md5;

use warnings;
use strict;

sub utils {
  {
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
  ]
}
;
}

=head1 NAME

Util::All::Plugin::Md5; -  Util::All plugin for Md5

=cut

=head1 EXPORT

NOTE THAT: almost all of functions' explantion is cited from original modules' document.

=head2 -md5

=head3 md5($data,...)

This function will concatenate all arguments, calculate the MD5 digest
of this "message", and return it in binary form.  The returned string
will be 16 bytes long.

The result of md5("a", "b", "c") will be exactly the same as the
result of md5("abc").


(This explanation is cited from L<Digest::MD5>)

=head3 md5_hex($data,...)

Same as md5(), but will return the digest in hexadecimal form. The
length of the returned string will be 32 and it will only contain
characters from this set: '0'..'9' and 'a'..'f'.


(This explanation is cited from L<Digest::MD5>)

=head3 md5_base64($data,...)

Same as md5(), but will return the digest as a base64 encoded string.
The length of the returned string will be 22 and it will only contain
characters from this set: 'A'..'Z', 'a'..'z', '0'..'9', '+' and
'/'.

Note that the base64 encoded string returned is not padded to be a
multiple of 4 bytes long.  If you want interoperability with other
base64 encoded md5 digests you might want to append the redundant
string "==" to the result.


(This explanation is cited from L<Digest::MD5>)



=head1 AUTHOR

Ktat, C<< <ktat at cpan.org> >>

=head1 REPOSITORY

Util::All is hosted at github.

L<http://github.com/ktat/Util-All>

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

 perldoc Util::All::Md5

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