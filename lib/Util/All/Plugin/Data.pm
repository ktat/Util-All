package Util::All::Plugin::Data;

use warnings;
use strict;

sub utils {
  {
  '-data' => [
    [
      'Scalar::Util',
      '',
      {
        'readonly' => 'is_readonly',
        'isweak' => 'is_weak',
        '-select' => [
          'dualvar',
          'looks_like_number',
          'openhandle',
          'refaddr',
          'reftype',
          'set_prototype',
          'weaken'
        ],
        'blessed' => 'is_blessed',
        'tainted' => 'is_tainted',
        'isvstring' => 'is_vstring'
      }
    ],
    [
      'Data::Structure::Util',
      '',
      {
        '-select' => [
          'has_utf8',
          'unbless'
        ]
      }
    ],
    [
      'Data::Util',
      '',
      {
        '-select' => [
          'is_scalar_ref',
          'is_array_ref',
          'is_hash_ref',
          'is_code_ref',
          'is_glob_ref',
          'is_rx',
          'is_instance',
          'is_invocant',
          'is_value',
          'is_string',
          'is_number',
          'is_integer'
        ]
      }
    ]
  ]
}
;
}

=head1 NAME

Util::All::Plugin::Data; -  Util::All plugin for Data

=cut

=head1 EXPORT

NOTE THAT: almost all of functions' explantion is cited from original modules' document.

=head2 -data

=head3 is_readonly

(readonly of L<Scalar::Util>)



Returns true if SCALAR is readonly.

    sub foo { readonly($_[0]) }

    $readonly = foo($bar);              # false
    $readonly = foo(0);                 # true

(This explanation is cited from L<Scalar::Util>)



=head3 dualvar NUM, STRING

Returns a scalar that has the value NUM in a numeric context and the
value STRING in a string context.

    $foo = dualvar 10, "Hello";
    $num = $foo + 2;                    # 12
    $str = $foo . " world";             # Hello world


(This explanation is cited from L<Scalar::Util>)

=head3 looks_like_number EXPR

Returns true if perl thinks EXPR is a number. See
L<perlapi/looks_like_number>.


(This explanation is cited from L<Scalar::Util>)

=head3 openhandle FH

Returns FH if FH may be used as a filehandle and is open, or FH is a tied
handle. Otherwise C<undef> is returned.

    $fh = openhandle(*STDIN);		# \*STDIN
    $fh = openhandle(\*STDIN);		# \*STDIN
    $fh = openhandle(*NOTOPEN);		# undef
    $fh = openhandle("scalar");		# undef
    

(This explanation is cited from L<Scalar::Util>)

=head3 refaddr EXPR

If EXPR evaluates to a reference the internal memory address of
the referenced value is returned. Otherwise C<undef> is returned.

    $addr = refaddr "string";           # undef
    $addr = refaddr \$var;              # eg 12345678
    $addr = refaddr [];                 # eg 23456784

    $obj  = bless {}, "Foo";
    $addr = refaddr $obj;               # eg 88123488


(This explanation is cited from L<Scalar::Util>)

=head3 reftype EXPR

If EXPR evaluates to a reference the type of the variable referenced
is returned. Otherwise C<undef> is returned.

    $type = reftype "string";           # undef
    $type = reftype \$var;              # SCALAR
    $type = reftype [];                 # ARRAY

    $obj  = bless {}, "Foo";
    $type = reftype $obj;               # HASH


(This explanation is cited from L<Scalar::Util>)

=head3 set_prototype CODEREF, PROTOTYPE

Sets the prototype of the given function, or deletes it if PROTOTYPE is
undef. Returns the CODEREF.

    set_prototype \&foo, '$$';


(This explanation is cited from L<Scalar::Util>)

=head3 weaken REF

REF will be turned into a weak reference. This means that it will not
hold a reference count on the object it references. Also when the reference
count on that object reaches zero, REF will be set to undef.

This is useful for keeping copies of references , but you don't want to
prevent the object being DESTROY-ed at its usual time.

    {
      my $var;
      $ref = \$var;
      weaken($ref);                     # Make $ref a weak reference
    }
    # $ref is now undef

Note that if you take a copy of a scalar with a weakened reference,
the copy will be a strong reference.

    my $var;
    my $foo = \$var;
    weaken($foo);                       # Make $foo a weak reference
    my $bar = $foo;                     # $bar is now a strong reference

This may be less obvious in other situations, such as C<grep()>, for instance
when grepping through a list of weakened references to objects that may have
been destroyed already:

    @object = grep { defined } @object;

This will indeed remove all references to destroyed objects, but the remaining
references to objects will be strong, causing the remaining objects to never
be destroyed because there is now always a strong reference to them in the
@object array.


(This explanation is cited from L<Scalar::Util>)

=head3 unbless($ref)

Remove the blessing from any objects found within the passed data
structure. For example:

    my $foo = {
        'a' => bless( { 'b' => bless( {}, "c" ), }, "d" ),
        'e' => [ bless( [], "f" ), bless( [], "g" ), ]
    };

    use Data::Dumper;
    use Data::Structure::Util qw(unbless);
    print Dumper( unbless( $foo ) );

    $VAR1 = {
        'a' => { 'b' => {} },
        'e' => [ [], [] ]
    };

Note that the structure looks inside blessed objects for other
objects to unbless.


(This explanation is cited from L<Data::Structure::Util>)

=head3 has_utf8($var)

Returns C<$var> if the utf8 flag is enabled for C<$var> or any scalar
that a data structure passed in C<$var> contains.

    print "this will be printed"  if defined has_utf8( "\x{1234}" );
    print "this won't be printed" if defined has_utf8( "foo bar" );

Note that you should not check the truth of the return value of this
function when calling it with a single scalar as it is possible to
have a string "0" or "" for which the utf8 flag set; Since C<undef>
can never have the utf8 flag set the function will never return a
defined value if the data structure does not contain a utf8 flagged
scalar.


(This explanation is cited from L<Data::Structure::Util>)

=head3 is_scalar_ref(value)

For a SCALAR reference.


(This explanation is cited from L<Data::Util>)

=head3 is_array_ref(value)

For an ARRAY reference.


(This explanation is cited from L<Data::Util>)

=head3 is_hash_ref(value)

For a HASH reference.


(This explanation is cited from L<Data::Util>)

=head3 is_code_ref(value)

For a CODE reference.


(This explanation is cited from L<Data::Util>)

=head3 is_glob_ref(value)

For a GLOB reference.


(This explanation is cited from L<Data::Util>)

=head3 is_rx(value)

For a regular expression reference generated by the C<qr//> operator.


(This explanation is cited from L<Data::Util>)

=head3 is_instance(value, class)

For an instance of I<class>.

It is equivalent to something like
C<< Scalar::Util::blessed($value) && $value->isa($class) >>.


(This explanation is cited from L<Data::Util>)

=head3 is_invocant(value)

For an invocant, i.e. a blessed reference or existent package name.

If I<value> is a valid class name but does not exist, it will return false.


(This explanation is cited from L<Data::Util>)

=head3 is_value(value)

Checks whether I<value> is a primitive value, i.e. a defined, non-ref, and
non-type-glob value.

This function has no counterpart for validation.


(This explanation is cited from L<Data::Util>)

=head3 is_string(value)

Checks whether I<value> is a string with non-zero-length contents,
equivalent to C<< is_value($value) && length($value) > 0 >>.

This function has no counterpart for validation.


(This explanation is cited from L<Data::Util>)

=head3 is_number(value)

Checks whether I<value> is a number.
Here, a B<number> means that the perl parser can understand it and that
the perl numeric converter (e.g. invoked by C<< sprintf '%g', $value >>)
doesn't complain about it.

It is similar to C<Scalar::Util::looks_like_number()>
but refuses C<infinity>, C<not a number> and C<"0 but true">.
Note that C<9**9**9> makes C<infinity> and C<9**9**9 - 9**9**9> makes
C<not a number>.

This function has no counterpart for validation.


(This explanation is cited from L<Data::Util>)

=head3 is_integer(value)

Checks whether I<value> is an integer.
An B<integer> is also a B<number>, so this function
refuses C<infinity> and C<not a number>. See also C<is_number()>.

This function has no counterpart for validation.


(This explanation is cited from L<Data::Util>)

=head3 is_weak

(isweak of L<Scalar::Util>)



If EXPR is a scalar which is a weak reference the result is true.

    $ref  = \$foo;
    $weak = isweak($ref);               # false
    weaken($ref);
    $weak = isweak($ref);               # true

B<NOTE>: Copying a weak reference creates a normal, strong, reference.

    $copy = $ref;
    $weak = isweak($copy);              # false

(This explanation is cited from L<Scalar::Util>)



=head3 is_vstring

(isvstring of L<Scalar::Util>)



If EXPR is a scalar which was coded as a vstring the result is true.

    $vs   = v49.46.48;
    $fmt  = isvstring($vs) ? "%vd" : "%s"; #true
    printf($fmt,$vs);

(This explanation is cited from L<Scalar::Util>)



=head3 is_tainted

(tainted of L<Scalar::Util>)



Return true if the result of EXPR is tainted

    $taint = tainted("constant");       # false
    $taint = tainted($ENV{PWD});        # true if running under -T

(This explanation is cited from L<Scalar::Util>)



=head3 is_blessed

(blessed of L<Scalar::Util>)



If EXPR evaluates to a blessed reference the name of the package
that it is blessed into is returned. Otherwise C<undef> is returned.

   $scalar = "foo";
   $class  = blessed $scalar;           # undef

   $ref    = [];
   $class  = blessed $ref;              # undef

   $obj    = bless [], "Foo";
   $class  = blessed $obj;              # "Foo"

(This explanation is cited from L<Scalar::Util>)





=head1 AUTHOR

Ktat, C<< <ktat at cpan.org> >>

=head1 REPOSITORY

Util::All is hosted at github.

L<http://github.com/ktat/Util-All>

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

 perldoc Util::All::Data

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