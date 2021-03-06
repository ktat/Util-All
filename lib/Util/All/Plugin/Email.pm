package Util::All::Plugin::Email;

use warnings;
use strict;

sub utils {
  {
  '-email' => [
    [
      'Email::Sender::Simple',
      '',
      {
        'send_template_email' => sub {
            use strict 'refs';
            require Template;
            unless (defined &sendmail) {
                'Email::Sender::Simple'->import('sendmail');
            }
            sub {
                my $pkg = (caller)[0];
                my $opt = {};
                $opt = pop @_ if @_ > 2 and ref $_[-1] eq 'HASH';
                my($file_or_scalarref, $params, $attr) = @_;
                my $tt = 'Template'->new('INTERPOLATE', 1, 'ABSOLUTE', 1, 'RELATIVE', 1);
                my $body;
                $tt->process($file_or_scalarref, $params, \$body);
                my %header;
                if ($body =~ s/^(.+?)--\s*//s and my $header = $1) {
                    foreach my $kv (split(/[\r\n]+/, $header, 0)) {
                        my($k, $v) = split(/\s*:\s*/, $kv, 2);
                        $header{ucfirst $k} = $v;
                    }
                }
                no strict 'refs';
                my $mime = sendmail(&{$pkg . '::' . 'create_email';}([%header], $attr, $body));
            }
            ;
        },
        '-select' => [],
        'send_email' => sub {
            use strict 'refs';
            unless (defined &sendmail) {
                'Email::Sender::Simple'->import('sendmail');
            }
            sub {
                no strict 'refs';
                my $pkg = (caller)[0];
                my $opt = {};
                $opt = pop @_ if ref $_[-1] eq 'HASH';
                my $mime = sendmail(@_ == 1 ? @_ : &{$pkg . '::' . 'create_email';}(@_), $opt);
            }
            ;
        }
      }
    ],
    [
      'Email::MIME',
      '',
      {
        'parse_email' => sub {
            sub {
                my $src = shift @_;
                return 'Email::MIME'->new($src);
            }
            ;
        },
        '-select' => [],
        'create_email' => sub {
            my($pkg, $class, $func, $args) = @_;
            require Clone;
            require MIME::Types;
            require File::Slurp;
            my $mime = 'MIME::Types'->new;
            sub {
                my($header, $attributes, $parts_or_body) = @_;
                $attributes = &Clone::clone($attributes);
                unless (%$attributes) {
                  $attributes->{charset} = 'UTF-8';
                }
                $parts_or_body = &Clone::clone($parts_or_body) if ref $parts_or_body;
                if (ref $parts_or_body) {
                    my($use_str, $charset, $flg) = Util::All::Plugin::Email::_charset_resolver($attributes, $header);
                    my $e = 'Email::MIME'->create('attributes', $attributes, 'parts', [map({my @arg;
                    my($attributes, $body_or_file) = ref $_ ? @$_ : ({}, $_);
                    if (-e $body_or_file) {
                        my($ext) = $body_or_file =~ /\.(.+?)$/;
                        my($name) = $body_or_file =~m{([^/\\]+)$};
                        my $attr = {'filename', => $name, 'content_type', ($ext ? $mime->mimeTypeOf($ext) : 'text/plain'), 'encoding', 'base64'};
                        @arg = ('body', scalar File::Slurp::slurp($body_or_file), 'attributes', $attr);
                    }
                    else {
                        $$attributes{'content_type'} ||= 'text/plain';
                        my($use_str, $charset) = Util::All::Plugin::Email::_charset_resolver($attributes, []);
                        if ($charset and $flg) {
                            $body_or_file = Encode::encode($charset, $body_or_file);
                        }
                        @arg = ('attributes', $attributes, 'body', $body_or_file);
                    }
                    'Email::MIME'->create(@arg);} @$parts_or_body)], $use_str ? 'header_str' : 'header', $header);
                    return $e;
                }
                else {
                    my($use_str, $charset, $flg) = Util::All::Plugin::Email::_charset_resolver($attributes, $header);
                    $$attributes{'content_type'} ||= 'text/plain';
                    if ($use_str and not $flg) {
                        $parts_or_body = Encode::decode($charset, $parts_or_body);
                    }
                    elsif (not $use_str and $flg) {
                        $parts_or_body = Encode::encode($charset, $parts_or_body);
                    }
                    'Email::MIME'->create('attributes', $attributes, $use_str ? 'body_str' : 'body', $parts_or_body, $use_str ? 'header_str' : 'header', $header);
                }
            }
            ;
        }
      }
    ]
  ]
}
;
}

sub _charset_resolver {
  my ($attributes, $header) = @_;
  my $charset = $attributes->{charset} || '';
  my $use_str = $charset ? 1 : 0;
  my $flagged = 0;
  if ($charset =~m{iso[-_]2022[-_]jp}o or $charset =~m{\bjis$}o) {
    $use_str = 0;
    my $i = 0;
    foreach my $head (@$header) {
      next if ++$i % 2;
      if ($flagged ||= utf8::is_utf8($head)) {
        $head = Encode::encode('MIME-Header-ISO_2022_JP' => $head);
      } else {
        Encode::from_to($head, "iso-2022-jp", 'MIME-Header-ISO_2022_JP');
      }
    }
    $attributes->{charset}  = 'iso-2022-jp';
    $attributes->{encoding} = '7bit';
  } elsif ($charset) {
    my $i = 0;
    foreach my $head (@$header) {
      next if ++$i % 2;
      $flagged = utf8::is_utf8($head);
      unless ($flagged) {
        $head = Encode::decode($charset, $head);
      }
    }
    $attributes->{encoding} = '8bit';
  } else {
    $attributes->{encoding} = 'base64';
  }
  return ($use_str, $charset, $flagged);
}


=head1 NAME

Util::All::Plugin::Email; -  Util::All plugin for Email

=cut

=head1 EXPORT

functions which C<*> follows are generated by the way like Sub::Exporter.
see L<Util::Any/"USE Sub::Exporter's GENERATOR WAY">

=head2 -email

=head3 examples

You have to pass encoded arguments.

  # multipart email
  my @parts = ([$body, $attribute], [$body2, $attribute2]);
  my $email = create_email([From => 'from@example.com'], {'content_type' => 'text/plain'}, \@parts);
  send_email($email);

  # multipart email
  my $email = create_email([To => 'from@example.com', Subject => "さぶじぇくと"], {charset => "jis"},
                           [[{content_type => "text/plain", charset => "utf8"}, "まるちばいと"],
                            "example.jpg"]);
  send_email($email);

  # singlepart email
  my $email = create_email([From => 'from@example.com'], {'content_type' => 'text/plain'}, $body);
  send_email($email);

  # send_email with create_email
  send_email([From => 'from@example.com'], {'content_type' => 'text/plain'}, \@parts);
  send_email([From => 'from@example.com'], {'content_type' => 'text/plain'}, $body, {transport => $transport});


  # send_template_email (singlepart only)
  send_template_email($template_file, $parameter, {'content_type' => 'text/plain'}, {transport => $transprot})
  # $template_file is like the following
  #
  #   From:
  #   To: 
  #   Subject: 
  #   --
  #   Hello, World!
  #   Hello, World!
  #   Hello, World!
  #
  # header is begore '--'. data part is aftrer '--'.

  # parse_email
  parse_email($email_src); # currently just returns Email::MIME object

=head3 send_email

  send_email($email);
  send_email($email, $options);
  send_email($header, $attributes, $body, $options);
  send_email($header, $attributes, \@parts, $options);

arguments is Email::MIME object(create_email returns) or
arguments as same as create_email.
As an additional argument, you can put hash ref as last argument
which is equal to last argument of Email::Sender::Simple's sendmail.




=head1 AUTHOR

Ktat, C<< <ktat at cpan.org> >>

=head1 REPOSITORY

Util::All is hosted at github.

L<http://github.com/ktat/Util-All>

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

 perldoc Util::All::Email

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
