
use Test::More tests => 30;
BEGIN { use_ok('QGames') };

ok( my $tipojuego = QGames::open( "Ajedrez" ) );
ok(  $tipojuego->describe->{colores}->{blanco}                 , "Esta el blanco" );
ok( !$tipojuego->describe->{colores}->{blanco}->{rotado}       , "Blanco no rota" );
ok(  $tipojuego->describe->{colores}->{negro}                  , "Esta el negro" );
ok(  $tipojuego->describe->{colores}->{negro}->{rotado}        , "negro si rota" );
ok(  $tipojuego->describe->{nombre} eq "Ajedrez"               , "El nombre es Ajedrez" );
my @piezas = sort @{$tipojuego->describe->{piezas}};
my $i = 0;
foreach( qw{ alfil caballo dama peon rey torre } ){
    ok( $piezas[$i] eq $_, "Pieza $i es $_" );   
    $i ++;
}
ok(  keys( %{$tipojuego->describe->{casilleros}} ) eq  64 ,     "64 casilleros" );

my  $logo = $tipojuego->logo;
ok( $logo->{w} > 100, "Width" );
ok( $logo->{h} > 100, "Height" );
ok( $logo->{png} , "PNG" );

# Check name
is( $tipojuego->nombre, "Ajedrez",   "El nombre es ajedrez, que otro!" );
is( "$tipojuego", "Ajedrez",         "El nombre es ajedrez, que otro!" );


ok(  $tipojuego = QGames::open( "AfricaUniversity" ) );
ok( !$tipojuego->describe->{colores}->{blanco}                 , "No esta el blanco" );
ok(  $tipojuego->describe->{colores}->{rojo}                   , "Esta rojo" );
ok( !$tipojuego->describe->{colores}->{rojo}->{rotado}         , "rojo no rota" );
ok(  $tipojuego->describe->{colores}->{negro}                  , "Esta negro" );
ok( !$tipojuego->describe->{colores}->{negro}->{rotado}        , "negro no rota" );
@piezas = sort @{$tipojuego->describe->{piezas}};
$i = 0;
foreach( qw{ A U } ){
    ok( $piezas[$i] eq $_, "Pieza $i es $_" );   
    $i ++;
}

ok(  $tipojuego = QGames::open( "Pente" ) );
@piezas = sort @{$tipojuego->describe->{piezas}};
$i = 0;
foreach( qw{ gema } ){
    ok( $piezas[$i] eq $_, "Pieza $i es $_" );   
    $i ++;
}
ok(  keys( %{$tipojuego->describe->{casilleros}} ) eq  169 ,    13 * 13 . " casilleros" );
