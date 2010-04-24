#!/usr/bin/perl

use strict;
use YAML::XS "Load";
use YAML::Syck "LoadFile";
use Clone;
use File::Slurp 'slurp';
use Tie::IxHash;
use Data::Dumper;
use Perl::Tidy qw/perltidy/;
use FindBin;
use List::MoreUtils ();
use String::CamelCase;
require "$FindBin::Bin/lib/abstract_pod.pl";

local $Data::Dumper::Deparse = 1;
local $Data::Dumper::Terse   = 1;
local $Data::Dumper::Indent  = 1;
local $Data::Dumper::Varname = 'Utils';

my %CONF;
@CONF{@ARGV} = ();
my %PLUGINS;

my $USE_PERLTIDY = !(exists $CONF{'-notidy'}) || 0;
my $NOTEST       = exists $CONF{'-notest'} || 0;

main();

sub main {
  reset_test();
  my @defs = def_usage_from_file("functions.yml");
  my $plugins = pop @defs;
  my (@modules, @requires);
  my ($modules, $requires) = write_file("all", @defs, $plugins) or die "NG";
  push @modules, @$modules;
  push @requires, @$requires;
  foreach my $k (keys %$plugins) {
    @defs = def_usage_from_file({$k => $plugins->{$k}});
    pop @defs;
    ($modules, $requires) = write_file($k, @defs) or die "NG";
    push @modules, @$modules;
    push @requires, @$requires;
  }
  write_make_file(\@modules, \@requires);
  system("prove -Ilib t/ t/auto/;") unless $NOTEST;
}

sub def_usage_from_file {
  tie my %new, 'Tie::IxHash';
  my %usage_test;
  tie %{$usage_test{usage} ||= {}}, 'Tie::IxHash';
  tie %{$usage_test{test} ||= {}}, 'Tie::IxHash';

  my $def = shift;
  # $def = Load(scalar slurp($def)) unless ref $def;
  $def = LoadFile($def) unless ref $def;

  my @modules;
  my @requires;
  my $default_priority = 1000;
  my %plugins;

  foreach my $k (keys %$def) {
    if (my $alias = delete $def->{$k}->{'-alias_of'}) {
      unless (ref $alias) {
        $def->{$k} = Clone::clone($def->{$alias});
      } else {
        $def->{$k}->{$alias->[1]} = Clone::clone($def->{$alias->[0]}->{$alias->[1]});
      }
    }
  }

  foreach my $k (sort keys %$def) {
    my %tmp;
    push @requires, @{delete $def->{$k}->{'-require'} || []};
    if (delete $def->{$k}->{'-as_plugin'}) {
      $plugins{$k} = delete $def->{$k};
      next;
    }

    $usage_test{usage}->{$k}->{'-all'} = delete $def->{$k}->{'-usage'} if exists $def->{$k}->{'-usage'};
    $usage_test{test}->{$k}->{'-all'}  = delete $def->{$k}->{'-test'}  if exists $def->{$k}->{'-test'};

    foreach my $m (sort {($tmp{$a} ||= (ref $def->{$k}{$a} ne 'HASH' ? $default_priority : delete $def->{$k}{$a}{-priority} || $default_priority)) <=>
                         ($tmp{$b} ||= (ref $def->{$k}{$b} ne 'HASH' ? $default_priority : delete $def->{$k}{$b}{-priority} || $default_priority))
                       } keys %{$def->{$k}}) {
      push @modules, $m;
      if ($def->{$k}->{$m} eq '*') {
        push @{$new{'-' . $k} ||= []}, [$m];
      } elsif (ref $def->{$k}{$m} eq 'HASH') {
        my @funcs;
        foreach my $f (keys  %{$def->{$k}->{$m}}) {
          next if $f eq '-select';
          if (ref $def->{$k}->{$m}->{$f} eq 'ARRAY') {
            my @usage_or_test;
            ($def->{$k}->{$m}->{$f}, @usage_or_test) = (@{$def->{$k}->{$m}->{$f}});
            if (@usage_or_test) {
              foreach my $usage_or_test (@usage_or_test) {
                if (ref $usage_or_test eq 'HASH') {
                  foreach my $ut ("usage", "test") {
                    if (exists $usage_or_test->{$ut}) {
                      $usage_test{$ut}{$k}{$f} = $usage_or_test->{$ut};
                    }
                  }
                } else {
                  push @{$usage_test{usage}{$k}{$f} ||= []}, $usage_or_test;
                }
              }
            }
          }
          if ($def->{$k}->{$m}->{$f} =~m{^sub }) {
            # print Data::Dumper::Dumper(eval"$def->{$k}->{$m}->{$f}");
            if(exists $usage_test{usage}{$k}->{'-all'}) {
              push @{$usage_test{usage}{$k}->{-renames} ||= []}, $f if $f ne '.';
            } elsif (exists $usage_test{usage}{$k}->{$f}) {
              $usage_test{usage}{$k}->{-rename}->{$f} = 1;
            } else {
              my $dest = '';
              $usage_test{usage}{$k}->{-rename}->{$f} = 1;
              if ($USE_PERLTIDY) {
                perltidy(source => \$def->{$k}->{$m}->{$f}, destination => \$dest);
                $usage_test{usage}{$k}{$f} ||= [$dest];
              } else {
                $usage_test{usage}{$k}{$f} = [$def->{$k}->{$m}->{$f}];
              }
            }
            no strict; # for not including "use strict" when Dumper.
            my $sub = eval "$def->{$k}->{$m}->{$f}";
            die $@. $def->{$k}->{$m}->{$f} if $@;
            $def->{$k}->{$m}->{$f} = $sub;
          } elsif ($f eq $def->{$k}->{$m}->{$f}) {
            push @funcs, delete $def->{$k}->{$m}->{$f};
          } else {
            delete $usage_test{usage}{$k}{$f};
            if (my @pod = abstract_pod($m, $f)) {
              my $pod = join "", @pod;
              $pod =~s{^=item.+$}{}gm;
              $usage_test{usage}{$k}{$def->{$k}->{$m}->{$f}} = ["", "($f of L<$m>)\n\n" . $pod];
            } else {
              $usage_test{usage}{$k}{$def->{$k}->{$m}->{$f}} = ["", "($f of L<$m>)"];
            }
          }
        }
        my (@selected, $pre_func);
        foreach my $func (@{$def->{$k}->{$m}->{-select} ||= []}, @funcs) {
            if (ref $func eq 'HASH') {
              if ($func->{usage}) {
                $usage_test{usage}{$k}->{$pre_func} = $func->{usage};
              }
              if ($func->{test}) {
                $usage_test{test}{$k}->{$pre_func} = $func->{test};
              }
            } else {
              if (ref $func eq 'ARRAY') {
                my $usage = $func;
                $func = shift @$usage;
                $usage_test{usage}{$k}->{$func} = $usage;
              } else {
                push @{$usage_test{usage}{$k}->{'-rest'}->{$m} ||= []}, $func;
              }
              push @selected, $func;
              $pre_func = $func;
            }
        }
        $def->{$k}->{$m}->{-select} = \@selected;
        push @{$new{'-' . $k} ||= []}, [
                                        $m, '',
                                        $def->{$k}->{$m},
                                       ];
      } else {
        $usage_test{usage}{$k}->{-rest}->{$m} = $def->{$k}->{$m};
        push @{$new{'-' . $k} ||= []}, [
                                        $m, '',
                                        {
                                         -select => $def->{$k}->{$m}},
                                       ];
      }
    }
  }
  return (\%new, $usage_test{usage}, \@modules, \@requires, $usage_test{test}, \%plugins);
}

sub write_file {
  my ($kind, $new, $usage_data, $modules, $requires, $test, $plugins) = @_;
  my $def_string = Dumper($new);
  my $success = 0;

  my $template = slurp($kind eq 'all' ? "$FindBin::Bin/../template/util-all.template" : "$FindBin::Bin/../template/util-all-plugin.template") or die $!;

  my $usage = usage($usage_data, $test);
  generate_test($usage_data, $test);

  $kind = ucfirst($kind);
  $template =~s{###KIND###}{$kind}g;
  $template =~s{###DEFINITION###}{$def_string};
  my %exclude;
  @exclude{qw/utf8 strict B::Deparse Tie::Trace/} = ();
  my $dependent_modules = join ", ", map {"L<$_>"} grep {!exists $exclude{$_}} sort(List::MoreUtils::uniq(@$modules, @$requires));
  $template =~s{###DEPENDENT_MODULES###}{$dependent_modules};
  $template =~s{###USAGE###}{$usage};
  $template =~s{\$Utils1}{\$Utils}g;
  if (defined $plugins) {
    my @plugins;
    foreach my $p (keys %$plugins) {
      push @plugins, String::CamelCase::camelize($p);
    }
    my $plugin_text = join "\n\n", map "=head2 L<Util::All::Plugin::$_>", @plugins;
    $template =~s{###PLUGINS###}{$plugin_text};
  }

  my $out_file = $kind eq 'All' ? 'lib/Util/All.pm' : 'lib/Util/All/Plugin/' . ucfirst($kind) . '.pm';
  {
    open my $out, '>', $out_file or die $!;
    print $out $template;
    close $out;
    my $k = lc $kind;
    print "Writing $out_file\n";
    print "try perl -Ilib -MUtil::All=-$k -e ''\n";
    unless(system("perl -Ilib -MUtil::All=-$k -e '';")) {
      print "OK\n";
      $success = 1;
    } else {
      print "NG\n";
      die "maybe Util::All has syntax error.";
    }
  }
  return $success ? ($modules, $requires) : ();
}

sub write_make_file {
  my ($modules, $requires) = @_;
  my $makefile = do {local $/; <DATA>};
  my $dependent_modules = join ",\n", map {"\t'$_' => 0"} grep {$_ ne 'Date::Manip'} sort(List::MoreUtils::uniq(@$modules, @$requires));
  $dependent_modules .=  qq{,\n\t(\$] >= 5.010000 ? ('Date::Manip' => 0) : ())};
  $makefile =~s{###DEPENDENT_MODULES###}{$dependent_modules};
  {
    open my $out, '>', 'Makefile.PL' or die $!;
    print $out $makefile;
    close $out;
    print "Writing Makefile.PL\n";
  }
  return 1;
}

sub usage {
  my ($usage, $test) = @_;
  my $c;
  foreach my $kind (keys %$usage) {
    $c .= '=head2 -' . $kind . "\n\n";
    if (exists $usage->{$kind}->{'-all'}) {
      $c .= $usage->{$kind}->{'-all'} . "\n\n";
#      if ($usage->{$kind}->{-renames}) {
#        $c .= "=head3 function enable to rename *\n\n";
#        $c .= join ", ", @{$usage->{$kind}->{-renames}};
#        $c .= "\n\n";
#      }
    } else {
      my %tmp;
      foreach my $f (keys %{$usage->{$kind}}) {
        next if $f eq '-rename' or $f eq '-renames';
        if ($f eq '-rest') {
          foreach my $m (keys %{$usage->{$kind}->{'-rest'}}) {
            $c .= "=head3 functions of L<$m>\n\n";
            my @pods = abstract_pod($m, @{$usage->{$kind}->{'-rest'}->{$m}});
            # $c .= "=over 4\n\n";
            if (!@pods or join("", @pods) =~ m{^[\s\t]+$}s) {
              foreach my $func (@{$usage->{$kind}->{'-rest'}->{$m}}) {
                $c .= "=head4 $func\n\n";
              }
            } else {
              my $last_pod = '';
              foreach my $pod (@pods) {
                next if $pod eq $last_pod;
                if ($pod !~ m{^=cut}m) {
                  $pod .= "\n=cut\n";
                }
                $pod =~s{^\s*\(not exported by default\)\s*$}{}mg;
                $last_pod = $pod;
                $pod =~s{^=head[12]}{=item};
                if ($pod =~m{^=head[123]}m) {
                  $pod =~s{^=head[123]}{\n\n=over 8\n\n=item}m;
                  $pod =~s{^=head[123]}{=item}mg;
                  $pod =~s{^=cut}{=back\n\n}m or die $pod;
                  $pod =~s{^=item}{=head4};
                  $c .= $pod;
                } else {
                  $pod =~s{^=item}{=head4};
                  $pod =~s{^=cut\s*}{}m;
                  $c .= $pod;
                }
              }
            }
            # $c .= "=back\n\n";
          }
        } else {
          $c .= "=head3 $f" . ($usage->{$kind}->{'-rename'}->{$f} ? ' *' : '') . "\n\n";
          if ($usage->{$kind}->{$f}->[0]) {
            $tmp{$f} = 1;
            if (ref $usage->{$kind}->{$f}->[0] eq 'ARRAY') {
              $usage->{$kind}->{$f}->[0] = join "\n", @{$usage->{$kind}->{$f}->[0]};
            }
            $usage->{$kind}->{$f}->[0] =~s{^}{  }mg;
            $c .= $usage->{$kind}->{$f}->[0] . "\n\n";;
          }
          if ($usage->{$kind}->{$f}->[1]) {
            $tmp{$f} = 1;
            $c .= $usage->{$kind}->{$f}->[1] . "\n\n";;
          }
        }
      }
    }
    foreach my $f (keys %{$test->{$kind}}) {
      # next if exists $tmp{$f};

      my $t = $test->{$kind}{$f};
      $c .= "=head3 test code\n\n";
      foreach my $test (@$t) {
        next if ref $test eq 'HASH';
        my ($_test, $_r) = @$test == 3 ? @{$test}[1,2] : @{$test}[0,1];
        $_test =~s{;}{;\n}g;
        $_test =~s{^\s*}{ }mg;
        $c .= $_test;
        chomp($c);
        $c .= "\n # equal to: " . $_r . "\n\n";
      }
    }
  }
  return $c;
}

sub reset_test {
  unless (-d "t/auto") {
    mkdir 't/auto';
  } else {
    unlink <t/auto/*>;
  }
}

sub generate_test {
  my ($usage, $test) = @_;
  foreach my $kind (sort keys %$test) {
    my $kind_tag = defined &{$kind} ? "-$kind" : "'-$kind'";
    open my $fh, ">", sprintf "t/auto/%s.t", $kind;
    print $fh <<__EOL;
use Test::More;
use strict;

use Util::All $kind_tag;

__EOL
    my @funcs;
    if (exists $usage->{$kind}->{-renames}) {
      push @funcs, @{$usage->{$kind}->{-renames}};
    }
    if (exists $usage->{$kind}->{-rest}) {
      push @funcs, @{$usage->{$kind}->{-rest}->{$_} || []} for keys %{$usage->{$kind}->{-rest}};
    }
    push @funcs, grep !/^-/, keys %{$usage->{$kind}};
    @funcs = grep $_ ne '.', List::MoreUtils::uniq(@funcs);
    foreach my $func (@funcs) {
      print $fh "ok(defined \&$func);\n";
    }
    foreach my $func (sort keys %{$test->{$kind}}) {
      push @funcs, $func;
      my $defs = $test->{$kind}->{$func};
      next if !$defs or !@$defs;
      my $skip = ref $defs->[0] eq 'HASH' ? shift(@$defs) : '';
      if ($skip) {
        printf $fh "SKIP: { skip(q{%s}, %d) if %s;\n", $skip->{skip}, scalar(@$defs), $skip->{skip};
      }
      foreach my $def (@$defs) {
        if (ref $def) {
          if (@$def == 3) {
            print $fh <<EOL
${$def}[0](
  [do {${$def}[1]}],
  [do {${$def}[2]}],
);
EOL
          } elsif(@$def == 2) {
            print $fh <<EOL
is_deeply(
  [do {${$def}[0]}],
  [do {${$def}[1]}],
);
EOL
          }
        } else {
          print $fh "ok(do {${$def}[0]})\n";
        }
      }
      print $fh "}\n" if $skip;
    }
    print $fh "done_testing;";
    close $fh;
    unlink sprintf "t/auto/%s.t", $kind unless @funcs;
  }
}

__END__
use strict;
use warnings;

use inc::Module::Install;

# Define metadata
name           'Util-All';
all_from       'lib/Util/All.pm';
repository     'git://github.com/ktat/Util-All.git';

# Specific dependencies
requires       'Util::Any'  => '0.20',
               ($] <  5.009_005 ? ('MRO::Compat' => 0) : ()),
# requires       'Task::Email::PEP::NoStore' => 0,
#               'Errno::AnyString' => 0,
###DEPENDENT_MODULES###
;
test_requires  'Test::More'  => '0.88',
               'Crypt::CBC' => 0,
               'Crypt::DES' => 0;
no_index       'directory'   => 'demos';
# install_script 'myscript';

tests_recursive;
# auto_install;
WriteAll;
