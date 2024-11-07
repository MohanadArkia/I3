#!/usr/bin/env perl
use strict;
use warnings;
use IPC::System::Simple qw(system);

$ENV{'DISPLAY'} = ':0';
$ENV{'DBUS_SESSION_BUS_ADDRESS'} = "unix:path=/run/user/1000/bus";

chomp(my $battery_percentage = `acpi -b | grep -P -o '[0-9]+(?=%)'`);
my $battery_discharging=`acpi -b | grep "Battery 0" | grep -c "Discharging"`;

my $empty_file = "/tmp/batteryempty";
my $full_file  = "/tmp/batteryfull";

if ($battery_discharging == 1 && -f $full_file) {
    unlink $full_file;
} elsif ($battery_discharging == 0 && -f $empty_file) {
    unlink $empty_file;
}

if ($battery_percentage >= 95 && $battery_discharging == 0 && ! -f $full_file) {
    system('notify-send', 'Battery Charged', 'Battery is fully charged.', '-r', '9991');
    utime undef, undef, $full_file;
} elsif ($battery_percentage <= 25 && $battery_discharging == 1 && ! -f $empty_file) {
    system('notify-send', 'Low Battery', "$battery_percentage% of battery remaining.", '-u', 'critical', '-r', '9991');
    utime undef, undef, $empty_file;
}
