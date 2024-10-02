%%%% Knowledge Representation %%%%
% Author: Rodrigo S. Cortez Madrigal

% Class Structure

class(top).
class(_, _, _, _, _).
%class(ClassName, ParentClass, PropertyList, RelationList, ObjectList).
%[id=>ObjectName, PropertyList, RelationList].

%% Prolog Built-in Predicates

% findall: Sirve para encontrar todas las soluciones de una consulta.
% member: Sirve para comprobar si un elemento pertenece a una lista.
% append: Sirve para concatenar listas.
% select: Sirve para eliminar un elemento de una lista.
% exclude: Sirve para eliminar elementos de una lista que cumplan una condición.

%% 1. Predicados para Consultar

% A. Extensión de una clase
% El conjunto de todos los objetos que pertenecen a la misma, ya sea  porque  se  declaren  directamente o por herencia.

class_extension(ClassName, KnowledgeBase, Extensions) :-
    findall(Object, (
        % Objetos de la clase
        member(class(ClassName, _, _, _, Objects), KnowledgeBase),
        member([id=>Object, _, _], Objects)
    ), ClassObjects),
    findall(SubObject, (
        % Objetos de las subclases
        member(class(SubClassName, ClassName, _, _, SubObjects), KnowledgeBase),
        member([id=>SubObject, _, _], SubObjects)
    ), SubClassObjects),
    append(ClassObjects, SubClassObjects, Extensions).

% B. Extensión de una propiedad
% El conjunto de todos los objetos que tienen una propiedad específica.

% D. Clases de un individuo
% El conjunto de todas las clases a las que pertenece un objeto.

classes_of_individual(Individual, KnowledgeBase, Classes) :-
    findall(Class, (
        member(class(Class, _, _, _, IndividualList), KnowledgeBase),
        member([id=>Individual, _, _], IndividualList)
    ), Classes).

%% Main

main :-
    KnowledgeBase = [
        class(top, none, [], [], []),
        class(animales, top, [], [], []),
        class(plantas, top, [], [], []),
        class(orquidae, plantas, [], [not(bailan), 0], []),
        class(aves, animales, [[vuelan, 0], [not(nadan), 0]], [], []),  
        class(peces, animales, [[nadan, 0], [not(bailan), 0]], [],
            [
            [id=>nemo, [], []]
            ]), 
        class(mamiferos, animales, [[not(oviparos), 0]], [], []),
        class(aguilas, aves, [], [[comen=>peces, 0]],
            [
            [id=>pedro, [[tam=>grande, 0]], [[not(amigo=>arturo), 0]]]
            ]),
        class(pinguino, aves, [[not(vuelan), 0], [nadan, 0]], [],
            [
            [id=>arturo, [[listo, 0]], [[amigo=>pedro, 0]]]
            ]),
        class(ornitorrincos, mamiferos, [[oviparos, 0]], [], [])
    ],
    class_extension(animales, KnowledgeBase, AnimalExtension),
    format('Extension de la clase animales: ~w~n', [AnimalExtension]),
    classes_of_individual(pedro, KnowledgeBase, PedroClasses),
    format('Clases de Pedro: ~w~n', [PedroClasses]),
    halt.