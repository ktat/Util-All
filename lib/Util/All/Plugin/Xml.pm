package Util::All::Plugin::Xml;

use warnings;
use strict;

sub utils {
  {
  '-xml' => [
    [
      'XML::Simple',
      '',
      {
        '-select' => [],
        'to_xml' => sub {
            require String::CamelCase;
            my($pkg, $class, $func, $args, $kind_args) = @_;
            if (not defined($$args{'ForceArray'} ||= $$kind_args{'force_array'})) {
                if (not defined($$args{'ForceArray'} ||= $$args{'force_array'})) {
                    $$args{'ForceArray'} = 1;
                }
            }
            sub {
                my($data, %args) = @_;
                $args{String::CamelCase::camelize($_)} = delete $args{$_} foreach (keys %args);
                XML::Simple::XMLout($data, %$args, %args);
            }
            ;
        },
        'from_xml' => sub {
            require String::CamelCase;
            my($pkg, $class, $func, $args, $kind_args) = @_;
            local $XML::Simple::XML_SIMPLE_PREFERRED_PARSER = $$args{'parser'} || $$kind_args{'parser'} || 'XML::Parser';
            my %new_args;
            if (not defined($new_args{'ForceArray'} = $$args{'ForceArray'}) and not defined($new_args{'ForceArray'} = $$args{'force_array'}) and not defined($new_args{'ForceArray'} = $$kind_args{'ForceArray'}) and not defined($new_args{'ForceArray'} = $$kind_args{'force_array'})) {
                $new_args{'ForceArray'} = 1;
            }
            if (not defined($new_args{'KeyAttr'} = $$args{'KeyAttr'}) and not defined($new_args{'KeyAttr'} = $$args{'key_attr'}) and not defined($new_args{'KeyAttr'} = $$kind_args{'KeyAttr'}) and not defined($new_args{'KeyAttr'} = $$kind_args{'key_attr'})) {
                delete $new_args{'KeyAttr'};
            }
            sub {
                my($file, %args) = @_;
                $args{String::CamelCase::camelize($_)} = delete $args{$_} foreach (keys %args);
                XML::Simple::XMLin($file, (%new_args, %args));
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

Util::All::Plugin::Xml; -  Util::All plugin for Xml

=cut

=head1 EXPORT

NOTE THAT: almost all of functions' explantion is cited from original modules' document.

=head2 -xml

=head3 to_xml

    use Util::All -xml;
    
    my $xml = to_xml(\%structure);
    my $xml = to_xml(\%structure, force_array => 0, key_attr => 'id');
    
    use Util::All -xml => [-args => {parser => 'XML::Parser', force_array => 0, key_attr => "id"}];
    my $xmls = to_xml(\%structure);


parse XML file with XML::Simple. If xml has key attribute, you can pass key_attr => $key_name,
then this return hash ref instead of array ref. As default, attribute name "id" is regarded as key attribute.
This function pass force_array => 1 to XML::Simple, If you don't want it, give force_array => 0 as option,


=head3 from_xml

    use Util::All -xml;
    
    $data = from_xml('hoge.xml');
    $data = from_xml('hoge.xml', force_array => 0, key_attr => 'id'); # force_array is 1 as default.
    
    use Util::All -xml => [-args => {parser => 'XML::Parser', force_array => 0, key_attr => "id"}];
    
    $data = from_xml('hoge.xml');


parse XML file with XML::Simple.



=head1 AUTHOR

Ktat, C<< <ktat at cpan.org> >>

=head1 REPOSITORY

Util::All is hosted at github.

L<http://github.com/ktat/Util-All>

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

 perldoc Util::All::Xml

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