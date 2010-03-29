package Util::All::Plugin::Number;

use warnings;
use strict;

use Util::Any -Base, -Pluggable;

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
            my $n = 'Number::Format'->new(%$kind_args);
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

functions which C<*> follows are generated by the way like Sub::Exporter.
see L<Util::Any/"USE Sub::Exporter's GENERATOR WAY">

=head2 -number

=head3 number_commify *

  sub {
  
      # code is borrowed from Template::Plugin::Comma
      sub {
          local $_ = shift;
          while (s/((?:\A|[^.0-9])[-+]?\d+)(\d{3})/$1,$2/s) { }
          return $_;
        }
    }


=head3 number_price *

  sub {
      my ( $pkg, $class, $func, $args, $kind_args ) = @_;
      my $n = Number::Format->new( %$kind_args, %$args );
      sub {
          $n->format_price(@_);
        }
    }


=head3 number_unit *

  sub {
      my ( $pkg, $class, $func, $args, $kind_args ) = @_;
      my $n = Number::Format->new( %$kind_args, %$args );
      sub {
          $n->format_bytes(@_);
        }
    }


=head3 number_round *

  sub {
      my ( $pkg, $class, $func, $args, $kind_args ) = @_;
      my $n = Number::Format->new(%$kind_args);
      sub {
          $n->round(@_);
        }
    }


=head3 to_number *

  sub {
      my ( $pkg, $class, $func, $args, $kind_args ) = @_;
      my $n = Number::Format->new( %$kind_args, %$args );
      sub {
          $n->unformat_number(@_);
        }
    }


=head3 number_format *

  sub {
      my ( $pkg, $class, $func, $args, $kind_args ) = @_;
      my $n = Number::Format->new( %$kind_args, %$args );
      sub {
          $n->format_number(@_);
        }
    }


=head3 test code

 number_commify(10000);
 # equal to: ('10,000')

 number_price(10000);
 # equal to: Number::Format->new->format_price(10000);

 number_round(123, -2);
 # equal to: 100

 number_round(123.25, 1);
 # equal to: 123.3

 number_unit(1024, unit => 'K', mode => 'iec')
 # equal to: ('1KiB')

 number_unit(1048576, unit => 'M', mode => 'trad')
 # equal to: ('1M')

 to_number('1,000');
 # equal to: 1000

 to_number('1,025');
 # equal to: 1025

 to_number('1KiB');
 # equal to: 1024



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