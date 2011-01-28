
use Test::More tests => 23;
BEGIN { use_ok('QGames') };

ok( my $tipojuego = QGames::open( "Ajedrez" ) );
ok(  $tipojuego->describe->{colores}->[0]->{nombre} eq "blanco", "Es blanco" );
ok( !$tipojuego->describe->{colores}->[0]->{rotado}            , "Blanco no rota" );
ok(  $tipojuego->describe->{colores}->[1]->{nombre} eq "negro" , "Es negro" );
ok(  $tipojuego->describe->{colores}->[1]->{rotado}            , "Negro rota" );
my @piezas = sort @{$tipojuego->describe->{piezas}};
my $i = 0;
foreach( qw{ alfil caballo dama peon rey torre } ){
    ok( $piezas[$i] eq $_, "Pieza $i es $_" );   
    $i ++;
}
ok(  keys( %{$tipojuego->describe->{casilleros}} ) eq  64 ,     "64 casilleros" );

ok(  $tipojuego = QGames::open( "AfricaUniversity" ) );
ok(  $tipojuego->describe->{colores}->[0]->{nombre} eq "rojo"  , "Es rojo" );
ok( !$tipojuego->describe->{colores}->[0]->{rotado}            , "Blanco no rota" );
ok(  $tipojuego->describe->{colores}->[1]->{nombre} eq "negro" , "Es negro" );
ok( !$tipojuego->describe->{colores}->[1]->{rotado}            , "Negro no rota" );
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
