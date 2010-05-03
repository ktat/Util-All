package Util::All::Plugin::Csv;

use warnings;
use strict;

sub utils {
  {
  '-csv' => [
    [
      'Text::CSV',
      '',
      {
        'parse_csv' => sub {
            my($pkg, $class, $func, $args, $kind_args) = @_;
            $args ||= {};
            $kind_args ||= {};
            use strict 'refs';
            if (not defined &Util::All::_Tmp::Text::CSV::next) {
                no strict 'refs';
                *{'Util::All::_Tmp::Text::CSV::next';} = sub {
                    my $self = shift @_;
                    my $r;
                    not $$self{'pass_fh'} and close $$self{'fh'} unless $r = $$self{'sub'}();
                    return $r;
                }
                ;
            }
            sub {
                my $pass_fh = 0;
                my($fh, $column_names) = @_;
                my $csv = 'Text::CSV'->new({'binary', 1, %$kind_args, %$args});
                if (not ref $fh) {
                    my $file = $fh;
                    undef $fh;
                    Carp::croak("cannot open file: $file") unless open $fh, '<', $file;
                }
                else {
                    $pass_fh = 1;
                }
                my $sub;
                if (@_ == 2) {
                    $csv->column_names($column_names);
                    $sub = sub {
                        $csv->getline_hr($fh);
                    }
                    ;
                }
                else {
                    $sub = sub {
                        $csv->getline($fh);
                    }
                    ;
                }
                return bless({'sub', $sub, 'fh', $fh, 'pass_fh', $pass_fh}, 'Util::All::_Tmp::Text::CSV');
            }
            ;
        },
        '-select' => []
      }
    ]
  ]
}
;
}

=head1 NAME

Util::All::Plugin::Csv; -  Util::All plugin for Csv

=cut

=head1 EXPORT

NOTE THAT: almost all of functions' explantion is cited from original modules' document.

=head2 -csv

=head3 parse_csv

    use Util::All -csv;
    
    my $csv = parse_csv($file_or_fh);
    while (my $ar = $csv->next) {
       print "@$ar\n";
    }
    
    my $csv = parse_csv($file_or_fh, ['name', 'age']);
    while (my $hr = $csv->next) {
       print join " ", %$hr, "\n";
    }
    
    # pass options to Text::CSV
    use Util::All -csv => [-args => {binary => 0, eol => "\r\n"}];




=head1 AUTHOR

Ktat, C<< <ktat at cpan.org> >>

=head1 REPOSITORY

Util::All is hosted at github.

L<http://github.com/ktat/Util-All>

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

 perldoc Util::All::Csv

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