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

NOTE THAT: almost all of functions' explantion is cited from original modules' document.

=head2 -prompt

=head3 Arguments to C<prompt>

Any argument not of the following forms is treated as part of the text of the
prompt itself.

 Flag   Long form      Arg          Effect
 ----   ---------      ---          ------
                       <str>        Use <str> as prompt

                       <filehandle> Prompt to specified filehandle

                       <hashref>    Flatten hash entries into argument list
                                    (useful for aggregating the options below)

 -p     -prompt        <str>        Specify prompt explicitly

 -s     -speed         <num>        Simulated typing speed (seconds/char)

 -e     -echo          <str>        What to echo for each char typed

 -nl    -newline       <str>        When a newline is typed, echo <str> instead

 -d     -default       <str>        What to return if only <return> pressed


 -r     -require       <hashref>    Each value of each entry must 'smartmatch'
                                    the input else corresponding key is printed
                                    as error message:
                                     - Subs must return true when passed input
                                     - Regexes must pattern match input
                                     - Strings must eq match input
                                     - Arrays are flattened & recursively matched
                                     - Hashes must return true for input as key

 -u     -until         <str|rgx>    Fail if input matches <str|regex>
        -fail_if               

 -w     -while         <str|rgx>    Fail unless input matches <str|regex>
        -okay_if       

 -m     -menu          <list|hash>  Show the data specified as a menu 
                                    and allow one to be selected. Enter
                                    an <ESC> to back up one level.

 -1     -one_char                   Return immediately after first char typed

 -x     -escape                     Pressing <ESC> returns "\e" immediately

 -raw   -raw_input                  Return only the string that was input
                                    (turns off context-sensitive features)

 -c     -clear                      Clear screen before prompt
 -f     -clear_first                Clear screen before first prompt only

 -a     -argv                       Load @ARGV from input if @ARGV empty

 -l     -line                       Don't autochomp

 -t     -tty                        Prompt to terminal no matter what

 -y     -yes                        Return true if [yY] entered, false otherwise
 -yn    -yes_no                     Return true if [yY], false if [nN]
 -Y     -Yes                        Return true if 'Y' entered, false otherwise
 -YN    -Yes_No                     Return true if 'Y', false if 'N'

 -num   -number                     Accept only valid numbers as input
 -i     -integer                    Accept only valid integers as input

Note that the underscores between words in flags like C<-one_char> and
C<-yes_no> are optional.

Flags can be "cuddled". For example:

     prompt("next: ", -tyn1s=>0.2)   # -tty, -yes, -no, -one_char, -speed=>0.2


(This explanation is cited from L<IO::Prompt>)

=head3 required_prompt

    password_prompt($message, @option_for_prompt);

If inputted value is empty, re-prompt.


=head3 password_prompt

    password_prompt($message, @option_for_prompt);

This is equal to

  IO::Prompt::prompt($message, -echo => "*", @option_for_prompt);




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