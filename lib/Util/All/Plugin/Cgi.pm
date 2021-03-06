package Util::All::Plugin::Cgi;

use warnings;
use strict;

sub utils {
  {
  '-cgi' => [
    [
      'CGI::Util',
      '',
      {
        '-select' => [],
        'unescape' => 'cgi_unescape',
        'escape' => 'cgi_escape'
      }
    ],
    [
      'HTML::Entities',
      '',
      {
        'encode_html_entities' => sub {
            my($pkg, $class, $func, $args, $kind_args) = @_;
            my $_words = $$args{'words'} || $$kind_args{'words'};
            sub {
                my($str, $words) = @_;
                utf8::decode($str) if not utf8::is_utf8($str);
                $str = HTML::Entities::encode_entities($str, $words || $_words);
                unless (defined wantarray) {
                    my $ref = \$_[0];
                    $$ref = $str;
                }
                return $str;
            }
            ;
        },
        '-select' => [],
        'decode_entities' => 'decode_html_entities'
      }
    ]
  ]
}
;
}

=head1 NAME

Util::All::Plugin::Cgi; -  Util::All plugin for Cgi

=cut

=head1 EXPORT

NOTE THAT: almost all of functions' explantion is cited from original modules' document.

=head2 -cgi

=head3 encode_html_entities

  my $new_str = encode_html_entities($str, $words);
  encode_html_entities($str, $words);

encode HTML entity. in void context, it modify argument itself.
this function assumes given argument charset is utf8(utf8 flag on or off).

=head3 decode_html_entities

  @new_args = decode_html_entities(@args);
  decode_html_entities(@args);

decode HTML entity.  in void context, it modify argument itself.




=head1 AUTHOR

Ktat, C<< <ktat at cpan.org> >>

=head1 REPOSITORY

Util::All is hosted at github.

L<http://github.com/ktat/Util-All>

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

 perldoc Util::All::Cgi

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