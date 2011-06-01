
use Test::More tests => 30;
BEGIN { use_ok('QGames') };

ok( my $tipojuego = QGames::open( "Ajedrez" ) );
ok(  $tipojuego->describe->{c}->{blanco}              , "Esta el blanco" );
ok( !$tipojuego->describe->{c}->{blanco}->{rot}       , "Blanco no rota" );
ok(  $tipojuego->describe->{c}->{negro}               , "Esta el negro" );
ok(  $tipojuego->describe->{c}->{negro}->{rot}        , "negro si rota" );
is(  $tipojuego->describe->{name},   "Ajedrez"        , "El nombre es Ajedrez" );
my @piezas = sort @{$tipojuego->describe->{p}};
my $i = 0;
foreach( qw{ alfil caballo dama peon rey torre } ){
    ok( $piezas[$i] eq $_, "Pieza $i es $_" );   
    $i ++;
}
ok(  keys( %{$tipojuego->describe->{s}} ) eq  64 ,     "64 casilleros" );

my  $logo = $tipojuego->logo;
ok( $logo->{w} > 100, "Width" );
ok( $logo->{h} > 100, "Height" );
ok( $logo->{png} , "PNG" );

# Check name
is( $tipojuego->name, "Ajedrez",   "El nombre es ajedrez, que otro!" );
is( "$tipojuego", "Ajedrez",       "El nombre es ajedrez, que otro!" );


ok(  $tipojuego = QGames::open( "AfricaUniversity" ) );
ok( !$tipojuego->describe->{c}->{blanco}              , "No esta el blanco" );
ok(  $tipojuego->describe->{c}->{rojo}                , "Esta rojo" );
ok( !$tipojuego->describe->{c}->{rojo}->{rot}         , "rojo no rota" );
ok(  $tipojuego->describe->{c}->{negro}               , "Esta negro" );
ok( !$tipojuego->describe->{c}->{negro}->{rot}        , "negro no rota" );
@piezas = sort @{$tipojuego->describe->{p}};
$i = 0;
foreach( qw{ A U } ){
    ok( $piezas[$i] eq $_, "Pieza $i es $_" );   
    $i ++;
}

ok(  $tipojuego = QGames::open( "Pente" ) );
@piezas = sort @{$tipojuego->describe->{p}};
$i = 0;
foreach( qw{ gema } ){
    ok( $piezas[$i] eq $_, "Pieza $i es $_" );   
    $i ++;
}
ok(  keys( %{$tipojuego->describe->{s}} ) eq  169 ,    13 * 13 . " casilleros" );
1;
