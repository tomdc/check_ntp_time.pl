#!/usr/bin/env perl -w

# uses http://search.cpan.org/~willmojg/Net-NTP-1.2/NTP.pm

use NTP;
use strict;

my $ntpserver="ntp.belnet.be";
my $warning = 60;
my $critical = 120;

my %ntp = get_ntp_response("$ntpserver");
my $localtime=time();

# RFC2030
my $offset =(($ntp{'Receive Timestamp'} - $ntp{'Originate Timestamp'}) + ($ntp{'Transmit Timestamp'} - $localtime) / 2);

if ( $offset < $warning ) {
	printf ("NTP OK: Offset %.6f secs|offset=%.6fs;%.6f;%.6f;\n", $offset, $offset, $warning, $critical);
	exit 0;
}
elsif ( $offset >= $warning && $offset < $critical ) {
	printf ("NTP WARNING: Offset %.6f secs|offset=%.6fs;%.6f;%.6f;\n", $offset, $offset, $warning, $critical);
	exit 1;
}
else {
	printf ("NTP CRITICAL: Offset %.6f secs|offset=%.6fs;%.6f;%.6f;\n", $offset, $offset, $warning, $critical);
        exit 2;
}
