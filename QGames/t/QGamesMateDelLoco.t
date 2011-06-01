
use Test::More tests => 23;
BEGIN { use_ok('QGames') };

my $tipojuego = QGames::open( "Ajedrez" );
my $partida   = $tipojuego->crea();

ok( $partida->color() eq "blanco" );
ok( $partida->move_count() eq 0 );
ok( $partida->move( "g4" ) );
is( $partida->state, "Playing" );
ok( $partida->final == QGames::PLAYING );
ok( !$partida->winner );

ok( $partida->move_count eq 1 );
ok( $partida->move( "e5" ) );
is( $partida->state, "Playing" );
ok( $partida->move_count eq 2 );
ok( $partida->final == QGames::PLAYING );
ok( !$partida->winner );

ok( $partida->move( "f3" ) );
is( $partida->state, "Playing" );
ok( $partida->move_count eq 3 );
ok( $partida->final == QGames::PLAYING );
is( $partida->winner, undef );

ok( $partida->move( "Qh4" ) );
is( $partida->state, "negro Gana"  );
ok( $partida->move_count eq 4 );
ok( $partida->final == 2 );
ok( $partida->winner eq "negro" );
