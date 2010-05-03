package Util::All::Plugin::Charset;

use warnings;
use strict;

sub utils {
  {
  '-charset' => [
    [
      'Unicode::Japanese',
      '',
      {
        'h2z_sym' => sub {
            sub {
                my $str = shift @_;
                my $method = utf8::is_utf8($str) ? 'getu' : 'get';
                Unicode::Japanese::unijp($str)->h2zSym->$method;
            }
            ;
        },
        '-select' => [],
        'h2z' => sub {
            sub {
                my $str = shift @_;
                my $method = utf8::is_utf8($str) ? 'getu' : 'get';
                Unicode::Japanese::unijp($str)->h2z->$method;
            }
            ;
        },
        'z2h_alpha' => sub {
            sub {
                my $str = shift @_;
                my $method = utf8::is_utf8($str) ? 'getu' : 'get';
                Unicode::Japanese::unijp($str)->z2hAlpha->$method;
            }
            ;
        },
        'z2h_num' => sub {
            sub {
                my $str = shift @_;
                my $method = utf8::is_utf8($str) ? 'getu' : 'get';
                Unicode::Japanese::unijp($str)->z2hNum->$method;
            }
            ;
        },
        'h2z_num' => sub {
            sub {
                my $str = shift @_;
                my $method = utf8::is_utf8($str) ? 'getu' : 'get';
                Unicode::Japanese::unijp($str)->h2zNum->$method;
            }
            ;
        },
        'h2z_kana' => sub {
            sub {
                my $str = shift @_;
                my $method = utf8::is_utf8($str) ? 'getu' : 'get';
                Unicode::Japanese::unijp($str)->h2zKana->$method;
            }
            ;
        },
        'z2h_sym' => sub {
            sub {
                my $str = shift @_;
                my $method = utf8::is_utf8($str) ? 'getu' : 'get';
                Unicode::Japanese::unijp($str)->z2hSym->$method;
            }
            ;
        },
        'h2z_alpha' => sub {
            sub {
                my $str = shift @_;
                my $method = utf8::is_utf8($str) ? 'getu' : 'get';
                Unicode::Japanese::unijp($str)->h2zAlpha->$method;
            }
            ;
        },
        'z2h' => sub {
            sub {
                my $str = shift @_;
                my $method = utf8::is_utf8($str) ? 'getu' : 'get';
                Unicode::Japanese::unijp($str)->z2h->$method;
            }
            ;
        },
        'z2h_kana' => sub {
            sub {
                my $str = shift @_;
                my $method = utf8::is_utf8($str) ? 'getu' : 'get';
                Unicode::Japanese::unijp($str)->z2hKana->$method;
            }
            ;
        }
      }
    ],
    [
      'Encode',
      '',
      {
        'from_to' => 'char_from_to',
        'jfold' => sub {
            my($pkg, $class, $func, $args, $kind_args) = @_;
            sub {
                my($str, $width, $nl) = @_;
                $width ||= $$args{'width'} || $$kind_args{'width'};
                $nl ||= $$args{'nl'} || $$kind_args{'nl'} || "\n";
                my $is_utf8 = 0;
                utf8::decode($str) if not $is_utf8 = utf8::is_utf8($str);
                my $cnt = 0;
                my @lines;
                my $l = '';
                foreach my $s ($str =~ /(.)/g) {
                    if ($s =~ /\p{ASCII}/ or $s =~ /\p{InHalfwidthAndFullwidthForms}/ and not $s =~ /[\p{Lu}\p{Ll}\p{LC}\p{Lt}\p{Lm}\p{S}\p{P}\p{N}]/) {
                        ++$cnt;
                    }
                    else {
                        $cnt += 2;
                    }
                    $l .= $s;
                    if ($cnt >= $width) {
                        push @lines, $l;
                        $cnt = 0;
                        $l = '';
                    }
                }
                push @lines, $l if $l;
                return $is_utf8 ? join($nl, @lines) : Encode::encode('utf8', join($nl, @lines));
            }
            ;
        },
        'decode' => 'char_decode',
        '-select' => [],
        'encode' => 'char_encode',
        'char_convert' => sub {
            my($pkg, $class, $func, $args) = @_;
            my $g_class = 0;
            if (exists $$args{'guess'}) {
                require Encode::Guess;
                'Encode::Guess'->import(@{$$args{'guess'};});
            }
            elsif (not $INC{'Encode/Detect.pm'} and not $INC{'Encode/Guess.pm'}) {
                require Encode::Guess unless eval {
                    do {
                        require Encode::Detect;
                        $g_class = 1
                    }
                };
            }
            sub {
                my($str, $to, $from) = @_;
                if (ref $str and utf8::is_utf8($$str)) {
                    utf8::encode($$str);
                }
                elsif (utf8::is_utf8($str)) {
                    utf8::encode($str);
                }
                Encode::from_to(ref $str ? $$str : $str, $from ? $from : ($g_class ? 'DETECT' : 'GUESS'), $to);
                return $str;
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

Util::All::Plugin::Charset; -  Util::All plugin for Charset

=cut

=head1 EXPORT

NOTE THAT: almost all of functions' explantion is cited from original modules' document.

=head2 -charset

=head3 char_encode / char_decode

They are encode / decode of Encode.

=head3 char_convert

old Jocde style function.

 $new_str = char_convert($str, "euc-jp"); # to euc-jp
 $new_str = char_convert($str, "euc-jp", "sjis"); # to euc-jp from sjis

convert $str to second argument charset. third argument is charset of $str.
when third argument is omitted, Encode::Detect(if installed) or Encode::Guess is used to detect charset.

=head3 z2h functions

 z2h($str);       # return the value replaced zenkaku to hankaku
 z2h_kana($str);  # return the value replaced zenkaku kana hankaku
 z2h_num($str);   # return the value replaced zenkaku number hankaku
 z2h_sym($str);   # return the value replaced zenkaku symbol hankaku
 z2h_alpha($str); # return the value replaced zenkaku alphabet hankaku

If $str is utf8 flag on, return utf flagged value, if not return byte string.

=head3 h2z functions

 h2z($str);       # return the value replaced hankaku to zenkaku
 h2z_kana($str);  # return the value replaced hankaku kana zenkaku
 h2z_num($str);   # return the value replaced hankaku number zenkaku
 h2z_sym($str);   # return the value replaced hankaku symbol zenkaku
 h2z_alpha($str); # return the value replaced hankaku alphabet zenkaku

If $str is utf8 flag on, return utf flagged value, if not return byte string.

=head3 jfold

 jfold($sentence, $width, $new_line_char);
 jfold("アイウエオ１２３４ABCD（）＊＆", 4); # "アイ\nウエ\nオ１\n２３\n４AB\nCD（\n）＊\n＆"

This folds sentence. This regards full-width char as 2 and half-width char as 1.
The given string must be utf-8(flagged or non flagged).

You can give default $width and/or $new_line_char.

 use Util::All -charset => [jfold => {width => 4, nl => "\t"}];

 jfold($str);
 jfold("アイウエオ１２３４ABCD（）＊＆"); # "アイ\tウエ\tオ１\t２３\t４AB\tCD（\t）＊\t＆";




=head1 AUTHOR

Ktat, C<< <ktat at cpan.org> >>

=head1 REPOSITORY

Util::All is hosted at github.

L<http://github.com/ktat/Util-All>

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

 perldoc Util::All::Charset

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