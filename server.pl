use strict;
use warnings;

use HTTP::Daemon;
use HTTP::Status;
use HTTP::Response;

my $cnt = 0;

sub chunk {
	if ($cnt++ > 2) {
		$cnt = 0;
		return undef;
	} else { 
		return "01234";
	}
}

my $plain_resp = HTTP::Response->new(200, "It's coming", [ "Contet-Type" => "text/plain" ], "plain");
my $chunked_resp = HTTP::Response->new(200, "It's coming", [ "Contet-Type" => "text/plain" ], \&chunk);
 
my $d = HTTP::Daemon->new(LocalPort => 8888) || die;
print "Please contact me at: <URL:", $d->url, ">\n";
while (my $c = $d->accept) {
    while (my $r = $c->get_request) {
        if ($r->method eq 'GET' and $r->uri->path eq "/xyzzy") {
            # remember, this is *not* recommended practice :-)
            $c->send_file_response("/COPYRIGHT");
        }
        if ($r->method eq 'GET' and $r->uri->path eq "/plain") {
            $c->send_response( $plain_resp );
        }
        if ($r->method eq 'GET' and $r->uri->path eq "/chunked") {
            $c->send_response( $chunked_resp );
        }
        else {
            $c->send_error(RC_FORBIDDEN)
        }
    }
    $c->close;
    undef($c);
}
