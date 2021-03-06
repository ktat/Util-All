package Util::All::Plugin::Serialize;

use warnings;
use strict;

sub utils {
  {
  '-serialize' => [
    [
      'Data::Serializer',
      '',
      {
        '-select' => [],
        'deserialize' => sub {
            my($pkg, $class, $func, $args, $kind_args) = @_;
            my $ds;
            $ds = 'Data::Serializer'->new(%$kind_args, %$args) if %$kind_args or %$args;
            sub {
                my($serialized_data, $opt) = @_;
                if (not $opt) {
                    $ds->deserialize($serialized_data);
                }
                else {
                    my $ds = 'Data::Serializer'->new(%$opt);
                    $ds->deserialize($serialized_data);
                }
            }
            ;
        },
        'serialize' => sub {
            my($pkg, $class, $func, $args, $kind_args) = @_;
            my $ds;
            $ds = 'Data::Serializer'->new(%$kind_args, %$args) if %$kind_args or %$args;
            sub {
                my($data, $opt) = @_;
                if (not $opt) {
                    $ds->serialize($data);
                }
                else {
                    my $ds = 'Data::Serializer'->new(%$opt);
                    $ds->serialize($data);
                }
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

Util::All::Plugin::Serialize; -  Util::All plugin for Serialize

=cut

=head1 EXPORT

NOTE THAT: almost all of functions' explantion is cited from original modules' document.

=head2 -serialize

=head3 serialize / deserialize

serialize data usign L<Data::Serializer>.

  use Util::All -serialize => [-args => {serializer => 'Storable', digester => 'MD5', cipher => 'DES', secret => 'my secret', compress => 1}];
  my $serialized_data   = serialize({a => 123,  b => 223});
  my $deserialized_data = deserialize($data);

  my $serialized_data   = serialize({a => 123,  b => 223}, {serializer => 'Storable', digester => 'MD5', cipher => 'DES', secret => 'my secret', compress => 1});
  my $deserialized_data = deserialize($data, {serializer => 'Storable', digester => 'MD5', cipher => 'DES', secret => 'my secret', compress => 1});




=head1 AUTHOR

Ktat, C<< <ktat at cpan.org> >>

=head1 REPOSITORY

Util::All is hosted at github.

L<http://github.com/ktat/Util-All>

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

 perldoc Util::All::Serialize

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