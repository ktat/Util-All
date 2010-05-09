package Util::All::Plugin::Number;

use warnings;
use strict;

sub utils {
  {
  '-number' => [
    [
      'Number::Format',
      '',
      {
        'number_price' => sub {
            my($pkg, $class, $func, $args, $kind_args) = @_;
            my $n = 'Number::Format'->new(%$kind_args, %$args);
            sub {
                $n->format_price(@_);
            }
            ;
        },
        'number_commify' => sub {
            sub {
                local $_ = shift @_;
                while (s/((?:\A|[^.0-9])[-+]?\d+)(\d{3})/$1,$2/s) {
                    ();
                }
                return $_;
            }
            ;
        },
        'number_unit' => sub {
            my($pkg, $class, $func, $args, $kind_args) = @_;
            my $n = 'Number::Format'->new(%$kind_args, %$args);
            sub {
                $n->format_bytes(@_);
            }
            ;
        },
        '-select' => [],
        'to_number' => sub {
            my($pkg, $class, $func, $args, $kind_args) = @_;
            my $n = 'Number::Format'->new(%$kind_args, %$args);
            sub {
                $n->unformat_number(@_);
            }
            ;
        },
        'number_round' => sub {
            my($pkg, $class, $func, $args, $kind_args) = @_;
            my $n = 'Number::Format'->new(%$kind_args, %$args);
            sub {
                $n->round(@_);
            }
            ;
        },
        'number_format' => sub {
            my($pkg, $class, $func, $args, $kind_args) = @_;
            my $n = 'Number::Format'->new(%$kind_args, %$args);
            sub {
                $n->format_number(@_);
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

Util::All::Plugin::Number; -  Util::All plugin for Number

=cut

=head1 EXPORT

NOTE THAT: almost all of functions' explantion is cited from original modules' document.

=head2 -number

=head3 number_commify

    $n = number_commify(1000);

commify number.

=head3 number_price

    number_price(10000); # JPY 10,000
    number_price(10000, 0, '\'); # \10,000


number to price string.

=head3 number_unit

    number_unit(1024, unit => 'K', mode => 'iec');     # 1KiB
    number_unit(1048576, unit => 'M', mode => 'trad'); # 1M


number to unit.

=head3 number_round

    $n = number_round(3.14159);

round number.

=head3 to_number

    to_number(1,000);   # 1000
    to_number("1KiB");  # 1024
    to_number("1K");    # 1024


string to number.

=head3 number_format

    number_round($number, $precision, $trailing_zeroes);
    number_round(1000); # 1,000
    number_round(1000, 2, 0); # 1,000
    number_round(1000, 2, 2); # 1,000,00


format number.



=head1 AUTHOR

Ktat, C<< <ktat at cpan.org> >>

=head1 REPOSITORY

Util::All is hosted at github.

L<http://github.com/ktat/Util-All>

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

 perldoc Util::All::Number

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