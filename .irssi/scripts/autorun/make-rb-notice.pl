use strict;
use Irssi;
use vars qw($VERSION); 
$VERSION = "1";

sub sig_message {
	my ($server, $msg, $nick, $address) = @_;
#	$server->command("/echo $nick");
	if($nick eq "rb") {
		my $mynick = $server->{nick};
		Irssi::signal_emit("message irc notice", $server, $msg, $nick, $address, $mynick);
		Irssi::signal_stop();
	}
}

Irssi::signal_add_first('message private', 'sig_message');
