%Base de conocimiento:
jugador(stuart, [piedra, piedra, piedra, piedra, piedra, piedra, piedra, piedra], 3).
jugador(tim, [madera, madera, madera, madera, madera, pan, carbon, carbon, carbon, pollo, pollo], 8).
jugador(steve, [madera, carbon, carbon, diamante, panceta, panceta, panceta], 2).

lugar(playa, [stuart, tim], 2).
lugar(mina, [steve], 8).
lugar(bosque, [], 6).

comestible(pan).
comestible(panceta).
comestible(pollo).
comestible(pescado).

%Punto 1:
%a)
tieneItem(Jugador, Item):-
        jugador(Jugador,Items,_),
        member(Item,Items).

%b)
sePreocupaPorSuSalud(Jugador):-
    tieneItemComestible(Jugador,ItemComestible),
    tieneItemComestible(Jugador,OtroItemComestible),
    ItemComestible \= OtroItemComestible.

tieneItemComestible(Jugador, Item):-
    tieneItem(Jugador,Item),
    comestible(Item).

%c)
cantidadDeItem(Jugador, Item, Cantidad):-
    tieneItem(_,Item),
    jugador(Jugador,_,_),
    cantidadItem(Jugador,Item,Cantidad).


cantidadItem(Jugador,Item,Cantidad):-
    findall(Item,tieneItem(Jugador,Item),Items),
    length(Items,Cantidad).

%d)
tieneMasDe(Jugador,Item):-
    cantidadDeItem(Jugador,Item, Cantidad),
    forall(jugador(OtroJugador,_,_), menorCantidadDe(OtroJugador,Item,Cantidad)).

menorCantidadDe(Jugador, Item, LimiteSuperior):-
    cantidadDeItem(Jugador, Item, Cantidad),
    Cantidad =< LimiteSuperior.

