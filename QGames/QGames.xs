#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"
#include  <qgames.h>

#include "ppport.h"
typedef Tipojuego* QGames_Tipojuego;
typedef Partida* QGames_Partida;

#define  hv_store_str( hash, key, str ) hv_store( hash, key, sizeof( key ) - 1, newSVpv( str, strlen( str ) ), 0 )

static HV* generate_hash_movida( Partida* par, Movdata movdat ){
    HV* hashmov = newHV();
    sv_2mortal((SV*)hashmov);
    hv_store( hashmov, "numero", 6, newSViv( movdat.numero ), 0 );
    hv_store_str( hashmov, "descripcion", movdat.descripcion );
    hv_store_str( hashmov, "notacion", movdat.notacion );
    hv_store_str( hashmov, "pieza", movdat.pieza );
    hv_store_str( hashmov, "color", movdat.color );
    if( movdat.origen )
        hv_store_str( hashmov, "origen", movdat.origen );
    hv_store_str( hashmov, "destino", movdat.destino );

    if( movdat.captura ){
        AV* arrcap = newAV();
        sv_2mortal( (SV*) arrcap );
        while(1){
            HV* hashcap = newHV();
            sv_2mortal( (SV*)hashcap );
            hv_store_str( hashcap, "captura_pieza", movdat.captura_pieza );
            hv_store_str( hashcap, "captura_casillero", movdat.captura_casillero );
            hv_store_str( hashcap, "captura_color", movdat.captura_color );
            av_push( arrcap, newRV((SV*)hashcap) );
            if( !qg_partida_movdata_nextcap( par, &movdat ) ) break;
        }
        hv_store( hashmov, "captura", 7, newRV( (SV*)arrcap ), 0 );
    }

    if( movdat.movida > 1 ){
        AV* arrmov = newAV();
        sv_2mortal( (SV*) arrmov );
        qg_partida_movdata_nextmov( par, &movdat );
        while(1){
            HV* hashmmm = newHV();
            sv_2mortal( (SV*)hashmmm );
            hv_store_str( hashmmm, "movida_pieza", movdat.movida_pieza );
            if( movdat.movida_origen )
                hv_store_str( hashmmm, "movida_origen", movdat.movida_origen );
            if( movdat.movida_destino )
                hv_store_str( hashmmm, "movida_destino", movdat.movida_destino );
            if( movdat.movida_color )
                hv_store_str( hashmmm, "movida_color", movdat.movida_color );
            
            av_push( arrmov, newRV((SV*)hashmmm) );
            if( !qg_partida_movdata_nextmov( par, &movdat ) ) break;
        }
        hv_store( hashmov, "movida", 6, newRV((SV*)arrmov), 0 );
    }

    if( movdat.transforma ){
        AV* arrtra = newAV();
        sv_2mortal( (SV*) arrtra );
        while(1){
            HV* hashtra = newHV();
            sv_2mortal( (SV*)hashtra );
            hv_store_str( hashtra, "transforma_pieza", movdat.transforma_pieza );
            hv_store_str( hashtra, "transforma_color", movdat.transforma_color );
            av_push( arrtra, newRV((SV*)hashtra) );
            if( !qg_partida_movdata_nexttran( par, &movdat ) ) break;
        }
        hv_store( hashmov, "transforma", 10, newRV( (SV*)arrtra ), 0 );
    }

    if( movdat.crea ){
        AV* arrcre = newAV();
        sv_2mortal( (SV*) arrcre );
        while(1){
            HV* hashcre = newHV();
            sv_2mortal( (SV*)hashcre );
            hv_store_str( hashcre, "crea_pieza", movdat.crea_pieza );
            hv_store_str( hashcre, "crea_color", movdat.crea_color );
            hv_store_str( hashcre, "crea_casillero", movdat.crea_casillero );
            av_push( arrcre, newRV((SV*)hashcre) );
            if( !qg_partida_movdata_nextcrea( par, &movdat ) ) break;
        }
        hv_store( hashmov, "crea", 4, newRV( (SV*)arrcre ), 0 );
    }

    return hashmov;
}



MODULE = QGames		PACKAGE = QGames		

void
set_path(path)
        char* path
    CODE:
        qg_path_set( path );

const char*
get_path()
    CODE:
        RETVAL = qg_path_games();
    OUTPUT:
        RETVAL


QGames_Tipojuego
open(juego)
        char* juego
    CODE:
        RETVAL = qg_tipojuego_open( juego );
    OUTPUT:
        RETVAL


MODULE = QGames		PACKAGE = QGames::Tipojuego  PREFIX = tjuego_

QGames_Partida
tjuego_crea(tj,id=NULL)
        QGames_Tipojuego tj
        char* id
    CODE:
        RETVAL = qg_tipojuego_create_partida( tj, id );
    OUTPUT:
        RETVAL

QGames_Partida
tjuego_load(tj, bin)
        QGames_Tipojuego tj
        SV* bin
    CODE:
        STRLEN len;
        char* dat;
        dat = SvPV( bin, len );
        RETVAL = qg_partida_load( tj, (void*)dat, len );
    OUTPUT:
        RETVAL

HV*
tjuego_describe(tj)
        QGames_Tipojuego tj
    CODE:
        RETVAL = newHV();
        sv_2mortal((SV*)RETVAL);
        {
            AV* arrcol = newAV();
            int i = 1; const char* color ;
            while( color = qg_tipojuego_info_color( tj, i ) ){
                HV* hashcol = newHV();
                hv_store_str( hashcol, "nombre", color );
                if( qg_tipojuego_info_color_rotado( tj, i ) ) {
                    hv_store( hashcol, "rotado", 6, newSViv( 1 ), 0 );
                }
                av_push( arrcol, newRV( (SV*)hashcol ) );
                i ++;
            }
            hv_store( RETVAL, "colores", 7, newRV((SV*)arrcol), 0 );
        }
        {
            AV* arrpie = newAV();
            int i = 1; const char* tpieza;
            while( tpieza = qg_tipojuego_info_tpieza( tj, i ) ){
                av_push( arrpie, newSVpv( tpieza, strlen( tpieza ) ) );
                i ++;
            }
            hv_store( RETVAL, "piezas", 6, newRV((SV*)arrpie), 0 );
        }
    OUTPUT:
        RETVAL


MODULE = QGames		PACKAGE = QGames::Partida  PREFIX = partida_

void
partida_DESTROY(par)
        QGames_Partida par
    CODE:
        printf( "Destroying partida %s\n", qg_partida_id( par ) );
        qg_partida_free( par );

char*
partida_id(par)
        QGames_Partida par
    CODE:
        RETVAL = qg_partida_id( par );
    OUTPUT:
        RETVAL


AV*
partida_posibles(par)
        QGames_Partida par
    CODE:
        int movnum = 0;
        Movdata movdat;
        RETVAL = newAV();
        sv_2mortal((SV*)RETVAL);
        while( qg_partida_movidas_data( par, movnum, &movdat ) ){
            av_push( RETVAL, newRV( (SV*)generate_hash_movida(par, movdat) ) );
            movnum ++;
        }
    OUTPUT:
        RETVAL

AV*
partida_historial(par)
        QGames_Partida par
    CODE:
        int movnum = 0;
        Movdata movdat;
        RETVAL = newAV();
        sv_2mortal((SV*)RETVAL);
        while( qg_partida_movhist_data( par, movnum, &movdat ) ){
            av_push( RETVAL, newRV( (SV*)generate_hash_movida(par, movdat) ) );
            movnum ++;
        }
    OUTPUT:
        RETVAL


int
partida_mover(par, mov)
        QGames_Partida par
        SV*  mov
    CODE:
        STRLEN len;
        char* ptrmov;
        if( SvIOK( mov )) {
            RETVAL = qg_partida_mover( par, SvIV( mov ) );
            if( !RETVAL )
                croak( "Error movimiento incorrecto %d", SvIV(mov) );
        } else {
            ptrmov = SvPV( mov, len );
            if( ptrmov ){
                RETVAL = qg_partida_mover_notacion( par, ptrmov );
                if( !RETVAL )
                    croak( "Error movimiento incorrecto %s", ptrmov );
            } else {
                croak( "Error movimiento incorrecto" );
            }
        }
    OUTPUT:
        RETVAL


AV*
partida_tablero(par)
        QGames_Partida par
    CODE:
        RETVAL = newAV();
        sv_2mortal((SV*)RETVAL);
        int pie = qg_partida_tablero_count( par, LAST_MOVE );
        int cap = qg_partida_tablero_countcap( par, LAST_MOVE );
        int i;
        for( i = 0; i < pie; i ++ ){
            char* casillero; char* tipo; char* color;
            qg_partida_tablero_data( par, LAST_MOVE, i, &casillero, &tipo, &color );
            HV* hashpie = newHV();
            sv_2mortal( (SV*)hashpie );
            hv_store_str( hashpie, "pieza", tipo );
            hv_store_str( hashpie, "casillero", casillero );
            hv_store_str( hashpie, "color", color );
            av_push( RETVAL, newRV((SV*)hashpie) );
        }
        for( i = 0; i < cap; i ++ ){
            char* tipo; char* color;
            qg_partida_tablero_datacap( par, LAST_MOVE, i, &tipo, &color );
            HV* hashpie = newHV();
            sv_2mortal( (SV*)hashpie );
            hv_store_str( hashpie, "pieza", tipo );
            hv_store_str( hashpie, "casillero", ":captured" );
            hv_store_str( hashpie, "color", color );
            av_push( RETVAL, newRV((SV*)hashpie) );
        }
    OUTPUT:
        RETVAL

const char*
partida_color(par)
        QGames_Partida par
    CODE:
        RETVAL = qg_partida_color( par );
    OUTPUT:
        RETVAL


int
partida_movidas_count(par)
        QGames_Partida par
    CODE:
        RETVAL = qg_partida_movhist_count( par );
    OUTPUT:
        RETVAL

char*
partida_estado(par)
        QGames_Partida par
    CODE:
        char* res;
        qg_partida_final( par, &res );
        RETVAL = res ? res : "Jugando";
    OUTPUT:
        RETVAL


SV*
partida_dump(par)
        QGames_Partida par
    CODE:
        void* dat; int len;
        if( !qg_partida_dump( par, &dat, &len ) ){
            croak( "Error en dump de partida" );
            RETVAL = newSViv( 0 );
        } else {
            RETVAL = newSVpv( (char*) dat, len );
        };
    OUTPUT:
        RETVAL

