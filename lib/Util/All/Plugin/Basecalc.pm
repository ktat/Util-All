package Util::All::Plugin::Basecalc;

use warnings;
use strict;

sub utils {
  {
  '-basecalc' => [
    [
      'Math::BaseCalc',
      '',
      {
        'to_base' => sub {
            my($pkg, $class, $func, $args, $kind_args) = @_;
            sub {
                'Math::BaseCalc'->new('digits', $$args{'digits'} || $$kind_args{'digits'})->to_base(shift @_);
            }
            ;
        },
        '-select' => [],
        'from_base' => sub {
            my($pkg, $class, $func, $args, $kind_args) = @_;
            sub {
                'Math::BaseCalc'->new('digits', $$args{'digits'} || $$kind_args{'digits'})->from_base(shift @_);
            }
            ;
        }
      }
    ],
    [
      'Toolbox::Simple',
      '',
      {
        '-select' => [
          'dec2hex',
          'hex2dec',
          'dec2bin',
          'dec2oct',
          'oct2dec'
        ]
      }
    ]
  ]
}
;
}

=head1 NAME

Util::All::Plugin::Basecalc; -  Util::All plugin for Basecalc

=cut

=head1 EXPORT

NOTE THAT: almost all of functions' explantion is cited from original modules' document.

=head2 -basecalc

=head3 from_base / to_base

  use Util::All -basecalc => [-args => {digits => [0,1]}];
  to_base(4);     # 100
  from_base(100); # 4

=head2 B<dec2hex(65)>

Converts given decimal number into hexadecimal. Result in example is '41'.

(This explantion is cited from L<Toolbox::Simple>)

=head2 B<hex2dec(1A)>

Converts given hex number into decimal. Result in example is '31'.

(This explantion is cited from L<Toolbox::Simple>)

=head2 B<dec2bin(decimalnumber, bits)>

Converts C<decimalnumber> into a big-endian binary string consisting of C<bits>
bits total (C<bits> can be between 4 and 32).

(This explantion is cited from L<Toolbox::Simple>)

=head2 B<dec2oct()  oct2dec()>

Converts given decimal num to octal, and vice versa.

(This explantion is cited from L<Toolbox::Simple>)




=head1 AUTHOR

Ktat, C<< <ktat at cpan.org> >>

=head1 REPOSITORY

Util::All is hosted at github.

L<http://github.com/ktat/Util-All>

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

 perldoc Util::All::Basecalc

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