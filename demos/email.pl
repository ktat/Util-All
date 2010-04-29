use lib qw(../lib);
use Util::All -email, -charset;
use utf8;

my $charset = "iso-2022-jp";
$charset = 'utf8';
my $subject   = char_encode($charset,"さぶじぇくと");
my $jis_body  = char_encode($charset,"まるちばいと");
my $utf8_body = char_encode("utf8","まるちばいと");

my $email;
my ($from, $to) = @ARGV;
die "[USAGE] email.pl FROM_ADDRESS TO_ADDRESS\n" unless $to and $from;

$email = create_email([From => $from, To => $to, Subject => $subject],
                      {'content_type' => 'text/plain', charset => $charset}, $jis_body);
send_email($email);

send_email([From => $from, To => $to, Subject => $subject],
                      {'content_type' => 'text/plain', charset => $charset}, $jis_body);

$email = create_email([From => $from, To => $to, Subject => $subject],
                      {charset => $charset},
                      [
                       [ {content_type => "text/plain", charset => "utf8"}, $utf8_body ],
                       $0
                      ]
                     );
send_email($email);

send_email([From => $from, To => $to, Subject => $subject],
           {charset => $charset},
           [
            [ {content_type => "text/plain", charset => "utf8"}, $utf8_body ],
            $0
           ]);
