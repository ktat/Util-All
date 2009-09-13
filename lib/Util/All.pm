package Util::All;

use warnings;
use strict;

use Util::Any -Base;

our $Utils = {
  # tied Tie::IxHash
  "-base64"    => [
                    [
                      "MIME::Base64",
                      "",
                      { decode_base64 => "base64_decode", encode_base64 => "base64_encode" },
                    ],
                  ],
  "-benchmark" => [["Benchmark"]],
  "-carp"      => [["Carp"]],
  "-cgi"       => [
                    [
                      "CGI",
                      "",
                      { escape => "cgi_escape", unescape => "cgi_unescape" },
                    ],
                  ],
  "-char_enc"  => [
                    [
                      "Encode",
                      "",
                      {
                        decode  => "char_decode",
                        encode  => "char_encode",
                        from_to => "char_convert",
                      },
                    ],
                  ],
  "-datetime"  => [["Date::Parse", "", { strptime => "time_parse" }]],
  "-debug"     => [
                    ["Data::Dump", "", { "-select" => ["dump"] }],
                    ["Data::Dumper", "", { "-select" => [{ Dumper => "dumper" }] }],
                  ],
  "-file"      => [
                    ["File::Copy", "", { copy => "file_copy", move => "file_move" }],
                    ["File::Find", "", { fild => "find_file" }],
                    ["File::Path"],
                    [
                      "File::Slurp",
                      "",
                      {
                        read_file => "file_read",
                        slurp => "file_slurp",
                        write_file => "file_write",
                      },
                    ],
                  ],
  "-hash"      => [["Hash::Util"]],
  "-http"      => [
                    [
                      "HTTP::Request::Common",
                      "",
                      {
                        DELETE => "http_delete",
                        GET    => "http_get",
                        HEAD   => "http_head",
                        POST   => "http_post",
                        PUT    => "http_put",
                      },
                    ],
                  ],
  "-json"      => [
                    [
                      "JSON::Syck",
                      "",
                      {
                        Dump => "json_dump",
                        DumpJSON => "json_dump_file",
                        Load => "json_load",
                        LoadJSON => "json_load_file",
                      },
                    ],
                  ],
  "-list"      => [["List::MoreUtils"], ["List::Util"]],
  "-mail"      => [["Mail::Sendmail", "", { "-select" => ["mail_send"] }]],
  "-md5"       => [["Digest::MD5"]],
  "-scalar"    => [["Scalar::Util"]],
  "-sha"       => [["Digest::SHA"]],
  "-string"    => [["String::CamelCase"], ["String::Util"]],
  "-uri"       => [
                    [
                      "URI::Escape",
                      "",
                      { "-select" => ["uri_escape", "uri_unescape"] },
                    ],
                    ["URI::Split", "", { "-select" => ["uri_splict", "uri_join"] }],
                  ],
  "-utf8"      => [
                    [
                      "utf8",
                      "",
                      {
                        downgrade => "utf8_downgrade",
                        encode    => "utf8_encode",
                        is_utf8   => "is_utf8",
                        upgrade   => "utf8_upgrade",
                      },
                    ],
                  ],
  "-yaml"      => [
                    [
                      "YAML::Syck",
                      "",
                      {
                        Dump => "yaml_dump",
                        DumpFile => "yaml_dump_file",
                        Load => "yaml_load",
                        LoadFile => "yaml_load_file",
                      },
                    ],
                  ],
};

=head1 NAME

Util::All - collect perl utilities and group them to appropliate kind.

=cut

our $VERSION = '0.01';

=head1 SYNOPSIS

When you want list utilities.

 use Util::All -list;
 my @uniq = uniq @list;

When you want string utilities.

 use Util::All -string;
 camelize('abc_def'); # AbcDef

When you want encode Utilities.

 use Util::All -char_enc;
 char_encode('utf8', $str);
 char_decode('utf8', $str);

When you want CGI utilities.

 use Util::All -cgi;
 cgi_escape("/%"); # %2F%25
 cgi_unescape("%2F%25") # /%

When you want MD5 utilities

 use Util::All -md5;

 md5_base64($str);

When you want all utilities

 use Util::All 'all';

etc.

=head1 DESCRIPTION

Perl has many modules on CPAN and many modules provide utility functions.
Their utility functions are useful themself.
But there are two problem to use these utility functions.

First, CPAN has too much modules to lookup useful utility functions.
Newbie or even intermediate level programmers don't know such functions very much.
Honestly speaking, I don't know so much utility functions, too.

Second, utlitiy functions are written by many authors.
So, its naming rule/grouping rule is defined by authors.

It's very regrettable for Perl.

Util::All aims to collect utility functions on CPAN and group them to appropriate kind
and rename them by common naming rule.

If you know good functions, pelase tell me.

=head1 EXPORT

Instead of writing document,
I'll show yaml file below.

Its first level keys are kinds of functions.
hashes of the kinds has three kind of structures.

First:

 Module::Name: *

All functions in @EXPORT, @EXPORT_OK of Module::Name can be imported.

Second:

 Module::Name:
  - function_a
  - function_b

function_a and function_b of module::Name can be imported.

Third:

 Module::Name:
  - function_a : func_a

function_a of Module::Name can be imported as func_a.

The following is all definition of Util::All.
This file is functions.yml in distribution.

   ---
   scalar:
     Scalar::Util: *
   
   list:
     List::Util: *
     List::MoreUtils: *
   
   hash:
     Hash::Util: *
   
   debug:
     Data::Dumper:
       - Dumper: dumper
     Data::Dump:
       - dump
   
   string:
     String::Util: *
     String::CamelCase: *
   
   md5:
     Digest::MD5: *
   
   sha:
     Digest::SHA: *
   
   utf8:
     utf8:
       is_utf8  : is_utf8
       upgrade  : utf8_upgrade
       downgrade: utf8_downgrade
       encode   : utf8_encode
   
   cgi:
     CGI:
       escape: cgi_escape
       unescape: cgi_unescape
   
   char_enc:
     Encode:
       encode : char_encode
       decode : char_decode
       from_to: char_convert
   
   uri:
     URI::Escape:
       - uri_escape
       - uri_unescape
     URI::Split:
       - uri_splict
       - uri_join
   
   base64:
     MIME::Base64:
       encode_base64: base64_encode
       decode_base64: base64_decode
   
   http:
     HTTP::Request::Common:
       GET:    http_get
       POST:   http_post
       PUT:    http_put
       DELETE: http_delete
       HEAD:   http_head
   
   mail:
     Mail::Sendmail:
       - mail_send
   
   carp:
     Carp: *
   
   yaml:
     YAML::Syck:
       LoadFile: yaml_load_file
       Load:     yaml_load
       DumpFile: yaml_dump_file
       Dump:     yaml_dump
   
   json:
     JSON::Syck:
       LoadJSON: json_load_file
       Load:     json_load	    
       DumpJSON: json_dump_file
       Dump:     json_dump	    
   
   datetime:
     Date::Parse:
       strptime: time_parse
   
   benchmark:
     Benchmark: *
   
   file:
     File::Find:
       fild : find_file
     File::Path: *
     File::Slurp:
       slurp     : file_slurp
       read_file : file_read
       write_file: file_write
     File::Copy:
       copy: file_copy
       move: file_move
   
   


=head1 ALL MODULE(S) IS/ARE LOADED WHEN USING Util::All?

No. the related module(s) of your selected kind(s) is/are loaded.

=head1 CREATE YOUR OWN Util::All

If you want to put more functions in Util::All,
download distribution file and extract it and modify functions.yml and util-all.template(if needed).
And then do the following.

 perl create_util_all.pl
 perl Makefile.PL
 make
 make test
 make install

To do this, the following modules are required.

 YAML::Syck
 Data::Dump
 File::Slurp
 Tie::IxHash

If you think more functions should be in Util::All, please tell me them.

=head1 AUTHOR

Ktat, C<< <ktat at cpan.org> >>

=head1 REPOSITORY

Util::All is hosted at github.

L<http://github.com/ktat/Util-All>

=head1 BUGS

Please report any bugs or feature requests to C<bug-util-all at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Util-All>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Util::All


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Util-All>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Util-All>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Util-All>

=item * Search CPAN

L<http://search.cpan.org/dist/Util-All/>

=back

=head1 ACKNOWLEDGEMENTS

=head1 SEE ALSO

=over 4

=item L<Util::Any>

This module is based on Util::Any.
Util::Any helps you to create your own utilitiy module.

=back

=head1 COPYRIGHT & LICENSE

Copyright 2009 Ktat, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut

"All utility function are blong to Util::All"; # End of Util::All
