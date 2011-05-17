
use Test::More tests => 23;
BEGIN { use_ok('QGames') };

my $tipojuego = QGames::open( "Ajedrez" );
my $partida   = $tipojuego->crea();

ok( $partida->color() eq "blanco" );
ok( $partida->movidas_count() eq 0 );
ok( $partida->mover( "g4" ) );
ok( $partida->estado eq "Jugando" );
ok( $partida->final == QGames::FINAL_ENJUEGO );
ok( !$partida->ganador );

ok( $partida->movidas_count eq 1 );
ok( $partida->mover( "e5" ) );
ok( $partida->estado eq "Jugando" );
ok( $partida->movidas_count eq 2 );
ok( $partida->final == QGames::FINAL_ENJUEGO );
ok( !$partida->ganador );

ok( $partida->mover( "f3" ) );
ok( $partida->estado eq "Jugando" );
ok( $partida->movidas_count eq 3 );
ok( $partida->final == QGames::FINAL_ENJUEGO );
is( $partida->ganador, undef );

ok( $partida->mover( "Qh4" ) );
ok( $partida->estado eq "negro Gana" );
ok( $partida->movidas_count eq 4 );
ok( $partida->final == 2 );
ok( $partida->ganador eq "negro" );
