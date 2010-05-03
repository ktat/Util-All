package Util::All::Plugin::Yaml;

use warnings;
use strict;

sub utils {
  {
  '-yaml' => [
    [
      'YAML::XS',
      '',
      {
        'to_yaml' => sub {
            require Encode;
            require Data::Structure::Util;
            require Data::Recursive::Encode;
            sub {
                my $data = shift @_;
                $data = 'Data::Recursive::Encode'->decode('utf8', $data) unless Data::Structure::Util::has_utf8($data);
                YAML::XS::Dump($data);
            }
            ;
        },
        'to_yaml_file' => sub {
            require Encode;
            require Data::Structure::Util;
            require Data::Recursive::Encode;
            sub {
                my($data, $file) = @_;
                $data = 'Data::Recursive::Encode'->decode('utf8', $data) unless Data::Structure::Util::has_utf8($data);
                File::Slurp::write_file($file, YAML::XS::Dump($data));
            }
            ;
        },
        '-select' => [],
        'from_yaml_file' => sub {
            require File::Slurp;
            sub ($) {
                YAML::XS::Load(scalar File::Slurp::slurp(shift @_));
            }
            ;
        },
        'from_yaml' => sub {
            require Encode;
            sub {
                my $yaml = shift @_;
                YAML::XS::Load(utf8::is_utf8($yaml) ? Encode::encode('utf8', $yaml) : $yaml);
            }
            ;
        },
        'Load' => 'decode_yaml',
        'Dump' => 'encode_yaml'
      }
    ]
  ]
}
;
}

=head1 NAME

Util::All::Plugin::Yaml; -  Util::All plugin for Yaml

=cut

=head1 EXPORT

NOTE THAT: almost all of functions' explantion is cited from original modules' document.

=head2 -yaml

=head3 to_yaml_file

    to_yaml_file($data, $yaml_file);

dump YAML data to file

=head3 to_yaml

    sub {
        require Encode;
        require Data::Structure::Util;
        require Data::Recursive::Encode;
        sub {
            my $data = shift;
            $data = Data::Recursive::Encode->decode( 'utf8', $data )
              unless Data::Structure::Util::has_utf8($data);
            YAML::XS::Dump($data);
          }
      }


=head3 decode_yaml

(Load of L<YAML::XS>)

=head3 encode_yaml

(Dump of L<YAML::XS>)

=head3 from_yaml_file

    from_yaml_file($yaml_file);

load YAML data from file

=head3 from_yaml

    sub {
        require Encode;
        sub {
            my $yaml = shift;
            YAML::XS::Load(
                utf8::is_utf8($yaml) ? Encode::encode( "utf8", $yaml ) : $yaml );
          }
      }




=head1 AUTHOR

Ktat, C<< <ktat at cpan.org> >>

=head1 REPOSITORY

Util::All is hosted at github.

L<http://github.com/ktat/Util-All>

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

 perldoc Util::All::Yaml

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