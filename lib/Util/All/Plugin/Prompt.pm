package Util::All::Plugin::Prompt;

use warnings;
use strict;

sub utils {
  {
  '-prompt' => [
    [
      'IO::Prompt',
      '',
      {
        'required_prompt' => sub {
            sub {
                my $message = shift @_;
                my $answer;
                PROMPT: {
                    $answer = IO::Prompt::prompt($message, @_);
                    redo PROMPT unless $$answer{'value'};
                    return $$answer{'value'};
                }
            }
            ;
        },
        '-select' => [
          'prompt'
        ],
        'password_prompt' => sub {
            sub {
                my $message = shift @_;
                my $answer;
                $answer = IO::Prompt::prompt($message, -'echo', '*', @_);
                $$answer{'value'};
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

Util::All::Plugin::Prompt; -  Util::All plugin for Prompt

=cut

=head1 EXPORT

functions which C<*> follows are generated by the way like Sub::Exporter.
see L<Util::Any/"USE Sub::Exporter's GENERATOR WAY">

=head2 -prompt

=head3 functions of L<IO::Prompt>

=head4 prompt

=head3 required_prompt *

    sub {
        sub {
            my $message = shift;
            my $answer;
          PROMPT:
            {
                $answer = IO::Prompt::prompt( $message, @_ );
                $answer->{value} or redo PROMPT;
                return $answer->{value};
            }
          }
      }


=head3 password_prompt *

    sub {
        sub {
            my $message = shift;
            my $answer;
            $answer = IO::Prompt::prompt( $message, -echo => "*", @_ );
            $answer->{value};
          }
      }


=head3 test code

 $|=1;
 my $answer = required_prompt("input somthing(1):");
 $answer !~ /%$/;
 # equal to: 1;

 $|=1;
 password_prompt("input somthing(2):");
 my $answer = required_prompt("\ninputted value was displaied as '*' ?(y/n)", -yn);
 $answer eq 'y';
 # equal to: 1;



=head1 AUTHOR

Ktat, C<< <ktat at cpan.org> >>

=head1 REPOSITORY

Util::All is hosted at github.

L<http://github.com/ktat/Util-All>

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

 perldoc Util::All::Prompt

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