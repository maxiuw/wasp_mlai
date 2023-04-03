:- use_module(library(lists)).
% :- use_module(library(random)).

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

%% hand ranks 
hand_ranking(straight, 5).
hand_ranking(three_of_a_kind, 4).
hand_ranking(two_pair, 3).
hand_ranking(one_pair, 2).
hand_ranking(high_card, 1).

% Compare the ranks of two cards
higher_rank(C1, C2) :-
    rank(C1, R1),
    rank(C2, R2),
    R1 > R2.

% cards drawing
% draw_hand(Hand) :-
%     cards(C),
%     length(Hand, 5),
%     select_uniform(Hand, C, _Rest).

%% specify the combinations 

%%% 
% select(Rank, Cards, Cards2) removes Rank from Cards and returns the remaining elements as Cards2.
%member(Rank, Cards2) checks if Rank is a member of Cards2.
% rank checks the rank of the car
%% Define the hand types

hand(Cards, pair(Rank)) :-
    select(Rank, Cards, Cards2),
    member(Rank, Cards2),
    rank(Rank, _).

hand(Cards, two_pair(Rank1, Rank2)) :-
    select(Rank1, Cards, Cards1),
    select(Rank2, Cards1, Cards2),
    (member(Rank1, Cards2); member(Rank2, Cards2)),
    rank(Rank1, _),
    rank(Rank2, _),
    Rank1 \= Rank2.

hand(Cards, three_of_a_kind(Rank)) :-
    select(Rank, Cards, Cards2),
    select(Rank, Cards2, Cards3),
    rank(Rank, _).

hand(Cards, straight(Rank)) :-
    select(Rank, Cards, Cards2),
    rank(Rank, N),
    M is N + 1,
    select(_, Cards2, Cards3),
    rank(_, M),
    select(_, Cards3, Cards4),
    rank(_, M),
    select(_, Cards4, Cards5),
    rank(_, M).

hand(Cards, high_card(Rank)) :-
    select(Rank, Cards, _),
    rank(Rank, _).


best_hand(Cards, BestRank) :-
    findall(Rank, hand(Cards, Rank), Ranks),
    max_list(Ranks, BestRank).


%% Define the ranking of hands

better(pair(Rank1), pair(Rank2)) :-
    rank(Rank1, N1),
    rank(Rank2, N2),
    N1 > N2.

better(two_pair(Rank1a, Rank1b), two_pair(Rank2a, Rank2b)) :-
    rank(Rank1a, N1a),
    rank(Rank1b, N1b),
    rank(Rank2a, N2a),
    rank(Rank2b, N2b),
    ((N1a > N2a); (N1a =:= N2a, N1b > N2b)).

better(three_of_a_kind(Rank1), three_of_a_kind(Rank2)) :-
    rank(Rank1, N1),
    rank(Rank2, N2),
    N1 > N2.

better(straight(Rank1), straight(Rank2)) :-
    rank(Rank1, N1),
    rank(Rank2, N2),
    N1 > N2.

better(high_card(Rank1), high_card(Rank2)) :-
    rank(Rank1, N1),
    rank(Rank2, N2),
    N1 > N2.

% implement better for the other hand types




%%%% Provided code


game_outcome(Cards1,Cards2,Outcome) :-
    best_hand(Cards1,Hand1),
    best_hand(Cards2,Hand2),
    outcome(Hand1,Hand2,Outcome).

outcome(Hand1,Hand2,player1) :- better(Hand1,Hand2).
outcome(Hand1,Hand2,player2) :- better(Hand2,Hand1).
outcome(Hand1,Hand2,tie) :- \+better(Hand1,Hand2), \+better(Hand2,Hand1).

%% Define the best hand for a given set of cards

% best_hand(Cards,Hand) :-
%      hand(Cards,Hand),
%      \+ (hand(Cards,Hand2), better(Hand2,Hand)).
    
%% tests 
% query(game_outcome([a,a,3,4,5], [j,j,6,7,8], Outcome)).%, writeln(Outcome).
% draw(Hand).
% query(best_hand([j, k, q, q, 1], HandRank)).
% best_hand(draw(Hand), HandRank).
% best_hand([j, j, q, q, k], HandRank) :- HandRank = full_house.
% query(best_hand([2, 3, 4, 6, 6], HandRank)).


