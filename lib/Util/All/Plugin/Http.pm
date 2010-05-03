package Util::All::Plugin::Http;

use warnings;
use strict;

sub utils {
  {
  '-http' => [
    [
      'HTTP::Request::Common',
      '',
      {
        'http_post' => sub {
            require LWP::UserAgent;
            my $ua = 'LWP::UserAgent'->new;
            sub {
                $ua->request(HTTP::Request::Common::POST(@_));
            }
            ;
        },
        'http_put' => sub {
            require LWP::UserAgent;
            my $ua = 'LWP::UserAgent'->new;
            sub {
                $ua->request(HTTP::Request::Common::PUT(@_));
            }
            ;
        },
        '-select' => [],
        'http_get' => sub {
            require LWP::UserAgent;
            my $ua = 'LWP::UserAgent'->new;
            sub {
                $ua->request(HTTP::Request::Common::GET(@_));
            }
            ;
        },
        'http_head' => sub {
            require LWP::UserAgent;
            my $ua = 'LWP::UserAgent'->new;
            sub {
                $ua->request(HTTP::Request::Common::HEAD(@_));
            }
            ;
        },
        'http_delete' => sub {
            require LWP::UserAgent;
            my $ua = 'LWP::UserAgent'->new;
            sub {
                $ua->request(HTTP::Request::Common::DELETE(@_));
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

Util::All::Plugin::Http; -  Util::All plugin for Http

=cut

=head1 EXPORT

NOTE THAT: almost all of functions' explantion is cited from original modules' document.

=head2 -http

=head3 http_* functions

do http method and get HTTP::Response object.

  http_get($url, \%query);
  http_post($url, \%query);
  http_put($url, \%query);
  http_delete($url, \%query);
  http_head($url, \%query);




=head1 AUTHOR

Ktat, C<< <ktat at cpan.org> >>

=head1 REPOSITORY

Util::All is hosted at github.

L<http://github.com/ktat/Util-All>

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

 perldoc Util::All::Http

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