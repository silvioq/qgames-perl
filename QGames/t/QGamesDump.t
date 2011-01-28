
use Test::More tests => 11;
BEGIN { use_ok('QGames') };
my $tipojuego = QGames::open( "Ajedrez" );
my $partida   = $tipojuego->crea();
my $id        = $partida->id();
foreach( qw{ e4 e5 Nc3 Nc6 f4 exf4 } ){
    ok( $partida->mover( $_ ), "Moviendo $_" );
}

my @posibles   = @{$partida->posibles};
my @historial  = @{$partida->historial};

my $binary     = $partida->dump;
ok( $binary );
my $partida2   = $tipojuego->load( $binary );
isa_ok( $partida2, QGames::Partida, "partida" );

ok( @posibles eq  @{$partida2->posibles}, "Control de posibles" );
ok( @historial eq  @{$partida2->historial}, "Control de historial" );
