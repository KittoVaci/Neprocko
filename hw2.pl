% 2. domácí úloha
%
% a) Implementujte predikát flat(+List, ?Result), který zploští libovolně
% zanořený seznam seznamů List.
%
% flat([], R).
% R = [].
%
% flat([[]], R).
% R = [].
%
% flat([a,b,c], R).
% R = [a,b,c].
%
% flat([a,[[],b,[]],[c,[d]]], R).
% R = [a,b,c,d].
%0

% Řešení testováno na všech výše zmíněných příkladech

% Přidáme si do našeho predikátu acumulátor
flat(L, Result) :-  
  flat(L, [], R0), 
    !, Result = R0. % Zajímá nás jen první výsledek
% Je li Na začátku seznamu Volná proměná tak si ji ponecháme a nebudeme se jí zbavovat
flat(X, Zbytek, [X|Zbytek]) :- var(X), !. 
% Je li na začátku seznamu prázdný seznam, máme výsledek a už nebudeme hledat jiná řešení
flat([], Result, Result) :- !.
% Vezmeme ze seznamu první prvek a ten sploštíme, pak sploštíme i zbytek a nakonec je spojíme
flat([X|Zbytek], Zbytek0, Result) :- !, flat(X, Zbytek1, Result), flat(Zbytek, Zbytek0, Zbytek1).
flat(Prvek, Zbytek, [Prvek|Zbytek]).



% Tento predikát měl být deterministický (speciálně otestujte, že po odmítnutí
% neprodukuje duplikátní/nesprávné výsledky). Pokuste se o efektivní
% implementaci pomocí akumulátoru.
%
% b) Implementuje predikát transp(+M, ?R), který transponuje matici M (uloženou
% jako seznam seznamů). Pokud M není ve správném formátu (např. řádky mají
% různé délky), dotaz transp(M, R) by měl selhat.
%
% transp([], R).
% R = [].
%
% transp([[],[],[]], R).
% R = [].
%
% transp([[a,b],[c,d],[e,f]], R).
% R = [[a,c,e],[b,d,f]].
%
% transp([[a],[b,c],[d]], R).
% false.

transp([], []) :- !.
transp([X|Zbytek], R) :- transp(X, [X|Zbytek], R).

% Řešení funguje jen na stejné matice, nebo na takové, kde na prvním řádku je více prvků než v jiném řádku (myšleno na: transp([[a,e],[b,c],[d]], R).)
% Snažil jsem se přidat kontrolování matice takto: transp([X|Zbytek], R) :- zkontrolujMatici([X|Zbytek]), transp(X, [X|Zbytek], R). Ale to mi nedopočítá.

zkontrolujMatici([]) :- !.
zkontrolujMatici([T|Zbytek]) :- zkontrolujMatici(T, Zbytek).
zkontrolujMatici(X, [H|Zbytek]) :- pocetPrvku(X, R0), pocetPrvku(H, R1), !, stejnyPocet(R0, R1), zkontrolujMatici(H, Zbytek).
pocetPrvku([], _).
pocetPrvku([_| T], s(R)) :- pocetPrvku(T, R).
stejnyPocet(0, 0).
stejnyPocet(s(A), s(B)) :- stejnyPocet(A,B). 

transp([], _, []).
transp([_|Zbytek], X, [Result0|Result1]) :-
  oddelPrvni(X, Result0, ResultM),
    transp(Zbytek, ResultM, Result1).

oddelPrvni([], [], []).
oddelPrvni([[Prvek|Zbytek]|ZbytekMatice], [Prvek|PridanoDo], [Zbytek|Result]) :- 
    oddelPrvni(ZbytekMatice, PridanoDo, Result).

%
% c) (BONUSOVÁ ÚLOHA) Implementuje vkládání prvku pro AVL stromy.
%
% Použijte následující reprezentaci:
% prázdný strom: nil
% uzel: t(B,L,X,R) kde
%   L je levý podstrom,
%   X je uložený prvek,
%   R je pravý podstrom,
%   B je informace o vyvážení:
%     B = l (levý podstrom je o 1 hlubší)
%     B = 0 (oba podstromy jsou stejně hluboké)
%     B = r (pravý podstrom je o 1 hlubší)
%
% avlInsert(+X, +T, -R)
% X je vkládané číslo, T je strom před přidáním, R je strom po přidání
%
% avlInsert(1, nil, R).
% R = t(0, nil, 1, nil).
%
% avlInsert(2, t(0, nil, 1, nil), R).
% R = t(r, nil, 1, t(0, nil, 2, nil)).
%
% avlInsert(1, t(0, nil, 1, nil), R).
% R = t(0, nil, 1, nil).