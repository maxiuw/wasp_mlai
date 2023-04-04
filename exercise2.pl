:- use_module(library(lists)).
:- use_module(library(apply)).

%% card deck
% Define the order of ranks
%% Define the cards in the deck

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

% hand ranks 
hand_ranking(straight, 5).
hand_ranking(threeofakind, 4).
hand_ranking(two_pair, 3).
hand_ranking(one_pair, 2).
hand_ranking(highcard, 1).

%% card combinations

% Straight

% hand(Cards, straight(X)) :-
%     permutation(Cards, [C1,C2,C3,C4,C5]),
%     rank(C1, R1), rank(C2, R2), rank(C3, R3), rank(C4, R4), rank(C5, R5),
%     R1+1 =:= R2, R2+1 =:= R3, R3+1 =:= R4, R4+1 =:= R5,
%     X is R5.

% hand(Cards, straight(X)) :-
%     permutation(Cards, [X1,X2,X3,X4,X5]),
%     rank(X1,R1),rank(X2,R2),rank(X3,R3),rank(X4,R4),rank(X5,R5),
%     (
%         R1+1 =:= R2, R2+1 =:= R3, R3+1 =:= R4, R4+1 =:= R5
%         ;
%         % handle special case where Ace is used as low card in a straight
%         X1 = ace, X2 = 5, X3 = 4, X4 = 3, X5 = 2
%     ).

% straight
hand(Cards, straight(Rank)) :-
    list_to_set(Cards, CardsSet),
    length(CardsSet, N),
    N >= 5,
    select(Rank, CardsSet, Cards2),
    rank(Rank, N0),
    (N1 is N0 + 1),
    select(Rank2, Cards2, Cards3),
    rank(Rank2,N2),
    (N2 =:= N1+1),
    select(Rank3, Cards3, Cards4),
    rank(Rank3, N3),
    (N3 =:= N2+1),
    select(Rank4, Cards4, Cards5),
    rank(Rank4, N4),
    (N4 =:= N3 +1).

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
hand(Cards, threeofakind(Rank)) :-
    select(Rank, Cards, Cards2),
    member(Rank, Cards2),
    select(Rank, Cards2, Cards3),
    member(Rank, Cards3),
    rank(Ran1, _ ).

% %% comparison function for card combinations



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


hand(Cards, highcard(Rank)) :-
    select(Rank, Cards, _),
    rank(Rank, _).


% check for better 

better(pair(Rank1), pair(Rank2)) :-
    rank(Rank1, N1),
    rank(Rank2, N2),
    N1 > N2.

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

better(threeofakind(Rank1), threeofakind(Rank2)) :-
    rank(Rank1, N1),
    rank(Rank2, N2),
    N1 > N2.

better(straight(Rank1), straight(Rank2)) :-
    rank(Rank1, N1),
    rank(Rank2, N2),
    N1 > N2.

better(highcard(Rank1), highcard(Rank2)) :-
    rank(Rank1, N1),
    rank(Rank2, N2),
    N1 > N2.

better(straight(_), tris(_)).
better(straight(_), two_pair(_,_)).
better(straight(_), pair(_)).
better(straight(_), highcard(_)).
better(threeofakind(_), two_pair(_,_)).
better(threeofakind(_), pair(_)).
better(threeofakind(_), highcard(_)).
better(two_pair(_,_), pair(_)).
better(two_pair(_,_), highcard(_)).
better(pair(_), highcard(_)).


% %% find the best combination for a given hand



%%%% Provided code

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

%% Define the best hand for a given set of cards

    
%% tests 
% query(best_hand([jack, king, ace],X)).
% query(best_hand([jack, king, jack, jack],X)).
% query(best_hand([queen, ace, king, jack],X)).
% query(game_outcome([jack, king, jack],[jack,king,king],X)).
% query(game_outcome([jack, jack, ace],[jack, king, jack],X)).
% query(best_hand([10,jack,queen,king,ace], X)).
% query(best_hand([jack, king, king], X)).
query(game_outcome([7,7,7,6,6],[7,7,7,4,4],X)).