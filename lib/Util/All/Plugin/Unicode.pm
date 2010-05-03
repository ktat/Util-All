package Util::All::Plugin::Unicode;

use warnings;
use strict;

sub utils {
  {
  '-unicode' => [
    [
      'Unicode::String',
      '',
      {
        '-select' => [
          'utf32be',
          'utf32le',
          'utf16be',
          'utf16le',
          'utf8',
          'utf7',
          'latin1',
          'uhex',
          'uchr'
        ]
      }
    ],
    [
      'Unicode::CharName',
      '',
      {
        '-select' => [],
        'unicode_name' => sub {
            require Unicode::CharName;
            require Encode;
            sub {
                my $s = shift @_;
                Unicode::CharName::uname($s =~ /\D/ ? ord(utf8::is_utf8($s) ? $s : Encode::decode('utf8', $s)) : $s);
            }
            ;
        },
        'unicode_block' => sub {
            require Unicode::CharName;
            require Encode;
            sub {
                my $s = shift @_;
                Unicode::CharName::ublock($s =~ /\D/ ? ord(utf8::is_utf8($s) ? $s : Encode::decode('utf8', $s)) : $s);
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

Util::All::Plugin::Unicode; -  Util::All plugin for Unicode

=cut

=head1 EXPORT

NOTE THAT: almost all of functions' explantion is cited from original modules' document.

=head2 -unicode

Unicode operation using Unicode::Stirng.

  utf32be($str)->utf8;      # utf32be -> utf8 (byte string)
  utf32le($str)->utf16le;   # utf32le -> utf16le (byte string)
  utf16be($str)->utf8;      # utf16be -> utf8 (byte string)
  utf16le($str)->utf32be;   # utf16le -> utf32be (byte string)
  uhex(2026)->utf8;         # equal to "…"
  uchr(8230)->utf8;         # equal to "…"

If you want unicode name/block.

  nicode_name(ord("\x{2026}"));  # equal to 'HORIZONTAL ELLIPSIS'
  nicode_name('…');              # equal to 'HORIZONTAL ELLIPSIS'
  nicode_block(8230);            # equal to 'General Punctuation'
  nicode_block('…');            # equal to 'General Punctuation'




=head1 AUTHOR

Ktat, C<< <ktat at cpan.org> >>

=head1 REPOSITORY

Util::All is hosted at github.

L<http://github.com/ktat/Util-All>

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

 perldoc Util::All::Unicode

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