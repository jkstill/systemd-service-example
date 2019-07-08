#!/usr/bin/env perl

=head1 server.pl

  simple Socket service
  return every line reversed

=cut

use warnings;
use strict;
use IO::Socket::INET;
use Socket qw(SOL_SOCKET SO_RCVBUF IPPROTO_IP IP_TTL);
#use Data::Dumper;

my $port = 4242;

$| = 1; # flush stdout
 
my $proto = getprotobyname('tcp');    #get the tcp protocol
 
my $sock = IO::Socket::INET->new(
	LocalPort => $port, 
	Proto => $proto, 
	Listen  => 1, 
	Reuse => 1
) or die "Cannot create socket: $@";


print "Initial Receive Buffer is ", $sock->getsockopt(SOL_SOCKET, SO_RCVBUF),
	" bytes\n";

print "Server reverse-text is now listening ...\n";
 
$SIG{INT} = sub { shutdown $sock,2; close($sock); die "\nkilled\n" };

#accept incoming connections and talk to clients
while(1)
{
	my ($packets, $totalBytes, $sockElapsed) = (0,0,0);
	my($client);
	my $addrinfo = accept($client , $sock);
 
	my($clientPort, $iaddr) = sockaddr_in($addrinfo);
	my $name = gethostbyaddr($iaddr, AF_INET);

	if ( defined $name) {
		print "Connection accepted from $name : $clientPort\n";
	} else {
		print "Could not lookup name for port $clientPort\n";
	}

	while(<$client>) {
		my $line = $_;
		syswrite($client, scalar reverse $line );
	}

	shutdown $client,2;
	close $client;

	print "\nSocket closed - accepting new connections\n";
}
 
#close the socket
shutdown $sock,2;
close($sock);
exit;


