package Util::All;

use warnings;
use strict;

use Util::Any -Base;

our $Utils = {
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
                        from_to => "char_from_to",
                      },
                    ],
                  ],
  "-date"      => [["Date::Parse"]],
  "-debug"     => [
                    ["Data::Dump", "", { "-select" => ["dump"] }],
                    ["Data::Dumper", "", { "-select" => [{ Dumper => "dumper" }] }],
                  ],
  "-file"      => [
                    ["File::Copy", "", { copy => "copy_file", move => "move_file" }],
                    ["File::Find"],
                    ["File::Path"],
                    [
                      "File::Slurp",
                      "",
                      { "-select" => ["slurp_file", "read_file", "write_file"] },
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
                        Dump => "dump_json",
                        DumpJSON => "dump_json_file",
                        Load => "load_json",
                        LoadJSON => "load_json_file",
                      },
                    ],
                  ],
  "-list"      => [["List::Util"], ["List::MoreUtils"]],
  "-mail"      => [["Mail::Sendmail", "", { "-select" => ["sendmail"] }]],
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
                        Dump => "dump_yaml",
                        DumpFile => "dump_yaml_file",
                        Load => "load_yaml",
                        LoadFile => "load_yaml_file",
                      },
                    ],
                  ],
};

=head1 NAME

Util::All - collection of perl utilities

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

 use Util::All -encode;
 char_encode('utf8', $str);
 char_decode('utf8', $str);

When you want CGI utilities.

 use Util::All -cgi;
 cgiescape("/%"); # %2F%25
 cgiunescape("%2F%25") # /%

When you want md5 utilities

 use Util::All -md5;

 md5_base64($str);

When you want all utilities

 use Util::All 'all';

etc.

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
       is_utf8: is_utf8
       upgrade: utf8_upgrade
       downgrade: utf8_downgrade
       encode: utf8_encode
   
   cgi:
     CGI:
       escape: cgi_escape
       unescape: cgi_unescape
   
   char_enc:
     Encode:
       encode : char_encode
       decode : char_decode
       from_to: char_from_to
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
       - sendmail
   
   carp:
     Carp: *
   
   yaml:
     YAML::Syck:
       LoadFile: load_yaml_file
       Load:     load_yaml
       DumpFile: dump_yaml_file
       Dump:     dump_yaml
   
   json:
     JSON::Syck:
       LoadJSON: load_json_file
       Load:      load_json
       DumpJSON: dump_json_file
       Dump:     dump_json
   
   date:
     Date::Parse: *
   
   benchmark:
     Benchmark: *
   
   file:
     File::Slurp:
       - slurp_file
       - read_file
       - write_file
     File::Find: *
     File::Copy:
       copy: copy_file
       move: move_file
     File::Path: *
   


=head1 ALL MODULE(S) IS/ARE LOADED WHEN USING Util::All?

No. the related module(s) of your selected kind, is/are loaded.

=head1 CREATE YOUR OWN Util::All

If you want to put more functions in Util::All,
download distribution file and extract it and modify functions.yml and util-all.template(if needed).
And then do the following command.

 perl create_util_all.pl
 perl Makefile.PL
 make
 make test
 make install

To do this, the following modules is required.

 YAML::Syck
 Data::Dump
 File::Slurp

If you think more functions should be in Util::All, please inform me.

=head1 AUTHOR

Ktat, C<< <ktat at cpan.org> >>

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

L<Util::Any> ... Util::Any helps you to create your own utilitiy module.

=head1 COPYRIGHT & LICENSE

Copyright 2009 Ktat, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.


=cut

1; # End of Util::All
