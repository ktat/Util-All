package Util::All::Plugin::Hash;

use warnings;
use strict;

sub utils {
  {
  '-hash' => [
    [
      'Tie::IxHash',
      '',
      {
        'indexed' => sub {
            sub (\%@) {
                my $hash = shift @_;
                tie %$hash, 'Tie::IxHash';
                (%$hash) = @_;
            }
            ;
        },
        '-select' => []
      }
    ],
    [
      'Hash::Util',
      '',
      {
        '-select' => [
          'hash_seed',
          'lock_hash',
          'lock_keys',
          'lock_value',
          'unlock_hash',
          'unlock_keys',
          'unlock_value'
        ]
      }
    ]
  ]
}
;
}

=head1 NAME

Util::All::Plugin::Hash; -  Util::All plugin for Hash

=cut

=head1 EXPORT

NOTE THAT: almost all of functions' explantion is cited from original modules' document.

=head2 -hash

=head3 indexed

    indexed my %hash = (a => 1, b => 2);

%hash is indexed.

=head3 B<lock_keys>


(This explanation is cited from L<Hash::Util>)

=head3 B<unlock_keys>

  lock_keys(%hash);
  lock_keys(%hash, @keys);

Restricts the given %hash's set of keys to @keys.  If @keys is not
given it restricts it to its current keyset.  No more keys can be
added. delete() and exists() will still work, but will not alter
the set of allowed keys. B<Note>: the current implementation prevents
the hash from being bless()ed while it is in a locked state. Any attempt
to do so will raise an exception. Of course you can still bless()
the hash before you call lock_keys() so this shouldn't be a problem.

  unlock_keys(%hash);

Removes the restriction on the %hash's keyset.

B<Note> that if any of the values of the hash have been locked they will not be unlocked
after this sub executes.

Both routines return a reference to the hash operated on.


(This explanation is cited from L<Hash::Util>)

=head3 B<lock_value>


(This explanation is cited from L<Hash::Util>)

=head3 B<unlock_value>

  lock_value  (%hash, $key);
  unlock_value(%hash, $key);

Locks and unlocks the value for an individual key of a hash.  The value of a
locked key cannot be changed.

Unless %hash has already been locked the key/value could be deleted
regardless of this setting.

Returns a reference to the %hash.


(This explanation is cited from L<Hash::Util>)

=head3 B<lock_hash>


(This explanation is cited from L<Hash::Util>)

=head3 B<unlock_hash>

    lock_hash(%hash);

lock_hash() locks an entire hash, making all keys and values read-only.
No value can be changed, no keys can be added or deleted.

    unlock_hash(%hash);

unlock_hash() does the opposite of lock_hash().  All keys and values
are made writable.  All values can be changed and keys can be added
and deleted.

Returns a reference to the %hash.


(This explanation is cited from L<Hash::Util>)

=head3 B<hash_seed>

    my $hash_seed = hash_seed();

hash_seed() returns the seed number used to randomise hash ordering.
Zero means the "traditional" random hash ordering, non-zero means the
new even more random hash ordering introduced in Perl 5.8.1.

B<Note that the hash seed is sensitive information>: by knowing it one
can craft a denial-of-service attack against Perl code, even remotely,
see L<perlsec/"Algorithmic Complexity Attacks"> for more information.
B<Do not disclose the hash seed> to people who don't need to know it.
See also L<perlrun/PERL_HASH_SEED_DEBUG>.


(This explanation is cited from L<Hash::Util>)



=head1 AUTHOR

Ktat, C<< <ktat at cpan.org> >>

=head1 REPOSITORY

Util::All is hosted at github.

L<http://github.com/ktat/Util-All>

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

 perldoc Util::All::Hash

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