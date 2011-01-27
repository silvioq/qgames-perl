
use Test::More tests => 6;
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

