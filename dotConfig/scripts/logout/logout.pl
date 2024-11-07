use strict;
use warnings;
use Tk;

my $window = MainWindow->new;
$window->title("Logout");

my $username = `whoami`;

$window->Button(
    -text    => "Shutdown",
    -command => sub { system("shutdown -h now"); $window->destroy },
)->grid(-row => 0, -column => 0);

$window->Button(
    -text    => "Restart",
    -command => sub { system("reboot"); $window->destroy },
)->grid(-row => 0, -column => 1);

$window->Button(
    -text    => "Logout",
    -command => sub { system("pkill -u $username"); $window->destroy },
)->grid(-row => 0, -column => 2);

$window->Button(
    -text    => "Lock",
    -command => sub { system("xscreensaver-command -lock"); $window->destroy },
)->grid(-row => 0, -column => 3);

$window->Button(
    -text    => "Sleep",
    -command => sub { system("systemctl suspend"); $window->destroy },
)->grid(-row => 0, -column => 4);

$window->Button(
    -text    => "Cancel",
    -command => sub { $window->destroy },
)->grid(-row => 0, -column => 5);

$window->geometry("450x40+" . int($window->screenwidth / 2 - 182) . "+" . int($window->screenheight / 2 - 20));
$window->resizable(0,0);

MainLoop;
