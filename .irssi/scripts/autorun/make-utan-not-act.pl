use strict;
use Irssi;
use vars qw($VERSION); 
$VERSION = "1";

sub add_no_act {
	my($dest,$pretty,$ugly) = @_;
	if ($pretty =~ /<U-tan> - (Join|Part)/) {
		$$dest{level} |= MSGLEVEL_NO_ACT;
	}
}

Irssi::signal_add_first('print text', 'add_no_act');
