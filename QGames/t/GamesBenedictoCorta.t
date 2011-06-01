
use Test::More tests => 24;
BEGIN { use_ok('QGames') };

my $tipojuego = QGames::open( "AjedrezBenedicto" );
my $partida   = $tipojuego->crea();

ok( $partida->color() eq "blanco" );
ok( $partida->move_count() eq 0 );
ok( $partida->move( "d4" ) );
is( $partida->state, "Playing" );
ok( $partida->final == QGames::PLAYING );
ok( !$partida->winner );

ok( $partida->move_count eq 1 );
ok( $partida->move( "e5" ) );
is( $partida->state, "Playing" );
ok( $partida->move_count eq 2 );
ok( $partida->final == QGames::PLAYING );
ok( !$partida->winner );

ok( $partida->move( "e3" ) );
is( $partida->state, "Playing" );
ok( $partida->move_count eq 3 );
ok( $partida->final == QGames::PLAYING );
is( $partida->winner, undef );

my @posible = @{$partida->possible};
is( scalar(@posible), 30 );

ok( $partida->move( "Bb4" ) );
is( $partida->state, "negro Gana" );
is( $partida->move_count, 4 );
ok( $partida->final == 2 );
ok( $partida->winner eq "negro" );
