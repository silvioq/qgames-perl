
use Test::More tests => 3;
BEGIN { use_ok('QGames') };

my $tipojuego = QGames::open( "Ajedrez" );
isa_ok( $tipojuego , QGames::Tipojuego );
my $partida   = $tipojuego->crea_partida();
isa_ok( $partida, QGames::Partida, "partida" );
