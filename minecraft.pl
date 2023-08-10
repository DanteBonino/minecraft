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

%Punto 2:
%a)
hayMonstruos(Lugar):-
    lugar(Lugar,_,NivelOscuridad),
    NivelOscuridad > 6.

%b)
correPeligro(Jugador):-
    seEncuentraDondeLosMonstruos(Jugador).
correPeligro(Jugador):-
    estaHambriento(Jugador),
    not(tieneItemComestible(Jugador,_)).

seEncuentraDondeLosMonstruos(Jugador):-
    hayMonstruos(Lugar),
    personaEnLugar(Lugar,Jugador).

personasEnLugar(Lugar,Personas):-
    lugar(Lugar,Personas,_).

estaHambriento(Jugador):-
    nivelDeHambre(Jugador,Hambre),
    Hambre < 4.

nivelDeHambre(Jugador, Hambre):-
    jugador(Jugador,_,Hambre).

%c)
peligrosidadLugar(Lugar,0):-
    inhabitado(Lugar).
peligrosidadLugar(Lugar,Peligrosidad):-
    lugar(Lugar,_,_),
    not(inhabitado(Lugar)),
    peligrosidadLugarHabitado(Lugar,Peligrosidad).

inhabitado(Lugar):-
    personasEnLugar(Lugar,[]).

peligrosidadLugarHabitado(Lugar,100):-
    hayMonstruos(Lugar).
peligrosidadLugarHabitado(Lugar,Peligrosidad):-
    not(hayMonstruos(Lugar)),
    porcentajeDeHambrientos(Lugar,Peligrosidad).

porcentajeDeHambrientos(Lugar,Porcentaje):-
    cantidadHambrientos(Lugar,CantidadHambrientos),
    cantidadPersonas(Lugar,Cantidad),
    Porcentaje is (CantidadHambrientos * 100) / Cantidad.

cantidadHambrientos(Lugar,Cantidad):-
    findall(Hambriento, personaHambrientaEn(Lugar,Hambriento), Hambrientos),
    length(Hambrientos,Cantidad).

personaEnLugar(Lugar,Persona):-
    personasEnLugar(Lugar,Personas),
    member(Persona,Personas).

personaHambrientaEn(Lugar,Hambriento):-
    personaEnLugar(Lugar,Hambriento),
    estaHambriento(Hambriento).

cantidadPersonas(Lugar,Cantidad):-
    personasEnLugar(Lugar,Personas),
    length(Personas,Cantidad).

%Punto 3:
item(horno, [ itemSimple(piedra, 8) ]).
item(placaDeMadera, [ itemSimple(madera, 1) ]).
item(palo, [ itemCompuesto(placaDeMadera) ]).
item(antorcha, [ itemCompuesto(palo), itemSimple(carbon, 1) ]).


puedeConstruir(Item,Jugador):-
    item(Item,ElementosNecesarios),
    jugador(Jugador,_,_),
    forall(member(ElementoNecesario,ElementosNecesarios), tieneElementoNecesario(Jugador, ElementoNecesario)).

tieneElementoNecesario(Jugador,itemCompuesto(Item)):-
    tieneItem(Jugador,Item).
tieneElementoNecesario(Jugador, itemSimple(Item, Cantidad)):-
    cantidadDeItem(Jugador,Item,CantidadQueTiene),
    CantidadQueTiene >= Cantidad.
