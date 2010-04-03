package Util::All::Plugin::Datetime;

use warnings;
use strict;

sub utils {
  {
  '-datetime' => [
    [
      'DateTime',
      '',
      {
        'now' => sub {
            sub () {
                'DateTime'->now(@_);
            }
            ;
        },
        'today' => sub {
            sub () {
                'DateTime'->today(@_);
            }
            ;
        },
        '-select' => [],
        'datetime' => sub {
            sub {
                'DateTime'->new(@_);
            }
            ;
        }
      }
    ],
    [
      'DateTime::Duration',
      '',
      {
        'hour' => sub {
            my($pkg, $class, $func, $args, $kind_args) = @_;
            sub () {
                'DateTime::Duration'->new('hours', 1, 'end_of_month', $$args{'end_of_month'} || $$kind_args{'end_of_month'} || 'limit');
            }
            ;
        },
        'hours' => sub {
            my($pkg, $class, $func, $args, $kind_args) = @_;
            sub ($) {
                'DateTime::Duration'->new('hours', shift @_, 'end_of_month', $$args{'end_of_month'} || $$kind_args{'end_of_month'} || 'limit');
            }
            ;
        },
        '-select' => [],
        'second' => sub {
            my($pkg, $class, $func, $args, $kind_args) = @_;
            sub () {
                'DateTime::Duration'->new('seconds', 1, 'end_of_month', $$args{'end_of_month'} || $$kind_args{'end_of_month'} || 'limit');
            }
            ;
        },
        'month' => sub {
            my($pkg, $class, $func, $args, $kind_args) = @_;
            sub () {
                'DateTime::Duration'->new('months', 1, 'end_of_month', $$args{'end_of_month'} || $$kind_args{'end_of_month'} || 'limit');
            }
            ;
        },
        'minutes' => sub {
            my($pkg, $class, $func, $args, $kind_args) = @_;
            sub ($) {
                'DateTime::Duration'->new('minutes', shift @_, 'end_of_month', $$args{'end_of_month'} || $$kind_args{'end_of_month'} || 'limit');
            }
            ;
        },
        'days' => sub {
            my($pkg, $class, $func, $args, $kind_args) = @_;
            sub ($) {
                'DateTime::Duration'->new('days', shift @_, 'end_of_month', $$args{'end_of_month'} || $$kind_args{'end_of_month'} || 'limit');
            }
            ;
        },
        'seconds' => sub {
            my($pkg, $class, $func, $args, $kind_args) = @_;
            sub ($) {
                'DateTime::Duration'->new('seconds', shift @_, 'end_of_month', $$args{'end_of_month'} || $$kind_args{'end_of_month'} || 'limit');
            }
            ;
        },
        'minute' => sub {
            my($pkg, $class, $func, $args, $kind_args) = @_;
            sub () {
                'DateTime::Duration'->new('minutes', 1, 'end_of_month', $$args{'end_of_month'} || $$kind_args{'end_of_month'} || 'limit');
            }
            ;
        },
        'years' => sub {
            my($pkg, $class, $func, $args, $kind_args) = @_;
            sub ($) {
                'DateTime::Duration'->new('years', shift @_, 'end_of_month', $$args{'end_of_month'} || $$kind_args{'end_of_month'} || 'limit');
            }
            ;
        },
        'day' => sub {
            my($pkg, $class, $func, $args, $kind_args) = @_;
            sub () {
                'DateTime::Duration'->new('days', 1, 'end_of_month', $$args{'end_of_month'} || $$kind_args{'end_of_month'} || 'limit');
            }
            ;
        },
        'datetime_duration' => sub {
            my($pkg, $class, $func, $args, $kind_args) = @_;
            sub {
                'DateTime::Duration'->new('end_of_month', $$args{'end_of_month'} || $$kind_args{'end_of_month'} || 'limit', @_);
            }
            ;
        },
        'year' => sub {
            my($pkg, $class, $func, $args, $kind_args) = @_;
            sub () {
                'DateTime::Duration'->new('years', 1, 'end_of_month', $$args{'end_of_month'} || $$kind_args{'end_of_month'} || 'limit');
            }
            ;
        },
        'months' => sub {
            my($pkg, $class, $func, $args, $kind_args) = @_;
            sub ($) {
                'DateTime::Duration'->new('months', shift @_, 'end_of_month', $$args{'end_of_month'} || $$kind_args{'end_of_month'} || 'limit');
            }
            ;
        }
      }
    ],
    [
      'Date::Parse',
      '',
      {
        '-select' => [],
        'datetime_parse' => sub {
            my $i = 1;
            if (not $INC{'Date/Manip.pm'}) {
                $i = eval 'require Date::Manip' ? 0 : 2;
            }
            if ($i == 2) {
                require DateTime::TimeZone;
                return sub {
                    my($ss, $mm, $hh, $day, $month, $year, $zone) = Date::Parse::strptime(@_);
                    my $offset = defined $zone ? 'DateTime::TimeZone'->offset_as_string($zone) : 'local';
                    'DateTime'->new('year', $year + 1900, 'month', ++$month, 'day', $day, 'hour', $hh || 0, 'minute', $mm || 0, 'second', $ss || 0, 'time_zone', $offset);
                }
                ;
            }
            else {
                return sub {
                    unless ($i) {
                        $i = 1;
                        Date::Manip::Date_Init();
                    }
                    my($ss, $mm, $hh, $day, $month, $year, $zone) = Date::Parse::strptime(@_);
                    'DateTime'->new('year', $year + 1900, 'month', ++$month, 'day', $day, 'hour', $hh || 0, 'minute', $mm || 0, 'second', $ss || 0, 'time_zone', $Date::Manip::Zone{'n2o'}{Time::Zone::tz_name($zone)} || 'local');
                }
                ;
            }
        }
      }
    ]
  ]
}
;
}

=head1 NAME

Util::All::Plugin::Datetime; -  Util::All plugin for Datetime

=cut

=head1 EXPORT

functions which C<*> follows are generated by the way like Sub::Exporter.
see L<Util::Any/"USE Sub::Exporter's GENERATOR WAY">

=head2 -datetime

=head3 functions to return DateTime object

  $dt = datetime(year => .., month => ..,);
  $dt = datetime_parse("2009/09/09");
  $dt = now;
  $dt = today;

=head3 functions to return DateTime::Duration object

NOTE THAT: end_of_month is set as limit.

  year
  month
  day
  hour
  minute
  second

They return DateTime::Duration object. So you can use them for calcuration.

  $duration = year + month + day

You can use plural form of these functions, too which can take number.

  years 5;
  months 5;

example:

  $after_five_year_from_now = now + years 5;

=head3 How to change end_of_month?

  use Util::All -datetime => [-args => {end_of_month => 'wrap'}];


=head3 function enable to rename *

now, today, datetime, hour, hours, second, month, minutes, days, seconds, minute, years, day, datetime_duration, year, months, datetime_parse

=head3 test code

 package test_datetime1;
 use Util::All '-datetime';
 my $dt = datetime_parse("1970/01/01");
 $dt += year;
 $dt->year;
 # equal to: 1971

 package test_datetime2;
 use Util::All '-datetime';
 my $dt = datetime_parse("1970/01/01");
 $dt += years 2;
 $dt->year;
 # equal to: 1972

 package test_datetime3;
 use Util::All '-datetime';
 my $dt = datetime_parse("1970/02/01");
 $dt += month;
 $dt->day;
 # equal to: 1

 package test_datetime4;
 use Util::All '-datetime';
 year->end_of_month_mode;
 # equal to: ('limit')

 package test_datetime5;
 use Util::All '-datetime' => [-args => {end_of_month => 'wrap'}];
 year->end_of_month_mode;
 # equal to: ('wrap')

 package test_datetime6;
 use Util::All '-datetime' => ['month', year => {end_of_month => 'preserve'}];
 join ' ', year->end_of_month_mode, month->end_of_month_mode;
 # equal to: ('preserve limit')

 package test_datetime7;
 use Util::All '-datetime' => ['year', month => {end_of_month => 'wrap'}];
 join ' ', month->end_of_month_mode, year->end_of_month_mode;
 # equal to: ('wrap limit')

 package test_datetime8;
 use Util::All '-datetime' => ['day', days => {end_of_month => 'preserve'}];
 join ' ', days(5)->end_of_month_mode, day->end_of_month_mode;
 # equal to: ('preserve limit')



=head1 AUTHOR

Ktat, C<< <ktat at cpan.org> >>

=head1 REPOSITORY

Util::All is hosted at github.

L<http://github.com/ktat/Util-All>

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

 perldoc Util::All::Datetime

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