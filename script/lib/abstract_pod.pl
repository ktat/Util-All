#!/usr/bin/perl

use strict;
use IO::String;
use Pod::Abstract;
use Pod::Perldoc;
use Pod::Perldoc::ToPod;
use warnings;

sub abstract_pod {
  my ($module, @functions) = @_;
  my $pod = Pod::Perldoc->new;
  my @path = $pod->grand_search_init([$module]) or return 1;
  my $parser = Pod::Perldoc::ToPod->new;
  my $fh = IO::String->new;
  $parser->parse_from_file(@path, $fh);
  seek $fh, 0, 0;
  my $pa = Pod::Abstract->load_file($fh);

  my @function_node;
  my $func_regexp = join "|", @functions;
  $func_regexp  = qr{(^[^\$]?($func_regexp)|(\->($func_regexp)\b)|(\s($func_regexp)))\b};
  my @try = ($pa, $func_regexp);
  if ($module eq 'Carp') {
    @function_node = try_from_carp(@try);
  } else {
  CHECK: {
      @function_node = try_head_item(1, @try) and last;
      @function_node = try_head_item(2, @try) and last;
      @function_node = try_head(1, @try)      and last;
      @function_node = try_head(2, @try)      and last;
    }
  }
  my @pod;
  foreach my $pod (@function_node) {
    $pod =~s{L</(.+?)>}{L<$module/$1>}gs;
    push @pod, $pod;
  }
  return wantarray ? @pod : join "", @pod;
}

sub try_head_item {
  my ($n, $pa, $regexp) = @_;
  my @nodes = $pa->select($n == 1 ? "/head1/over/item" : "/head1/head2/over/item");
  my @function_node;
  foreach my $node (@nodes) {
    foreach my $f ($node->param('label')->children) {
      if ($f->text =~ $regexp) {
        push @function_node, $node->pod;
      }
    }
  }
  return @function_node;
}

sub try_head {
  my ($n, $pa, $regexp) = @_;
  my @nodes = $pa->select($n == 1 ? '/head1' : '/head1/head2');
  my @function_node;
  foreach my $node (@nodes) {
    foreach my $f ($node->param('heading')->children) {
      if ($f->text =~ $regexp) {
        push @function_node, $node->pod;
      }
    }
  }
  return @function_node;
}

sub try_from_carp {
  my ($pa, $regexp) = @_;
  my @nodes = $pa->select('/head1');
  my @function_node;
  foreach my $node (@nodes) {
    foreach my $f ($node->param('heading')->children) {
      if ($f->text =~ m{NAME}) {
        my $pod = $node->pod;
        $pod =~ s{=head1 NAME}{};
        $pod =~ s{^(\w+)[\s\t]*(.+)$}{=head2 $1\n\n$2}gm;
        if ($pod =~ $regexp) {
          push @function_node, $pod;
        }
      }
    }
  }
  return @function_node;
}

1;
