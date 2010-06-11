package Util::All::Plugin::File;

use warnings;
use strict;

sub utils {
  {
  '-file' => [
    [
      'File::Copy',
      '',
      {
        'copy' => 'copy_file',
        'move' => 'move_file',
        '-select' => []
      }
    ],
    [
      'File::Find',
      '',
      {
        '-select' => [],
        'find' => 'find_file'
      }
    ],
    [
      'File::Temp',
      '',
      {
        '-select' => [],
        'tempfile' => sub {
            my($pkg, $class, $func, $args, $kind_args) = @_;
            sub {
                my(@args) = @_;
                my(%args) = (%$kind_args, %$args, @args % 2 ? ('TEMPLATE', @args) : @args);
                my(%new_args) = map({uc $_, $args{$_};} keys %args);
                if (exists $new_args{'TEMPLATE'}) {
                    if ($new_args{'TEMPLATE'} =~ s/(X{4}X*)(.+)?$/$1/ or $new_args{'TEMPLATE'} =~ s/(\*)(.+)?$/XXXX/) {
                        $new_args{'SUFFIX'} ||= $2;
                    }
                    if (not $new_args{'TEMPLATE'} =~ /XXXX$/) {
                        $new_args{'TEMPLATE'} .= 'XXXX';
                    }
                }
                'File::Temp'->new(%new_args);
            }
            ;
        }
      }
    ],
    [
      'File::Path',
      '',
      {
        '-select' => [
          'make_path',
          'remove_tree'
        ]
      }
    ],
    [
      'Path::Class',
      '',
      {
        '-select' => [
          'file',
          'dir'
        ]
      }
    ],
    [
      'File::Slurp',
      '',
      {
        'slurp' => 'slurp_file',
        '-select' => [
          'read_file',
          'write_file'
        ]
      }
    ]
  ]
}
;
}

=head1 NAME

Util::All::Plugin::File; -  Util::All plugin for File

=cut

=head1 EXPORT

NOTE THAT: almost all of functions' explantion is cited from original modules' document.

=head2 -file

=head3 file

A synonym for C<< Path::Class::File->new >>.


(This explanation is cited from L<Path::Class>)

=head3 dir

A synonym for C<< Path::Class::Dir->new >>.


(This explanation is cited from L<Path::Class>)

=head3 make_path( $dir1, $dir2, .... )


(This explanation is cited from L<File::Path>)

=head3 make_path( $dir1, $dir2, ...., \%opts )

The C<make_path> function creates the given directories if they don't
exists before, much like the Unix command C<mkdir -p>.

The function accepts a list of directories to be created. Its
behaviour may be tuned by an optional hashref appearing as the last
parameter on the call.

The function returns the list of directories actually created during
the call; in scalar context the number of directories created.

The following keys are recognised in the option hash:

=over

=item mode => $num

The numeric permissions mode to apply to each created directory
(defaults to 0777), to be modified by the current C<umask>. If the
directory already exists (and thus does not need to be created),
the permissions will not be modified.

C<mask> is recognised as an alias for this parameter.

=item verbose => $bool

If present, will cause C<make_path> to print the name of each directory
as it is created. By default nothing is printed.

=item error => \$err

If present, it should be a reference to a scalar.
This scalar will be made to reference an array, which will
be used to store any errors that are encountered.  See the L<File::Path/"ERROR
HANDLING"> section for more information.

If this parameter is not used, certain error conditions may raise
a fatal error that will cause the program will halt, unless trapped
in an C<eval> block.

=back


(This explanation is cited from L<File::Path>)

=head3 remove_tree( $dir1, $dir2, .... )


(This explanation is cited from L<File::Path>)

=head3 remove_tree( $dir1, $dir2, ...., \%opts )

The C<remove_tree> function deletes the given directories and any
files and subdirectories they might contain, much like the Unix
command C<rm -r> or C<del /s> on Windows.

The function accepts a list of directories to be
removed. Its behaviour may be tuned by an optional hashref
appearing as the last parameter on the call.

The functions returns the number of files successfully deleted.

The following keys are recognised in the option hash:

=over

=item verbose => $bool

If present, will cause C<remove_tree> to print the name of each file as
it is unlinked. By default nothing is printed.

=item safe => $bool

When set to a true value, will cause C<remove_tree> to skip the files
for which the process lacks the required privileges needed to delete
files, such as delete privileges on VMS. In other words, the code
will make no attempt to alter file permissions. Thus, if the process
is interrupted, no filesystem object will be left in a more
permissive mode.

=item keep_root => $bool

When set to a true value, will cause all files and subdirectories
to be removed, except the initially specified directories. This comes
in handy when cleaning out an application's scratch directory.

  remove_tree( '/tmp', {keep_root => 1} );

=item result => \$res

If present, it should be a reference to a scalar.
This scalar will be made to reference an array, which will
be used to store all files and directories unlinked
during the call. If nothing is unlinked, the array will be empty.

  remove_tree( '/tmp', {result => \my $list} );
  print "unlinked $_\n" for @$list;

This is a useful alternative to the C<verbose> key.

=item error => \$err

If present, it should be a reference to a scalar.
This scalar will be made to reference an array, which will
be used to store any errors that are encountered.  See the L<File::Path/"ERROR
HANDLING"> section for more information.

Removing things is a much more dangerous proposition than
creating things. As such, there are certain conditions that
C<remove_tree> may encounter that are so dangerous that the only
sane action left is to kill the program.

Use C<error> to trap all that is reasonable (problems with
permissions and the like), and let it die if things get out
of hand. This is the safest course of action.

=back


(This explanation is cited from L<File::Path>)

=head3 B<read_file>

This sub reads in an entire file and returns its contents to the
caller. In list context it will return a list of lines (using the
current value of $/ as the separator including support for paragraph
mode when it is set to ''). In scalar context it returns the entire
file as a single scalar.

  my $text = read_file( 'filename' ) ;
  my @lines = read_file( 'filename' ) ;

The first argument to C<read_file> is the filename and the rest of the
arguments are key/value pairs which are optional and which modify the
behavior of the call. Other than binmode the options all control how
the slurped file is returned to the caller.

If the first argument is a file handle reference or I/O object (if ref
is true), then that handle is slurped in. This mode is supported so
you slurp handles such as C<DATA>, C<STDIN>. See the test handle.t
for an example that does C<open( '-|' )> and child process spews data
to the parant which slurps it in.  All of the options that control how
the data is returned to the caller still work in this case.

NOTE: as of version 9999.06, read_file works correctly on the C<DATA>
handle. It used to need a sysseek workaround but that is now handled
when needed by the module itself.

You can optionally request that C<slurp()> is exported to your code. This
is an alias for read_file and is meant to be forward compatible with
Perl 6 (which will have slurp() built-in).

The options are:



=over 8

=item binmode

If you set the binmode option, then the file will be slurped in binary
mode.

	my $bin_data = read_file( $bin_file, binmode => ':raw' ) ;

NOTE: this actually sets the O_BINARY mode flag for sysopen. It
probably should call binmode and pass its argument to support other
file modes.

=item array_ref

If this boolean option is set, the return value (only in scalar
context) will be an array reference which contains the lines of the
slurped file. The following two calls are equivalent:

	my $lines_ref = read_file( $bin_file, array_ref => 1 ) ;
	my $lines_ref = [ read_file( $bin_file ) ] ;

=item scalar_ref

If this boolean option is set, the return value (only in scalar
context) will be an scalar reference to a string which is the contents
of the slurped file. This will usually be faster than returning the
plain scalar.

	my $text_ref = read_file( $bin_file, scalar_ref => 1 ) ;

=item buf_ref

You can use this option to pass in a scalar reference and the slurped
file contents will be stored in the scalar. This can be used in
conjunction with any of the other options.

	my $text_ref = read_file( $bin_file, buf_ref => \$buffer,
					     array_ref => 1 ) ;
	my @lines = read_file( $bin_file, buf_ref => \$buffer ) ;

=item blk_size

You can use this option to set the block size used when slurping from an already open handle (like \*STDIN). It defaults to 1MB.

	my $text_ref = read_file( $bin_file, blk_size => 10_000_000,
					     array_ref => 1 ) ;

=item err_mode

You can use this option to control how read_file behaves when an error
occurs. This option defaults to 'croak'. You can set it to 'carp' or
to 'quiet to have no error handling. This code wants to carp and then
read abother file if it fails.

	my $text_ref = read_file( $file, err_mode => 'carp' ) ;
	unless ( $text_ref ) {

		# read a different file but croak if not found
		$text_ref = read_file( $another_file ) ;
	}
	
	# process ${$text_ref}


=back


(This explanation is cited from L<File::Slurp>)

=head3 B<write_file>

This sub writes out an entire file in one call.

  write_file( 'filename', @data ) ;

The first argument to C<write_file> is the filename. The next argument
is an optional hash reference and it contains key/values that can
modify the behavior of C<write_file>. The rest of the argument list is
the data to be written to the file.

  write_file( 'filename', {append => 1 }, @data ) ;
  write_file( 'filename', {binmode => ':raw' }, $buffer ) ;

As a shortcut if the first data argument is a scalar or array
reference, it is used as the only data to be written to the file. Any
following arguments in @_ are ignored. This is a faster way to pass in
the output to be written to the file and is equivilent to the
C<buf_ref> option. These following pairs are equivilent but the pass
by reference call will be faster in most cases (especially with larger
files).

  write_file( 'filename', \$buffer ) ;
  write_file( 'filename', $buffer ) ;

  write_file( 'filename', \@lines ) ;
  write_file( 'filename', @lines ) ;

If the first argument is a file handle reference or I/O object (if ref
is true), then that handle is slurped in. This mode is supported so
you spew to handles such as \*STDOUT. See the test handle.t for an
example that does C<open( '-|' )> and child process spews data to the
parant which slurps it in.  All of the options that control how the
data is passes into C<write_file> still work in this case.

C<write_file> returns 1 upon successfully writing the file or undef if
it encountered an error.

The options are:



=over 8

=item binmode

If you set the binmode option, then the file will be written in binary
mode.

	write_file( $bin_file, {binmode => ':raw'}, @data ) ;

NOTE: this actually sets the O_BINARY mode flag for sysopen. It
probably should call binmode and pass its argument to support other
file modes.

=item buf_ref

You can use this option to pass in a scalar reference which has the
data to be written. If this is set then any data arguments (including
the scalar reference shortcut) in @_ will be ignored. These are
equivilent:

	write_file( $bin_file, { buf_ref => \$buffer } ) ;
	write_file( $bin_file, \$buffer ) ;
	write_file( $bin_file, $buffer ) ;

=item atomic

If you set this boolean option, the file will be written to in an
atomic fashion. A temporary file name is created by appending the pid
($$) to the file name argument and that file is spewed to. After the
file is closed it is renamed to the original file name (and rename is
an atomic operation on most OS's). If the program using this were to
crash in the middle of this, then the file with the pid suffix could
be left behind.

=item append

If you set this boolean option, the data will be written at the end of
the current file.

	write_file( $file, {append => 1}, @data ) ;

C<write_file> croaks if it cannot open the file. It returns true if it
succeeded in writing out the file and undef if there was an
error. (Yes, I know if it croaks it can't return anything but that is
for when I add the options to select the error handling mode).

=item no_clobber

If you set this boolean option, an existing file will not be overwritten.

	write_file( $file, {no_clobber => 1}, @data ) ;

=item err_mode

You can use this option to control how C<write_file> behaves when an
error occurs. This option defaults to 'croak'. You can set it to
'carp' or to 'quiet' to have no error handling other than the return
value. If the first call to C<write_file> fails it will carp and then
write to another file. If the second call to C<write_file> fails, it
will croak.

	unless ( write_file( $file, { err_mode => 'carp', \$data ) ;

		# write a different file but croak if not found
		write_file( $other_file, \$data ) ;
	}


=back


(This explanation is cited from L<File::Slurp>)

=head3 find_file

(find of L<File::Find>)



  find(\&wanted,  @directories);
  find(\%options, @directories);

C<find()> does a depth-first search over the given C<@directories> in
the order they are given.  For each file or directory found, it calls
the C<&wanted> subroutine.  (See below for details on how to use the
C<&wanted> function).  Additionally, for each directory found, it will
C<chdir()> into that directory and continue the search, invoking the
C<&wanted> function on each file or subdirectory in the directory.

(This explanation is cited from L<File::Find>)



=head3 move_file

(move of L<File::Copy>)


X<move> X<mv> X<rename>

The C<move> function also takes two parameters: the current name
and the intended name of the file to be moved.  If the destination
already exists and is a directory, and the source is not a
directory, then the source file will be renamed into the directory
specified by the destination.

If possible, move() will simply rename the file.  Otherwise, it copies
the file to the new location and deletes the original.  If an error occurs
during this copy-and-delete process, you may be left with a (possibly partial)
copy of the file under the destination name.

You may use the "mv" alias for this function in the same way that
you may use the "cp" alias for C<copy>.


X<move> X<mv> X<rename>

The C<move> function also takes two parameters: the current name
and the intended name of the file to be moved.  If the destination
already exists and is a directory, and the source is not a
directory, then the source file will be renamed into the directory
specified by the destination.

If possible, move() will simply rename the file.  Otherwise, it copies
the file to the new location and deletes the original.  If an error occurs
during this copy-and-delete process, you may be left with a (possibly partial)
copy of the file under the destination name.

You may use the "mv" alias for this function in the same way that
you may use the "cp" alias for C<copy>.

(This explanation is cited from L<File::Copy>)



=head3 slurp_file

(slurp of L<File::Slurp>)

=head3 tempfile

    $tmpfile = tempfile("anyname*.dat");
    $tmpfile = tempfile("anynameXXXX.dat"); # as same as the above
    $tmpfile = tempfile("anyname*.dat", dir => '/var/tmp');
    $tmpfile = tempfile("anyname*", dir => '/var/tmp', suffix => '.dat', exlock => 0);
    $tmpfile = tempfile(template => "anyname*", dir => '/var/tmp', suffix => '.dat', exlock => 0);
    
    my $filename = $tmpfile->filename;
    print $tmpfile "Test";


create temporary file. on BSD derived systems, O_EXLOCK is used(see File::Temp manual).
If you don't want to lock temporary file, give exlock => 0 for arguments.


=head3 copy_file

(copy of L<File::Copy>)


X<copy> X<cp>

The C<copy> function takes two
parameters: a file to copy from and a file to copy to. Either
argument may be a string, a FileHandle reference or a FileHandle
glob. Obviously, if the first argument is a filehandle of some
sort, it will be read from, and if it is a file I<name> it will
be opened for reading. Likewise, the second argument will be
written to (and created if need be).  Trying to copy a file on top
of itself is a fatal error.

B<Note that passing in
files as handles instead of names may lead to loss of information
on some operating systems; it is recommended that you use file
names whenever possible.>  Files are opened in binary mode where
applicable.  To get a consistent behaviour when copying from a
filehandle to a file, use C<binmode> on the filehandle.

An optional third parameter can be used to specify the buffer
size used for copying. This is the number of bytes from the
first file, that will be held in memory at any given time, before
being written to the second file. The default buffer size depends
upon the file, but will generally be the whole file (up to 2MB), or
1k for filehandles that do not reference files (eg. sockets).

You may use the syntax C<use File::Copy "cp"> to get at the
"cp" alias for this function. The syntax is I<exactly> the same.


X<copy> X<cp>

The C<copy> function takes two
parameters: a file to copy from and a file to copy to. Either
argument may be a string, a FileHandle reference or a FileHandle
glob. Obviously, if the first argument is a filehandle of some
sort, it will be read from, and if it is a file I<name> it will
be opened for reading. Likewise, the second argument will be
written to (and created if need be).  Trying to copy a file on top
of itself is a fatal error.

B<Note that passing in
files as handles instead of names may lead to loss of information
on some operating systems; it is recommended that you use file
names whenever possible.>  Files are opened in binary mode where
applicable.  To get a consistent behaviour when copying from a
filehandle to a file, use C<binmode> on the filehandle.

An optional third parameter can be used to specify the buffer
size used for copying. This is the number of bytes from the
first file, that will be held in memory at any given time, before
being written to the second file. The default buffer size depends
upon the file, but will generally be the whole file (up to 2MB), or
1k for filehandles that do not reference files (eg. sockets).

You may use the syntax C<use File::Copy "cp"> to get at the
"cp" alias for this function. The syntax is I<exactly> the same.

(This explanation is cited from L<File::Copy>)





=head1 AUTHOR

Ktat, C<< <ktat at cpan.org> >>

=head1 REPOSITORY

Util::All is hosted at github.

L<http://github.com/ktat/Util-All>

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

 perldoc Util::All::File

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