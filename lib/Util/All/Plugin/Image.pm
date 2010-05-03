package Util::All::Plugin::Image;

use warnings;
use strict;

sub utils {
  {
  '-image' => [
    [
      'Image::Info',
      '',
      {
        '-select' => [],
        'image_type' => sub {
            sub {
                my($file) = @_;
                my $type = Image::Info::image_type($file);
                if (exists $$type{'error'}) {
                    die $$type{'error'};
                }
                return $$type{'file_type'};
            }
            ;
        },
        'image_info' => sub {
            sub {
                my($file) = @_;
                my $info = Image::Info::image_info($file);
                if (ref $info eq 'HASH' and exists $$info{'error'}) {
                    die $$info{'error'};
                }
                return $info;
            }
            ;
        }
      }
    ],
    [
      'Imager',
      '',
      {
        'convert_image' => sub {
            sub {
                my($before, $after) = @_;
                $after ||= '';
                my $img = 'Imager'->new;
                die $img->errstr unless $img->read('file', $before);
                if (not $after =~ /\./) {
                    my $i;
                    die $img->errstr unless $img->write('data', \$i, 'type', $after);
                    print $i;
                }
                else {
                    die $img->errstr unless $img->write('file', $after);
                }
                return $img;
            }
            ;
        },
        '-select' => [],
        'resize_image' => sub {
            sub ($@) {
                my($before, $after, @conf) = @_;
                $after ||= '';
                my $img = 'Imager'->new;
                die $img->errstr unless $img->read('file', $before);
                my %conf;
                if (ref $conf[0] eq 'ARRAY') {
                    $conf{'xpixels'} = $conf[0][0];
                    $conf{'ypixels'} = $conf[0][1];
                    $conf{'type'} = 'nonprop';
                }
                elsif (@conf == 1 and not ref $conf[0]) {
                    $conf{'scalefactor'} = $conf[0];
                }
                else {
                    (%conf) = @conf;
                }
                my $newimg = $img->scale(%conf);
                if (not $after =~ /\./) {
                    my $i;
                    die $newimg->errstr unless $newimg->write('data', \$i, 'type', $after);
                    print $i;
                }
                else {
                    die $newimg->errstr unless $newimg->write('file', $after);
                }
                return $newimg;
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

Util::All::Plugin::Image; -  Util::All plugin for Image

=cut

=head1 EXPORT

NOTE THAT: almost all of functions' explantion is cited from original modules' document.

=head2 -image

=head3 convert_image

    convert_image("before.jpg", "after.png");
    convert_image("before.jpg", "png"); # output to stdout as ping


convert images to other format.

=head3 image_info

    my $info = image_info("picture.jpg");

return image information(Image::Info)

=head3 image_type

    my $info = image_type("picture.jpg");

return image type(Image::Info)

=head3 resize_image

    resize_image("before.jpg", "after.png", %option);
    resize_image("before.jpg", "after.png", [200, 100]); # 200x100px
    resize_image("before.jpg", "after.png", 0.5); # 1/2 scale
    resize_image("before.jpg", "png", 0.5);  # output 1/2 scale image to STDOUT as ping


resize image.




=head1 AUTHOR

Ktat, C<< <ktat at cpan.org> >>

=head1 REPOSITORY

Util::All is hosted at github.

L<http://github.com/ktat/Util-All>

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

 perldoc Util::All::Image

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