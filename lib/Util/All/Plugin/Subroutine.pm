package Util::All::Plugin::Subroutine;

use warnings;
use strict;

sub utils {
  {
  '-subroutine' => [
    [
      'Data::Util',
      '',
      {
        '-select' => [
          'install_subroutine',
          'uninstall_subroutine',
          'get_code_info',
          'get_code_ref',
          'curry',
          'modify_subroutine',
          'subroutine_modifier'
        ]
      }
    ]
  ]
}
;
}

=head1 NAME

Util::All::Plugin::Subroutine; -  Util::All plugin for Subroutine

=cut

=head1 EXPORT

NOTE THAT: almost all of functions' explantion is cited from original modules' document.

=head2 -subroutine

=head3 install_subroutine(package, name => subr [, ...])

Installs I<subr> into I<package> as I<name>.

It is similar to
C<< do{ no strict 'refs'; *{$package.'::'.$name} = \&subr; } >>.
In addition, if I<subr> is an anonymous subroutine, it is located into
I<package> as a named subroutine I<&package::name>.

For example:

	install_subroutine($pkg,   say => sub{ print @_, "\n" });
	install_subroutine($pkg,
		one => \&_one,
		two => \&_two,
	);

	# accepts a HASH reference
	install_subroutine($pkg, { say => sub{ print @_, "\n" }); # 

To re-install I<subr>, use C<< no warnings 'redefine' >> directive:

	no warnings 'redefine';
	install_subroutine($package, $name => $subr);


(This explanation is cited from L<Data::Util>)

=head3 uninstall_subroutine(package, names...)

Uninstalls I<names> from I<package>.

It is similar to C<Sub::Delete::delete_sub()>, but uninstall multiple
subroutines at a time.

If you want to specify deleted subroutines, you can supply 
C<< name => \&subr >> pairs.

For example:

	uninstall_subroutine('Foo', 'hello');

	uninstall_subroutine('Foo', hello => \&Bar::hello);

	uninstall_subroutine($pkg,
		one => \&_one,
		two => \&_two,
	);

	# accepts a HASH reference
	uninstall_subroutine(\$pkg, { hello => \&Bar::hello });


(This explanation is cited from L<Data::Util>)

=head3 get_code_info(subr)

Returns a pair of elements, the package name and the subroutine name of I<subr>.

It is similar to C<Sub::Identify::get_code_info()>, but it returns the fully
qualified name in scalar context.


(This explanation is cited from L<Data::Util>)

=head3 get_code_ref(package, name, flag?)

Returns I<&package::name> if it exists, not touching the symbol in the stash.

if I<flag> is a string C<-create>, it returns I<&package::name> regardless of
its existence. That is, it is equivalent to
C<< do{ no strict 'refs'; \&{package . '::' . $name} } >>.

For example:

	$code = get_code_ref($pkg, $name);          # like  *{$pkg.'::'.$name}{CODE}
	$code = get_code_ref($pkg, $name, -create); # like \&{$pkg.'::'.$name}


(This explanation is cited from L<Data::Util>)

=head3 curry(subr, args and/or placeholders)

Makes I<subr> curried and returns the curried subroutine.

This is also considered as lightweight closures.

See also L<Data::Util::Curry>.


(This explanation is cited from L<Data::Util>)

=head3 modify_subroutine(subr, ...)

Modifies I<subr> with subroutine modifiers and returns the modified subroutine.
This is also considered as lightweight closures.

I<subr> must be a code reference or callable object.

Optional arguments:
C<< before => [subroutine(s)] >> called before I<subr>.
C<< around => [subroutine(s)] >> called around I<subr>.
C<< after  => [subroutine(s)] >> called after  I<subr>.

This seems a constructor of modified subroutines and
C<subroutine_modifier()> is property accessors, but it does not bless the 
modified subroutines.


(This explanation is cited from L<Data::Util>)

=head3 subroutine_modifier(subr)

Returns whether I<subr> is a modified subroutine.


(This explanation is cited from L<Data::Util>)

=head3 subroutine_modifier(modified_subr, property)

Gets I<property> from I<modified>.

Valid properties are: C<before>, C<around>, C<after>.


(This explanation is cited from L<Data::Util>)

=head3 subroutine_modifier(modified_subr, modifier => [subroutine(s)])

Adds subroutine I<modifier> to I<modified_subr>.

Valid modifiers are: C<before>, C<around>, C<after>.


(This explanation is cited from L<Data::Util>)



=head1 AUTHOR

Ktat, C<< <ktat at cpan.org> >>

=head1 REPOSITORY

Util::All is hosted at github.

L<http://github.com/ktat/Util-All>

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

 perldoc Util::All::Subroutine

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