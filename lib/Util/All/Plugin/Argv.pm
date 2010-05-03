package Util::All::Plugin::Argv;

use warnings;
use strict;

sub utils {
  {
  '-argv' => [
    [
      'Encode::Argv',
      '',
      {
        '-select' => [],
        '.' => sub {
            my($pkg, $class, $func, $args, $kind_args) = @_;
            my($in, $to) = ('utf8', '');
            if (ref $kind_args eq 'ARRAY') {
                ($in, $to) = @$kind_args;
            }
            elsif (ref $kind_args eq 'HASH') {
                $in = $$kind_args{'in'} || 'utf8';
                $to = $$kind_args{'to'};
            }
            else {
                $in = $kind_args;
            }
            'Encode::Argv'->import($in, $to ? $to : ());
        }
      }
    ]
  ]
}
;
}

=head1 NAME

Util::All::Plugin::Argv; -  Util::All plugin for Argv

=cut

=head1 EXPORT

NOTE THAT: almost all of functions' explantion is cited from original modules' document.

=head2 -argv

make @ARGV's utf8 flag on/encode @ARGV.

  use Util::All -argv; # @ARGV's utf8 flag on (argument is regarded as UTF8)
  use Util::All -argv => [-args => 'euc-jp']; # @ARGV's utf8 flag on (argument is regarded as euc-jp)
  use Util::All -argv => [-args => ['utf8', 'euc-jp']]; # convert utf8 to euc-jp
  use Util::All -argv => [-args => { in => 'utf8', to => 'euc-jp'}]; # as same as the above




=head1 AUTHOR

Ktat, C<< <ktat at cpan.org> >>

=head1 REPOSITORY

Util::All is hosted at github.

L<http://github.com/ktat/Util-All>

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

 perldoc Util::All::Argv

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