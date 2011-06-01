# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl QGames.t'

#########################

# change 'tests => 1' to 'tests => last_test_to_print';

use Test::More tests => 3;
BEGIN { use_ok('QGames') };

#########################

# Insert your test code below, the Test::More module is use()ed here so read
# its man page ( perldoc Test::More ) for help writing this test script.


is( QGames::PLAYING, -1 );
is( QGames::DRAW, 0 );

