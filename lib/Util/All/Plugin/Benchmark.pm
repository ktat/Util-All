package Util::All::Plugin::Benchmark;

use warnings;
use strict;

sub utils {
  {
  '-benchmark' => [
    [
      'Benchmark',
      '',
      {
        'timesamearg' => sub {
            sub {
                my($num, $codes, @args) = @_;
                Benchmark::timethese($num, {map({my $code = $$codes{$_};
                $_, sub {
                    &$code(@args);
                }
                ;} keys %$codes)});
            }
            ;
        },
        '-select' => [
          'timeit',
          'timethis',
          'timethese',
          'timediff',
          'timestr',
          'timesum',
          'cmpthese',
          'countit'
        ],
        'cmpsamearg' => sub {
            sub {
                my($num, $codes, @args) = @_;
                Benchmark::cmpthese($num, {map({my $code = $$codes{$_};
                $_, sub {
                    &$code(@args);
                }
                ;} keys %$codes)});
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

Util::All::Plugin::Benchmark; -  Util::All plugin for Benchmark

=cut

=head1 EXPORT

NOTE THAT: almost all of functions' explantion is cited from original modules' document.

=head2 -benchmark

=head3 timeit(COUNT, CODE)

Arguments: COUNT is the number of times to run the loop, and CODE is
the code to run.  CODE may be either a code reference or a string to
be eval'd; either way it will be run in the caller's package.

Returns: a Benchmark object.


(This explanation is cited from L<Benchmark>)

=head3 timethis ( COUNT, CODE, [ TITLE, [ STYLE ]] )

Time COUNT iterations of CODE. CODE may be a string to eval or a
code reference; either way the CODE will run in the caller's package.
Results will be printed to STDOUT as TITLE followed by the times.
TITLE defaults to "timethis COUNT" if none is provided. STYLE
determines the format of the output, as described for timestr() below.

The COUNT can be zero or negative: this means the I<minimum number of
CPU seconds> to run.  A zero signifies the default of 3 seconds.  For
example to run at least for 10 seconds:

	timethis(-10, $code)

or to run two pieces of code tests for at least 3 seconds:

	timethese(0, { test1 => '...', test2 => '...'})

CPU seconds is, in UNIX terms, the user time plus the system time of
the process itself, as opposed to the real (wallclock) time and the
time spent by the child processes.  Less than 0.1 seconds is not
accepted (-0.01 as the count, for example, will cause a fatal runtime
exception).

Note that the CPU seconds is the B<minimum> time: CPU scheduling and
other operating system factors may complicate the attempt so that a
little bit more time is spent.  The benchmark output will, however,
also tell the number of C<$code> runs/second, which should be a more
interesting number than the actually spent seconds.

Returns a Benchmark object.


(This explanation is cited from L<Benchmark>)

=head3 timethese ( COUNT, CODEHASHREF, [ STYLE ] )

The CODEHASHREF is a reference to a hash containing names as keys
and either a string to eval or a code reference for each value.
For each (KEY, VALUE) pair in the CODEHASHREF, this routine will
call

	timethis(COUNT, VALUE, KEY, STYLE)

The routines are called in string comparison order of KEY.

The COUNT can be zero or negative, see timethis().

Returns a hash reference of Benchmark objects, keyed by name.


(This explanation is cited from L<Benchmark>)

=head3 timediff ( T1, T2 )

Returns the difference between two Benchmark times as a Benchmark
object suitable for passing to timestr().


(This explanation is cited from L<Benchmark>)

=head3 timestr ( TIMEDIFF, [ STYLE, [ FORMAT ] ] )

Returns a string that formats the times in the TIMEDIFF object in
the requested STYLE. TIMEDIFF is expected to be a Benchmark object
similar to that returned by timediff().

STYLE can be any of 'all', 'none', 'noc', 'nop' or 'auto'. 'all' shows
each of the 5 times available ('wallclock' time, user time, system time,
user time of children, and system time of children). 'noc' shows all
except the two children times. 'nop' shows only wallclock and the
two children times. 'auto' (the default) will act as 'all' unless
the children times are both zero, in which case it acts as 'noc'.
'none' prevents output.

FORMAT is the L<printf(3)>-style format specifier (without the
leading '%') to use to print the times. It defaults to '5.2f'.


(This explanation is cited from L<Benchmark>)

=head3 cmpthese ( COUNT, CODEHASHREF, [ STYLE ] )


(This explanation is cited from L<Benchmark>)

=head3 cmpthese ( RESULTSHASHREF, [ STYLE ] )

Optionally calls timethese(), then outputs comparison chart.  This:

    cmpthese( -1, { a => "++\$i", b => "\$i *= 2" } ) ;

outputs a chart like:

           Rate    b    a
    b 2831802/s   -- -61%
    a 7208959/s 155%   --

This chart is sorted from slowest to fastest, and shows the percent speed
difference between each pair of tests.

c<cmpthese> can also be passed the data structure that timethese() returns:

    $results = timethese( -1, { a => "++\$i", b => "\$i *= 2" } ) ;
    cmpthese( $results );

in case you want to see both sets of results.
If the first argument is an unblessed hash reference,
that is RESULTSHASHREF; otherwise that is COUNT.

Returns a reference to an ARRAY of rows, each row is an ARRAY of cells from the
above chart, including labels. This:

    my $rows = cmpthese( -1, { a => '++$i', b => '$i *= 2' }, "none" );

returns a data structure like:

    [
        [ '',       'Rate',   'b',    'a' ],
        [ 'b', '2885232/s',  '--', '-59%' ],
        [ 'a', '7099126/s', '146%',  '--' ],
    ]

B<NOTE>: This result value differs from previous versions, which returned
the C<timethese()> result structure.  If you want that, just use the two
statement C<timethese>...C<cmpthese> idiom shown above.

Incidently, note the variance in the result values between the two examples;
this is typical of benchmarking.  If this were a real benchmark, you would
probably want to run a lot more iterations.


(This explanation is cited from L<Benchmark>)

=head3 countit(TIME, CODE)

Arguments: TIME is the minimum length of time to run CODE for, and CODE is
the code to run.  CODE may be either a code reference or a string to
be eval'd; either way it will be run in the caller's package.

TIME is I<not> negative.  countit() will run the loop many times to
calculate the speed of CODE before running it for TIME.  The actual
time run for will usually be greater than TIME due to system clock
resolution, so it's best to look at the number of iterations divided
by the times that you are concerned with, not just the iterations.

Returns: a Benchmark object.


(This explanation is cited from L<Benchmark>)

=head3 timesum ( T1, T2 )

Returns the sum of two Benchmark times as a Benchmark object suitable
for passing to timestr().


(This explanation is cited from L<Benchmark>)

=head3 timesamearg

    timesamearg($count, {name => \&code, name2 => \&code}, \%samearg)

like timethese but compare 2 code with same argument.
if $count can be negative or 0, it means the number of CPU seconds(0 is regarded as 3).


=head3 cmpsamearg

    cmpsamearg($count, {name => \&code, name2 => \&code}, \%samearg)

like cmpthese but compare 2 code with same argument.
if $count can be negative or 0, it means the number of CPU seconds(0 is regarded as 3).




=head1 AUTHOR

Ktat, C<< <ktat at cpan.org> >>

=head1 REPOSITORY

Util::All is hosted at github.

L<http://github.com/ktat/Util-All>

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

 perldoc Util::All::Benchmark

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