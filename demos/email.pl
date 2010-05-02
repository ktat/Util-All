#!/usr/bin/perl

use lib qw(../lib);
use Util::All -email, -charset;
use utf8;

my ($from, $to) = @ARGV;
die "[USAGE] email.pl FROM_ADDRESS TO_ADDRESS\n" unless $to and $from;

foreach my $charset ('utf8', 'iso-2022-jp') {
  warn $charset, "\n";
  # no utf8 flag
  my $subject = char_encode($charset,"さぶじぇくと");
  my $body    = char_encode($charset,"まるちばいと");
  test_email($charset, $subject . "$charset - no utf8 ", $body, $from, $to);
}

foreach my $charset ('utf8', 'iso-2022-jp') {
  warn "utf8-flg: ", $charset, "\n";
  # utf8 flag
  my $subject = "さぶじぇくと";
  my $body    = "まるちばいと";
  test_email($charset, $subject . "$charset - utf8 flg", $body, $from, $to);
}

sub test_email {
  my ($charset, $subject, $body, $from, $to) = @_;
  my $email = create_email([From => $from, To => $to, Subject => $subject],
                           {'content_type' => 'text/plain', charset => $charset}, $body);
  warn "Single Part\n";
  send_email($email);

  warn "Multi Part\n";
  my $utf8_body = utf8::is_utf8($subject) ? "マルチパート まるちばいと(flg)" : char_encode("utf8", "マルチパート まるちばいと(no flg)");
  send_email([From => $from, To => $to, Subject => $subject],
             {charset => $charset},
             [
              [ {content_type => "text/plain", charset => "utf8"}, $utf8_body ],
              [ {content_type => "text/plain", charset => "utf8"}, $utf8_body . '2'],
              $0
             ]);
}
