package Util::All::Plugin::Json;

use warnings;
use strict;

sub utils {
  {
  '-json' => [
    [
      'JSON::XS',
      '',
      {
        'to_json_file' => sub {
            require File::Slurp;
            require Encode;
            require Data::Structure::Util;
            sub {
                my $d = shift @_;
                my $f = shift @_;
                File::Slurp::write_file($f, Data::Structure::Util::has_utf8($d) ? JSON::XS::encode_json($d) : Encode::encode('latin1', Encode::decode('utf8', JSON::XS::encode_json($d))));
            }
            ;
        },
        '-select' => [
          'encode_json',
          'decode_json'
        ],
        'from_json_file' => sub {
            require File::Slurp;
            sub ($) {
                JSON::XS::decode_json(scalar File::Slurp::slurp(shift @_));
            }
            ;
        },
        'from_json' => sub {
            sub {
                my $d = shift @_;
                'JSON::XS'->new->utf8(!utf8::is_utf8($d))->decode($d);
            }
            ;
        },
        'to_json' => sub {
            require Data::Structure::Util;
            require Encode;
            sub {
                my $d = shift @_;
                Data::Structure::Util::has_utf8($d) ? JSON::XS::encode_json($d) : Encode::encode('latin1', Encode::decode('utf8', JSON::XS::encode_json($d)));
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

Util::All::Plugin::Json; -  Util::All plugin for Json

=cut

=head1 EXPORT

NOTE THAT: almost all of functions' explantion is cited from original modules' document.

=head2 -json

=head3 to_json_file

    to_json_file($data, $file);

write JSON to file.

=head3 $json_text = encode_json $perl_scalar

Converts the given Perl data structure to a UTF-8 encoded, binary string
(that is, the string contains octets only). Croaks on error.

This function call is functionally identical to:

   $json_text = JSON::XS->new->utf8->encode ($perl_scalar)

Except being faster.


(This explanation is cited from L<JSON::XS>)

=head3 $perl_scalar = decode_json $json_text

The opposite of C<encode_json>: expects an UTF-8 (binary) string and tries
to parse that as an UTF-8 encoded JSON text, returning the resulting
reference. Croaks on error.

This function call is functionally identical to:

   $perl_scalar = JSON::XS->new->utf8->decode ($json_text)

Except being faster.


(This explanation is cited from L<JSON::XS>)

=head3 from_json_file

    from_json_file($json_file);

load JSON data from file. returns Perl data whose utf8 flag is off.

=head3 from_json

    from_json($json_text);

from json text to perl data(utf8 flagged).

=head3 to_json

    to_json($perl_data);

from perl data to json text(utf8 encoded).



=head1 AUTHOR

Ktat, C<< <ktat at cpan.org> >>

=head1 REPOSITORY

Util::All is hosted at github.

L<http://github.com/ktat/Util-All>

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

 perldoc Util::All::Json

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