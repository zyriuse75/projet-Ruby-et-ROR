#!/usr/bin/perl

use strict;
use DBD::mysql;
use POSIX qw(strftime);
use BigBrother;

my $DEBUG = 0;
my $col = "repl";

#
# DB info
#
my $dbhost = 'localhost'; 
my $dbuser = 'USER-DB';
my $dbpass = 'PASSWORD-DB';

my $color = "green";
my $red = "red";
my $warn = "300"; #Time in seconds for yellow
my $panic = "1800"; #Time in seconds for red


my $dbh = DBI->connect("DBI:mysql:database=mysql;host=$dbhost", $dbuser, $dbpass) or send_data($red);
my $sth = $dbh->prepare("show slave status");
$sth->execute;

my $ref = $sth->fetchrow_hashref();

my $slave_io_running = $ref->{'Slave_IO_Running'};
my $slave_io_state = $ref->{'Slave_IO_State'};
my $seconds_behind_master = $ref->{'Seconds_Behind_Master'};
my $slave_sql = $ref->{'Slave_SQL_Running'};
my $last_error = $ref->{'Last_Error'};

$sth->finish;
$dbh->disconnect;

if ((!$slave_io_running) || ($slave_io_running eq "No"))
{
	my $now = strftime "%a %b %e %H:%M:%S %Y", localtime;
	my $display_text = "$now<br/><br/><br/>" .
		"Actually, this server is MASTER.<br/>"; 
BigBrother->Report($ENV{'MACHINE'}, $col, $color, $display_text);
}
else
{

if ($slave_io_running eq "No") {
	$color = "red";
	print "Set red due to slave_io_running value of $slave_io_running\n" if $DEBUG == 1;
}

if ($slave_sql eq "No") {
	$color = "red";
	print "Set red due to slave_sql value of $slave_sql\n" if $DEBUG == 1;
}

if ($seconds_behind_master > $warn && $seconds_behind_master < $panic) {
	$color = "yellow";
	print "Set yellow due to seconds behind master value of $seconds_behind_master\n" if $DEBUG == 1;
}

if ($seconds_behind_master >= $panic) {
	$color = "red";
	print "Set red due to seconds behind master value of $seconds_behind_master\n" if $DEBUG == 1;
}

print "$slave_io_running\n" if $DEBUG == 1;
print "$slave_io_state\n" if $DEBUG == 1;
print "$seconds_behind_master\n" if $DEBUG == 1;
print "$slave_sql\n" if $DEBUG == 1;
print $color . "\n" if $DEBUG == 1;
print "$slave_sql\n" if $DEBUG == 1;
print $color . "\n" if $DEBUG == 1;

#send_data($color);
#sub send_data {
#$DEBUG = 1;
#my $color = @_[0];

my $now = strftime "%a %b %e %H:%M:%S %Y", localtime;
my $display_text = "$now<br/><br/><br/>" .
		"Slave IO Running: $slave_io_running<br/>" .
		"Slave IO State: $slave_io_state<br/>" .
		"Slave SQL Running: $slave_sql<br/>" .
		"Seconds Behind Master: $seconds_behind_master<br/>" .
		"Last Error: $last_error<br/>";

BigBrother->Report($ENV{'MACHINE'}, $col, $color, $display_text);

}

#my $line = "\"status $ENV{'MACHINE'}.$col $color $display_text\"";
#my @args = ($ENV{'BB'}, $ENV{'BBDISP'}, $line);
#my @args = ("/var/bb/bin/bb", "bigbrother.cavecreek.net", "status nictool-failover,cwie,net.repl green foo");
#system(@args);
#if ($DEBUG == 1) {
#       print "Debugging args array:\n";
#       print "Number of elements: " . @args . "\n";
#       foreach (@args) {
#               print $_ . "\n";
#       }
#}
