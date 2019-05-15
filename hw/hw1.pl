% 1. domácí úloha
%
% a) Implementujte logaritmus o základu 2 (dolní celou část) na unárně
% reprezentovaných číslech.
%
% logtwo(+N, ?Vysledek)
%
% Nápověda: Může se vám hodit pomocný predikát pro půlení.
%
% logtwo(0, R).
% false.
%
% logtwo(s(s(s(0))), R).
% R = s(0).
%
% logtwo(s(s(s(s(0)))), R).
% R = s(s(0)).
%
% b) Implementujte predikát, který spočte n-té Fibonacciho číslo lépe než
% v exponenciálním čase (ideálně pouze lineárně mnoho sčítání).
%
% fib(+N, ?Vysledek)
%
% Nápověda: Zkuste nejdřív implementovat obecnější predikát, kde si můžete
% zvolit počáteční čísla.
%
% F_0 = 4
% F_1 = 5
% F_2 = 4 + 5 = 9
% F_3 = 5 + 9 = 14
%
% generalizedFib(3, 4, 5, R).
% R = 14.
%
%
% c) (BONUSOVÁ ÚLOHA) Implementuje predikát pro sčítání dvou binárních čísel.
%
% Můžete použít např. následující reprezentaci:
%
% 13[dec] = 1101[bin] = b(1, b(0, b(1, b(1, e))))
%
% Příklad použití:
% addBin(b(1, b(0, b(1, e))), b(1, b(1, b(0, b(1, e)))), R).
% R = b(0, b(0, b(0, b(0, b(1, e))))).
%
% resp.
%
% addBin([1, 0, 1], [1, 1, 0, 1], R).
% R = [0, 0, 0, 0, 1].

toNat(N, R) :-
  integer(N),
  toNat_(N, R).

toNat_(N, R) :- N > 0 ->
  (N2 is N - 1, toNat_(N2, R2), R = s(R2));
  R = 0.

fromNat(0, 0).
fromNat(s(N), R) :-
  fromNat(N, R2),
  R is R2 + 1.

nat(0).
nat(s(X)) :- nat(X).

add(0, Y, Y) :- nat(Y).
add(s(X), Y, s(Z)) :-
  add(X, Y, Z).

less(0, s(Y)) :- nat(Y).
less(s(X), s(Y)) :- less(X, Y).

% Moje řešení:

% Pomocné predikáty:
half(X, R) :- nat(X), add(R, R, X).
half(s(X), R) :- nat(X), add(R, R, X).


%f(0, 1, 3, R) -> f(1, 1, 2, R) -> f(1, 2, 1, R) -> f(2, 3, 0, R) -> add(2, 3, R) -> 5
% Mám formát: generalizedFib(PrvníČísloPosloupnosti, DruhéČísloPosloupnosti, KolikátéČísloChci, Výsledek).
% V zadání byl formát jiný... Posunul jsem první pozici na třetí. (Jednalo se jen o radu, takže na výsledku by to nemělo mít vliv)
% Sčítá jen N-krát neboli v O(N)
generalizedFib(X, Y, 0, R) :- nat(Y), nat(X), add(0, X, R).
generalizedFib(X, Y, s(0), R) :- nat(Y), nat(X), add(0, Y, R).
generalizedFib(X, Y, s(s(N)), R) :- nat(X), nat(Y), add(X, Y, Z), generalizedFib(Y, Z, s(N), R).

% a)
logtwo(s(0), 0).
logtwo(X, s(R)) :- nat(X), less(0, X), half(X, Y), logtwo(Y, R).

% tested: "toNat_(1024, R), logtwo(R, X), fromNat(X, Z)." Vyprodukovalo správný výsledek, stejně jako testovací data v zadání.

% b)
fib(0, 0).
fib(N, R) :- nat(N), generalizedFib(0, s(0), N, R).

% tested: "nat(N), fib(N, R), fromNat(N, Nty), fromNat(R, Vysledek)." produkuje fib. posloupnost
