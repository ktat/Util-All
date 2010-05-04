package Util::All::Plugin::Exception;

use warnings;
use strict;

sub utils {
  {
  '-exception' => [
    [
      'Try::Tiny',
      '',
      {
        '-select' => [
          'try',
          'catch'
        ]
      }
    ]
  ]
}
;
}

=head1 NAME

Util::All::Plugin::Exception; -  Util::All plugin for Exception

=cut

=head1 EXPORT

NOTE THAT: almost all of functions' explantion is cited from original modules' document.

=head2 -exception

=head3 try (&;@)

Takes one mandatory try subroutine, an optional catch subroutine & finally
subroutine.

The mandatory subroutine is evaluated in the context of an C<eval> block.

If no error occurred the value from the first block is returned, preserving
list/scalar context.

If there was an error and the second subroutine was given it will be invoked
with the error in C<$_> (localized) and as that block's first and only
argument.

Note that the error may be false, but if that happens the C<catch> block will
still be invoked.

Once all execution is finished then the finally block if given will execute.


(This explanation is cited from L<Try::Tiny>)

=head3 catch (&;$)

Intended to be used in the second argument position of C<try>.

Returns a reference to the subroutine it was given but blessed as
C<Try::Tiny::Catch> which allows try to decode correctly what to do
with this code reference.

	catch { ... }

Inside the catch block the previous value of C<$@> is still available for use.
This value may or may not be meaningful depending on what happened before the
C<try>, but it might be a good idea to preserve it in an error stack.


(This explanation is cited from L<Try::Tiny>)



=head1 AUTHOR

Ktat, C<< <ktat at cpan.org> >>

=head1 REPOSITORY

Util::All is hosted at github.

L<http://github.com/ktat/Util-All>

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

 perldoc Util::All::Exception

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