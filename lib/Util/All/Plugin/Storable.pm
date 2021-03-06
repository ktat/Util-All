package Util::All::Plugin::Storable;

use warnings;
use strict;

sub utils {
  {
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
  ]
}
;
}

=head1 NAME

Util::All::Plugin::Storable; -  Util::All plugin for Storable

=cut

=head1 EXPORT

NOTE THAT: almost all of functions' explantion is cited from original modules' document.

=head2 -storable

=head3 freeze

    $storable_data = freeze($data);

serialize $storable_data

=head3 thaw

    $data = thaw($storable_data);

retrieve data from stroable.



=head1 AUTHOR

Ktat, C<< <ktat at cpan.org> >>

=head1 REPOSITORY

Util::All is hosted at github.

L<http://github.com/ktat/Util-All>

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

 perldoc Util::All::Storable

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