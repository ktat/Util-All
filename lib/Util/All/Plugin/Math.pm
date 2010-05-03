package Util::All::Plugin::Math;

use warnings;
use strict;

sub utils {
  {
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
  ]
}
;
}

=head1 NAME

Util::All::Plugin::Math; -  Util::All plugin for Math

=cut

=head1 EXPORT

NOTE THAT: almost all of functions' explantion is cited from original modules' document.

=head2 -math

=head3 functions of L<Toolbox::Simple>

=head4 B<gcd(num, num, num)  /  gcf(num, num, num)>

Both (identical) functions return the greatest common divisor/factor
for the numbers given in their arguments.



=head4 B<lcm(num, num, num)>

Returns the lowest common multiple for the numbers in its argument.



=head4 B<is_prime(num)>

Tests a number for primeness. If it is, returns 1. If it isn't prime, returns 0.





=head1 AUTHOR

Ktat, C<< <ktat at cpan.org> >>

=head1 REPOSITORY

Util::All is hosted at github.

L<http://github.com/ktat/Util-All>

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

 perldoc Util::All::Math

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