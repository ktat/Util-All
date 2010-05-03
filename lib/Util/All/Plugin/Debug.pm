package Util::All::Plugin::Debug;

use warnings;
use strict;

sub utils {
  {
  '-debug' => [
    [
      'Devel::Cycle',
      '',
      {
        '-select' => [
          'find_cycle'
        ]
      }
    ],
    [
      'Tie::Trace',
      '',
      {
        '-select' => [
          'watch'
        ]
      }
    ],
    [
      'Data::Dump',
      '',
      {
        'p' => sub {
            sub (@) {
                Data::Dump::dump(@_);
            }
            ;
        },
        '-select' => [
          'dump',
          'pp',
          'dd',
          'ddx'
        ],
        'deep_dump' => sub {
            require Data::Dumper;
            sub (@) {
                local $Data::Dumper::Deparse = 1;
                local $Data::Dumper::Terse = 1;
                if (not defined wantarray) {
                    print STDERR Data::Dumper::Dumper(@_);
                }
                else {
                    return Data::Dumper::Dumper(@_);
                }
            }
            ;
        }
      }
    ],
    [
      'Data::Dumper',
      '',
      {
        'Dumper' => 'dumper',
        '-select' => [],
        'ex_dumper' => sub {
            sub {
                my $keys = pop @_;
                my %tmp;
                @tmp{@$keys} = ();
                local $Data::Dumper::Sortkeys = sub {
                    my($hash) = @_;
                    return [grep({not exists $tmp{$_};} keys %$hash)];
                }
                ;
                Data::Dumper::Dumper(@_);
            }
            ;
        },
        'deep_dumper' => sub {
            sub (@) {
                local $Data::Dumper::Deparse = 1;
                Data::Dumper::Dumper(@_);
            }
            ;
        }
      }
    ],
    [
      'Devel::Size',
      '',
      {
        '-select' => [
          'size',
          'total_size'
        ]
      }
    ]
  ]
}
;
}

=head1 NAME

Util::All::Plugin::Debug; -  Util::All plugin for Debug

=cut

=head1 EXPORT

NOTE THAT: almost all of functions' explantion is cited from original modules' document.

=head2 -debug

=head3 functions of L<Tie::Trace>

=head4 watch

 watch $variables;

 watch $scalar, %options;
 watch @array, %options;
 watch %hash, %options;

When you C<watch> variables and value is stored/delete in the variables,
warn the message like as the following.

 main:: %hash => {key} => value at ...

If the variables has values before C<watch>, it is no problem. Tie::Trace work well.

 my %hash = (key => 'value');
 watch %hash;


=head3 functions of L<Devel::Cycle>

=head4 find_cycle($object_reference,[$callback])

The find_cycle() function will traverse the object reference and print
a report to STDOUT identifying any memory cycles it finds.

If an optional callback code reference is provided, then this callback
will be invoked on each cycle that is found.  The callback will be
passed an array reference pointing to a list of lists with the
following format:

 $arg = [ ['REFTYPE',$index,$reference,$reference_value],
          ['REFTYPE',$index,$reference,$reference_value],
          ['REFTYPE',$index,$reference,$reference_value],
           ...
        ]

Each element in the array reference describes one edge in the memory
cycle.  'REFTYPE' describes the type of the reference and is one of
'SCALAR','ARRAY' or 'HASH'.  $index is the index affected by the
reference, and is undef for a scalar, an integer for an array
reference, or a hash key for a hash.  $reference is the memory
reference, and $reference_value is its dereferenced value.  For
example, if the edge is an ARRAY, then the following relationship
holds:

   $reference->[$index] eq $reference_value

The first element of the array reference is the $object_reference that
you pased to find_cycle() and may not be directly involved in the
cycle.

If a reference is a weak ref produced using Scalar::Util's weaken()
function then it won't contribute to cycles.


=head3 functions of L<Data::Dump>

=head4 dump( ... )


=head4 pp( ... )

Returns a string containing a Perl expression.  If you pass this
string to Perl's built-in eval() function it should return a copy of
the arguments you passed to dump().

If you call the function with multiple arguments then the output will
be wrapped in parenthesis "( ..., ... )".  If you call the function with a
single argument the output will not have the wrapping.  If you call the function with
a single scalar (non-reference) argument it will just return the
scalar quoted if needed, but never break it into multiple lines.  If you
pass multiple arguments or references to arrays of hashes then the
return value might contain line breaks to format it for easier
reading.  The returned string will never be "\n" terminated, even if
contains multiple lines.  This allows code like this to place the
semicolon in the expected place:

   print '$obj = ', dump($obj), ";\n";

If dump() is called in void context, then the dump is printed on
STDERR and then "\n" terminated.  You might find this useful for quick
debug printouts, but the dd*() functions might be better alternatives
for this.

There is no difference between dump() and pp(), except that dump()
shares its name with a not-so-useful perl builtin.  Because of this
some might want to avoid using that name.


=head4 dd( ... )


=head4 ddx( ... )

These functions will call dump() on their argument and print the
result to STDOUT (actually, it's the currently selected output handle, but
STDOUT is the default for that).

The difference between them is only that ddx() will prefix the lines
it prints with "# " and mark the first line with the file and line
number where it was called.  This is meant to be useful for debug
printouts of state within programs.


=head3 functions of L<Devel::Size>

=head4 size($ref)

The C<size> function returns the amount of memory the variable
returns.  If the variable is a hash or an array, it only reports
the amount used by the structure, I<not> the contents.


=head4 total_size($ref)

The C<total_size> function will traverse the variable and look
at the sizes of contents.  Any references contained in the variable
will also be followed, so this function can be used to get the
total size of a multidimensional data structure.  At the moment
there is no way to get the size of an array or a hash and its
elements without using this function.


=head3 dump

    print dump(@vars);
    dump(@vars);

dump of L<Data::Dump>. 
dump structure. In later case, result is dumped to STDERR.


=head3 deep_dumper

    deep_dumper([1 , 2, sub { print "hello World" }])

dump code reference as string.

=head3 ex_dumper

    ex_dumper($data, \@keys);
    ex_dumper($data, ['__MOP__']);


dump $data except @keys of hash

=head3 dumper

(Dumper of L<Data::Dumper>)



Returns the stringified form of the values in the list, subject to the
configuration options below.  The values will be named C<$VAR>I<n> in the
output, where I<n> is a numeric suffix.  Will return a list of strings
in a list context.





=head3 ddx

    dd(@vars);

as same as dd but output to STDOUT with line number.

=head3 dd

    dd(@vars);

as same as dump but output to STDOUT.

=head3 pp

    pp("{ x => 1, y => 2, z => 3}");

dump after given string is evaled.

=head3 deep_dump

    deep_dump([1,2,3, sub { ... } ]);

as same as dump. but it dump code reference as string.

=head3 p

    p($variable)

as same as dump(function name is borrowed from Ruby).



=head1 AUTHOR

Ktat, C<< <ktat at cpan.org> >>

=head1 REPOSITORY

Util::All is hosted at github.

L<http://github.com/ktat/Util-All>

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

 perldoc Util::All::Debug

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