
use Test::More tests => 11;
BEGIN { use_ok('QGames') };

my $tipojuego = QGames::open( "Ajedrez" );
isa_ok( $tipojuego , QGames::Tipojuego );
my $partida   = $tipojuego->crea_partida();
my $oldid     = $partida->id();
isa_ok( $partida, QGames::Partida, "partida" );
$partida   = $tipojuego->crea_partida();
isa_ok( $partida, QGames::Partida, "partida" );
ok( $partida->id() );
ok( $partida->id() ne $oldid );

ok( $partida->color() eq "blanco" );
ok( $partida->movidas_count() eq 0 );
ok( $partida->mover( "e4" ) );
ok( $partida->movidas_count eq 1 );

ok( $partida->estado eq "Jugando" );
