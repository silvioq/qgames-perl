
use Test::More tests => 16;
BEGIN { use_ok('QGames') };

my $tipojuego = QGames::open( "Ajedrez" );
isa_ok( $tipojuego , QGames::Gametype );
isa_ok( QGames::open( "Ajedrez" ), QGames::Gametype );
my $partida   = $tipojuego->crea();
my $oldid     = $partida->id();
isa_ok( $partida, QGames::Game, "partida" );
$partida   = QGames::open( "Ajedrez" )->crea();
isa_ok( $partida, QGames::Game, "partida" );
ok( $partida->id() );
ok( $partida->id() ne $oldid );

ok( $partida->color() eq "blanco" );
ok( $partida->move_count() eq 0 );
ok( @{$partida->history} eq 0, "Historial vacio" );
ok( $partida->move( "e4" ) );
ok( $partida->move_count eq 1 );

is( $partida->state, "Playing" );
ok( @{$partida->history} eq 1 );
ok( $partida->move( "e5" ) );
ok( @{$partida->history} eq 2 );

