package Util::All::Plugin::Sha;

use warnings;
use strict;

sub utils {
  {
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
  ]
}
;
}

=head1 NAME

Util::All::Plugin::Sha; -  Util::All plugin for Sha

=cut

=head1 EXPORT

NOTE THAT: almost all of functions' explantion is cited from original modules' document.

=head2 -sha

=head3 B<sha1($data, ...)>


(This explanation is cited from L<Digest::SHA>)

=head3 B<sha256($data, ...)>


(This explanation is cited from L<Digest::SHA>)

=head3 B<sha384($data, ...)>


(This explanation is cited from L<Digest::SHA>)

=head3 B<sha512($data, ...)>

Logically joins the arguments into a single string, and returns
its SHA-1/224/256/384/512 digest encoded as a binary string.


(This explanation is cited from L<Digest::SHA>)

=head3 B<sha1_hex($data, ...)>


(This explanation is cited from L<Digest::SHA>)

=head3 B<sha256_hex($data, ...)>


(This explanation is cited from L<Digest::SHA>)

=head3 B<sha384_hex($data, ...)>


(This explanation is cited from L<Digest::SHA>)

=head3 B<sha512_hex($data, ...)>

Logically joins the arguments into a single string, and returns
its SHA-1/224/256/384/512 digest encoded as a hexadecimal string.


(This explanation is cited from L<Digest::SHA>)

=head3 B<sha1_base64($data, ...)>


(This explanation is cited from L<Digest::SHA>)

=head3 B<sha256_base64($data, ...)>


(This explanation is cited from L<Digest::SHA>)

=head3 B<sha384_base64($data, ...)>


(This explanation is cited from L<Digest::SHA>)

=head3 B<sha512_base64($data, ...)>

Logically joins the arguments into a single string, and returns
its SHA-1/224/256/384/512 digest encoded as a Base64 string.

It's important to note that the resulting string does B<not> contain
the padding characters typical of Base64 encodings.  This omission is
deliberate, and is done to maintain compatibility with the family of
CPAN Digest modules.  See L<Digest::SHA/"PADDING OF BASE64 DIGESTS"> for details.


(This explanation is cited from L<Digest::SHA>)



=head1 AUTHOR

Ktat, C<< <ktat at cpan.org> >>

=head1 REPOSITORY

Util::All is hosted at github.

L<http://github.com/ktat/Util-All>

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

 perldoc Util::All::Sha

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