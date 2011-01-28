
use Test::More tests => 11;
BEGIN { use_ok('QGames') };

ok( my $tipojuego = QGames::open( "Ajedrez" ) );
ok(  $tipojuego->describe->{colores}->[0]->{nombre} eq "blanco", "Es blanco" );
ok( !$tipojuego->describe->{colores}->[0]->{rotado}            , "Blanco no rota" );
ok(  $tipojuego->describe->{colores}->[1]->{nombre} eq "negro" , "Es negro" );
ok(  $tipojuego->describe->{colores}->[1]->{rotado}            , "Negro rota" );

ok(  $tipojuego = QGames::open( "AfricaUniversity" ) );
ok(  $tipojuego->describe->{colores}->[0]->{nombre} eq "rojo"  , "Es rojo" );
ok( !$tipojuego->describe->{colores}->[0]->{rotado}            , "Blanco no rota" );
ok(  $tipojuego->describe->{colores}->[1]->{nombre} eq "negro" , "Es negro" );
ok( !$tipojuego->describe->{colores}->[1]->{rotado}            , "Negro no rota" );
