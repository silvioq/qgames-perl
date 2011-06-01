
use Test::More tests => 11;
BEGIN { use_ok('QGames') };
my $tipojuego = QGames::open( "Ajedrez" );
my $partida   = $tipojuego->crea();
my $id        = $partida->id();
foreach( qw{ e4 e5 Nc3 Nc6 f4 exf4 } ){
    ok( $partida->move( $_ ), "Moviendo $_" );
}

my @posibles   = @{$partida->possible};
my @historial  = @{$partida->history};

my $binary     = $partida->dump;
ok( $binary );
my $partida2   = $tipojuego->load( $binary );
isa_ok( $partida2, QGames::Game, "partida" );

ok( @posibles eq  @{$partida2->possible}, "Control de posibles" );
ok( @historial eq  @{$partida2->history}, "Control de historial" );
