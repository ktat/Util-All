package Util::All::Plugin::Net;

use strict;

sub utils {
  return {
    -net => [
             [
              'Net::Amazon', '',
              {
               amazon => sub {
                 my ($pkg, $class, $func, $args) = @_;
                 my $amazon;
                 if (defined %$args) {
                   $amazon = Net::Amazon->new(token => $args->{token}, secret_key => $args->{secret_key});
                 }
                 sub { $amazon ||= Net::Amazon->new(token => $args->{token})};
               },
              }
             ],
            ]
         };
}

1;

=pod

=head1 NAME

Util::All::Plugin::Net

=head1 METHOD

=head2 utils

=cut
