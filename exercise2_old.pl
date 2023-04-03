% Your model here
%%%% Implement the following predicates.
:- use_module(library(lists)).
maplist(_, [], []).
maplist(Pred, [X|Xs], [Y|Ys]) :-
    call(Pred, X, Y),
    maplist(Pred, Xs, Ys).
cards([2, 3, 4, 5, 6, 7, 8, 9, 10, jack, queen, king, ace]).
%% Define the ranks
rank(2, 1).
rank(3, 2).
rank(4, 3).
rank(5, 4).
rank(6, 5).
rank(7, 6).
rank(8, 7).
rank(9, 8).
rank(10, 9).
rank(jack, 10).
rank(queen, 11).
rank(king, 12).
rank(ace, 13).

% Example for pair
hand(Cards,pair(Rank)) :-
    select(Rank,Cards,Cards2),
    member(Rank,Cards2),
    rank(Rank,_).
% Example double pair
hand(Cards, two_pair(Rank1,Rank2)) :-
    select(Rank1, Cards, Cards2),
    member(Rank1, Cards2),
    select(Rank2, Cards2, Cards3),
    member(Rank2, Cards3),
    rank(Rank1, _ ),
    rank(Rank2, _ ).
% Tris
hand(Cards, tris(Rank)) :-
    select(Rank, Cards, Cards2),
    member(Rank, Cards2),
    select(Rank, Cards2, Cards3),
    member(Rank, Cards3),
    rank(Ran1, _ ).
% Straight
hand(Cards, straight(Rank)) :-
    sort(Cards, Sorted),
    maplist(rank, Sorted, Ranks),
    consecutive(Ranks, Rank).
consecutive([H1,H2,H3,H4,H5], N) :- rank(H1,N1), rank(H2,N2), rank(H3,N3), rank(H4,N4), rank(H5,N5),
    ( N2 =:= N1 + 1, N3 =:= N2 + 1, N4 =:= N3 + 1, N5 =:= N4 + 1
    ; N1 =:= 1, N2 =:= 10, N3 =:= 11, N4 =:= 12, N5 =:= 13, N = 5
    ).
consecutive([_|T], N) :-
    consecutive(T, N).
%% Define the ranking of hands
better(pair(Rank1), pair(Rank2)) :-
    rank(Rank1, N1),
    rank(Rank2, N2),
    N1 > N2.
max2(X, Y, Max) :-
    X > Y,
    Max is X.
max2(X, Y, Max) :-
    X =< Y,
    Max is Y.
low2(X, Y, Low) :-
    X > Y,
    Low is Y.
low2(X, Y, Low) :-
    X =< Y,
    Low is X.
better(two_pair(Rank1a, Rank1b), two_pair(Rank2a, Rank2b)) :-
    rank(Rank1a, N1a),
    rank(Rank1b, N1b),
    rank(Rank2a, N2a),
    rank(Rank2b, N2b),
    max2(N1a, N1b, MaxN1),
    max2(N2a, N2b, MaxN2),
    low2(N1a, N1b, LowN1),
    low2(N2a, N2b, LowN2),
    ((MaxN1 > MaxN2); (MaxN1 =:= MaxN2, LowN1 > LowN2)).
better(tris(Rank1),tris(Rank2)) :-
    rank(Rank1, N1),
    rank(Rank2, N2),
    (N1 > N2).
% Compare two straight hands
better(straight(Rank1), straight(Rank2)) :-
    rank(Rank1, N1),
    rank(Rank2, N2),
    N1 > N2.
better(high_card(Rank1), high_card(Rank2)) :-
    rank(Rank1, N1),
    rank(Rank2, N2),
    N1 > N2.
better(straight(_), tris(_)).
better(straight(_), two_pair(_,_)).
better(straight(_), pair(_)).
better(straight(_), high_card(_)).
better(tris(_), two_pair(_,_)).
better(tris(_), pair(_)).
better(tris(_), high_card(_)).
better(two_pair(_,_), pair(_)).
better(two_pair(_,_), high_card(_)).
%%%% Provided code
game_outcome(Cards1,Cards2,Outcome) :-
    best_hand(Cards1,Hand1),
    best_hand(Cards2,Hand2),
    outcome(Hand1,Hand2,Outcome).
outcome(Hand1,Hand2,player1) :- better(Hand1,Hand2).
outcome(Hand1,Hand2,player2) :- better(Hand2,Hand1).
outcome(Hand1,Hand2,tie) :- \+better(Hand1,Hand2), \+better(Hand2,Hand1).
best_hand(Cards,Hand) :-
    hand(Cards,Hand),
    \+ (hand(Cards,Hand2), better(Hand2,Hand)).
%query(game_outcome([ace,queen,2,9,10],[5,4,6,7,8],player1)).
query(game_outcome([king,queen,6,9,10],[5,5,6,7,8],player1)).
query(hand([king,queen,6,9,10], straight(9))).
query(best_hand([king,queen,6,9,10], Hand)).