package Util::All::Plugin::List;

use warnings;
use strict;

sub utils {
  {
  '-list' => [
    [
      'List::Util',
      '',
      {
        '-select' => [
          'first',
          'max',
          'maxstr',
          'min',
          'minstr',
          'reduce',
          'shuffle',
          'sum'
        ]
      }
    ],
    [
      'List::Pairwise',
      '',
      {
        '-select' => [
          'mapp',
          'grepp',
          'firstp',
          'lastp',
          'pair'
        ]
      }
    ],
    [
      'List::MoreUtils',
      '',
      {
        '-select' => [
          'after',
          'after_incl',
          'all',
          'any',
          'apply',
          'before',
          'before_incl',
          'each_array',
          'each_arrayref',
          'false',
          'first_index',
          'first_value',
          'firstidx',
          'firstval',
          'indexes',
          'insert_after',
          'insert_after_string',
          'last_index',
          'last_value',
          'lastidx',
          'lastval',
          'mesh',
          'minmax',
          'natatime',
          'none',
          'notall',
          'pairwise',
          'part',
          'true',
          'uniq',
          'zip'
        ]
      }
    ]
  ]
}
;
}

=head1 NAME

Util::All::Plugin::List; -  Util::All plugin for List

=cut

=head1 EXPORT

NOTE THAT: almost all of functions' explantion is cited from original modules' document.

=head2 -list

=head3 functions of L<List::Util>

=head4 first BLOCK LIST

Similar to C<grep> in that it evaluates BLOCK setting C<$_> to each element
of LIST in turn. C<first> returns the first element where the result from
BLOCK is a true value. If BLOCK never returns true or LIST was empty then
C<undef> is returned.

    $foo = first { defined($_) } @list    # first defined value in @list
    $foo = first { $_ > $value } @list    # first value in @list which
                                          # is greater than $value

This function could be implemented using C<reduce> like this

    $foo = reduce { defined($a) ? $a : wanted($b) ? $b : undef } undef, @list

for example wanted() could be defined() which would return the first
defined value in @list


=head4 max LIST

Returns the entry in the list with the highest numerical value. If the
list is empty then C<undef> is returned.

    $foo = max 1..10                # 10
    $foo = max 3,9,12               # 12
    $foo = max @bar, @baz           # whatever

This function could be implemented using C<reduce> like this

    $foo = reduce { $a > $b ? $a : $b } 1..10


=head4 maxstr LIST

Similar to C<max>, but treats all the entries in the list as strings
and returns the highest string as defined by the C<gt> operator.
If the list is empty then C<undef> is returned.

    $foo = maxstr 'A'..'Z'          # 'Z'
    $foo = maxstr "hello","world"   # "world"
    $foo = maxstr @bar, @baz        # whatever

This function could be implemented using C<reduce> like this

    $foo = reduce { $a gt $b ? $a : $b } 'A'..'Z'


=head4 min LIST

Similar to C<max> but returns the entry in the list with the lowest
numerical value. If the list is empty then C<undef> is returned.

    $foo = min 1..10                # 1
    $foo = min 3,9,12               # 3
    $foo = min @bar, @baz           # whatever

This function could be implemented using C<reduce> like this

    $foo = reduce { $a < $b ? $a : $b } 1..10


=head4 minstr LIST

Similar to C<min>, but treats all the entries in the list as strings
and returns the lowest string as defined by the C<lt> operator.
If the list is empty then C<undef> is returned.

    $foo = minstr 'A'..'Z'          # 'A'
    $foo = minstr "hello","world"   # "hello"
    $foo = minstr @bar, @baz        # whatever

This function could be implemented using C<reduce> like this

    $foo = reduce { $a lt $b ? $a : $b } 'A'..'Z'


=head4 reduce BLOCK LIST

Reduces LIST by calling BLOCK, in a scalar context, multiple times,
setting C<$a> and C<$b> each time. The first call will be with C<$a>
and C<$b> set to the first two elements of the list, subsequent
calls will be done by setting C<$a> to the result of the previous
call and C<$b> to the next element in the list.

Returns the result of the last call to BLOCK. If LIST is empty then
C<undef> is returned. If LIST only contains one element then that
element is returned and BLOCK is not executed.

    $foo = reduce { $a < $b ? $a : $b } 1..10       # min
    $foo = reduce { $a lt $b ? $a : $b } 'aa'..'zz' # minstr
    $foo = reduce { $a + $b } 1 .. 10               # sum
    $foo = reduce { $a . $b } @bar                  # concat


=head4 shuffle LIST

Returns the elements of LIST in a random order

    @cards = shuffle 0..51      # 0..51 in a random order


=head4 sum LIST

Returns the sum of all the elements in LIST. If LIST is empty then
C<undef> is returned.

    $foo = sum 1..10                # 55
    $foo = sum 3,9,12               # 24
    $foo = sum @bar, @baz           # whatever

This function could be implemented using C<reduce> like this

    $foo = reduce { $a + $b } 1..10


=head3 functions of L<List::MoreUtils>

=head4 any BLOCK LIST

Returns a true value if any item in LIST meets the criterion given through
BLOCK. Sets C<$_> for each item in LIST in turn:

    print "At least one value undefined"
        if any { !defined($_) } @list;

Returns false otherwise, or C<undef> if LIST is empty.


=head4 all BLOCK LIST

Returns a true value if all items in LIST meet the criterion given through
BLOCK. Sets C<$_> for each item in LIST in turn:

    print "All items defined"
        if all { defined($_) } @list;

Returns false otherwise, or C<undef> if LIST is empty.


=head4 none BLOCK LIST

Logically the negation of C<any>. Returns a true value if no item in LIST meets the
criterion given through BLOCK. Sets C<$_> for each item in LIST in turn:

    print "No value defined"
        if none { defined($_) } @list;

Returns false otherwise, or C<undef> if LIST is empty.


=head4 notall BLOCK LIST

Logically the negation of C<all>. Returns a true value if not all items in LIST meet
the criterion given through BLOCK. Sets C<$_> for each item in LIST in turn:

    print "Not all values defined"
        if notall { defined($_) } @list;

Returns false otherwise, or C<undef> if LIST is empty.


=head4 true BLOCK LIST

Counts the number of elements in LIST for which the criterion in BLOCK is true. Sets C<$_> for 
each item in LIST in turn:

    printf "%i item(s) are defined", true { defined($_) } @list;


=head4 false BLOCK LIST

Counts the number of elements in LIST for which the criterion in BLOCK is false. Sets C<$_> for
each item in LIST in turn:

    printf "%i item(s) are not defined", false { defined($_) } @list;


=head4 firstidx BLOCK LIST


=head4 first_index BLOCK LIST

Returns the index of the first element in LIST for which the criterion in BLOCK is true. Sets C<$_>
for each item in LIST in turn:

    my @list = (1, 4, 3, 2, 4, 6);
    printf "item with index %i in list is 4", firstidx { $_ == 4 } @list;
    __END__
    item with index 1 in list is 4
    
Returns C<-1> if no such item could be found.

C<first_index> is an alias for C<firstidx>.


=head4 lastidx BLOCK LIST


=head4 last_index BLOCK LIST

Returns the index of the last element in LIST for which the criterion in BLOCK is true. Sets C<$_>
for each item in LIST in turn:

    my @list = (1, 4, 3, 2, 4, 6);
    printf "item with index %i in list is 4", lastidx { $_ == 4 } @list;
    __END__
    item with index 4 in list is 4

Returns C<-1> if no such item could be found.

C<last_index> is an alias for C<lastidx>.


=head4 insert_after BLOCK VALUE LIST

Inserts VALUE after the first item in LIST for which the criterion in BLOCK is true. Sets C<$_> for
each item in LIST in turn.

    my @list = qw/This is a list/;
    insert_after { $_ eq "a" } "longer" => @list;
    print "@list";
    __END__
    This is a longer list


=head4 insert_after_string STRING VALUE LIST

Inserts VALUE after the first item in LIST which is equal to STRING. 

    my @list = qw/This is a list/;
    insert_after_string "a", "longer" => @list;
    print "@list";
    __END__
    This is a longer list


=head4 apply BLOCK LIST

Applies BLOCK to each item in LIST and returns a list of the values after BLOCK
has been applied. In scalar context, the last element is returned.  This
function is similar to C<map> but will not modify the elements of the input
list:

    my @list = (1 .. 4);
    my @mult = apply { $_ *= 2 } @list;
    print "\@list = @list\n";
    print "\@mult = @mult\n";
    __END__
    @list = 1 2 3 4
    @mult = 2 4 6 8

Think of it as syntactic sugar for

    for (my @mult = @list) { $_ *= 2 }


=head4 after BLOCK LIST

Returns a list of the values of LIST after (and not including) the point
where BLOCK returns a true value. Sets C<$_> for each element in LIST in turn.

    @x = after { $_ % 5 == 0 } (1..9);    # returns 6, 7, 8, 9


=head4 after_incl BLOCK LIST

Same as C<after> but also inclues the element for which BLOCK is true.


=head4 before BLOCK LIST

Returns a list of values of LIST upto (and not including) the point where BLOCK
returns a true value. Sets C<$_> for each element in LIST in turn.


=head4 before_incl BLOCK LIST

Same as C<before> but also includes the element for which BLOCK is true.


=head4 indexes BLOCK LIST

Evaluates BLOCK for each element in LIST (assigned to C<$_>) and returns a list
of the indices of those elements for which BLOCK returned a true value. This is
just like C<grep> only that it returns indices instead of values:

    @x = indexes { $_ % 2 == 0 } (1..10);   # returns 1, 3, 5, 7, 9


=head4 firstval BLOCK LIST


=head4 first_value BLOCK LIST

Returns the first element in LIST for which BLOCK evaluates to true. Each
element of LIST is set to C<$_> in turn. Returns C<undef> if no such element
has been found.

C<first_val> is an alias for C<firstval>.


=head4 lastval BLOCK LIST


=head4 last_value BLOCK LIST

Returns the last value in LIST for which BLOCK evaluates to true. Each element
of LIST is set to C<$_> in turn. Returns C<undef> if no such element has been
found.

C<last_val> is an alias for C<lastval>.


=head4 pairwise BLOCK ARRAY1 ARRAY2

Evaluates BLOCK for each pair of elements in ARRAY1 and ARRAY2 and returns a
new list consisting of BLOCK's return values. The two elements are set to C<$a>
and C<$b>.  Note that those two are aliases to the original value so changing
them will modify the input arrays.

    @a = (1 .. 5);
    @b = (11 .. 15);
    @x = pairwise { $a + $b } @a, @b;	# returns 12, 14, 16, 18, 20

    # mesh with pairwise
    @a = qw/a b c/;
    @b = qw/1 2 3/;
    @x = pairwise { ($a, $b) } @a, @b;	# returns a, 1, b, 2, c, 3


=head4 each_array ARRAY1 ARRAY2 ...

Creates an array iterator to return the elements of the list of arrays ARRAY1,
ARRAY2 throughout ARRAYn in turn.  That is, the first time it is called, it
returns the first element of each array.  The next time, it returns the second
elements.  And so on, until all elements are exhausted.

This is useful for looping over more than one array at once:

    my $ea = each_array(@a, @b, @c);
    while ( my ($a, $b, $c) = $ea->() )   { .... }

The iterator returns the empty list when it reached the end of all arrays.

If the iterator is passed an argument of 'C<index>', then it retuns
the index of the last fetched set of values, as a scalar.


=head4 each_arrayref LIST

Like each_array, but the arguments are references to arrays, not the
plain arrays.


=head4 natatime BLOCK LIST

Creates an array iterator, for looping over an array in chunks of
C<$n> items at a time.  (n at a time, get it?).  An example is
probably a better explanation than I could give in words.

Example:

    my @x = ('a' .. 'g');
    my $it = natatime 3, @x;
    while (my @vals = $it->())
    {
        print "@vals\n";
    }

This prints

    a b c
    d e f
    g


=head4 mesh ARRAY1 ARRAY2 [ ARRAY3 ... ]


=head4 zip ARRAY1 ARRAY2 [ ARRAY3 ... ]

Returns a list consisting of the first elements of each array, then
the second, then the third, etc, until all arrays are exhausted.

Examples:

    @x = qw/a b c d/;
    @y = qw/1 2 3 4/;
    @z = mesh @x, @y;	    # returns a, 1, b, 2, c, 3, d, 4

    @a = ('x');
    @b = ('1', '2');
    @c = qw/zip zap zot/;
    @d = mesh @a, @b, @c;   # x, 1, zip, undef, 2, zap, undef, undef, zot

C<zip> is an alias for C<mesh>.


=head4 uniq LIST

Returns a new list by stripping duplicate values in LIST. The order of
elements in the returned list is the same as in LIST. In scalar context,
returns the number of unique elements in LIST.

    my @x = uniq 1, 1, 2, 2, 3, 5, 3, 4; # returns 1 2 3 5 4
    my $x = uniq 1, 1, 2, 2, 3, 5, 3, 4; # returns 5


=head4 minmax LIST

Calculates the minimum and maximum of LIST and returns a two element list with
the first element being the minimum and the second the maximum. Returns the empty
list if LIST was empty.

The minmax algorithm differs from a naive iteration over the list where each element
is compared to two values being the so far calculated min and max value in that it
only requires 3n/2 - 2 comparisons. Thus it is the most efficient possible algorithm.

However, the Perl implementation of it has some overhead simply due to the fact
that there are more lines of Perl code involved. Therefore, LIST needs to be
fairly big in order for minmax to win over a naive implementation. This
limitation does not apply to the XS version.


=head4 part BLOCK LIST

Partitions LIST based on the return value of BLOCK which denotes into which partition
the current value is put.

Returns a list of the partitions thusly created. Each partition created is a
reference to an array.

    my $i = 0;
    my @part = part { $i++ % 2 } 1 .. 8;   # returns [1, 3, 5, 7], [2, 4, 6, 8]

You can have a sparse list of partitions as well where non-set partitions will
be undef:

    my @part = part { 2 } 1 .. 10;	    # returns undef, undef, [ 1 .. 10 ]

Be careful with negative values, though:

    my @part = part { -1 } 1 .. 10;
    __END__
    Modification of non-creatable array value attempted, subscript -1 ...

Negative values are only ok when they refer to a partition previously created:

    my @idx = (0, 1, -1);
    my $i = 0;
    my @part = part { $idx[$++ % 3] } 1 .. 8;	# [1, 4, 7], [2, 3, 5, 6, 8]


=head3 functions of L<List::Pairwise>

=head4 mapp BLOCK LIST


=head4 grepp BLOCK LIST


=head4 firstp BLOCK LIST


=head4 lastp BLOCK LIST


=head4  Johan Lodin for the C<pair> idea and implementation, as well as numerous other
contributions (see changelog)




=head1 AUTHOR

Ktat, C<< <ktat at cpan.org> >>

=head1 REPOSITORY

Util::All is hosted at github.

L<http://github.com/ktat/Util-All>

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

 perldoc Util::All::List

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