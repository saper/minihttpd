use strict;
use warnings;

use Net::HTTP;
use v5.010;

say $Net::HTTP::VERSION;

my $IO = Net::HTTP->new('Host'=> 'paderewski.saper.info', 'PeerPort' => 8888) || die $@;
$IO->write_request(GET => "/chunked");
my ($code, $message, @headers) = $IO->read_response_headers;
my $buf;
my $rc = $IO->read_entity_body($buf, 20);
say "---";
say $rc;
say $buf;
say "---";
$rc = $IO->read_entity_body($buf, 20);
say $rc;
say $buf;
