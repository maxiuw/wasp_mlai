:- use_module(library(apply)).
:- use_module(library(lists)).
0.2::cheater.
1.0::coin(tails); 0.0::coin(heads) :- cheater.
0.5::coin(tails); 0.5::coin(heads) :- \+cheater.
rank(jack,10).
rank(queen,11).
rank(king,12).
rank(ace,13).
0.25::card(player1,N,jack); 0.25::card(player1,N,queen); 0.25::card(player1,N,king); 0.25::card(player1,N,ace).
0.25::card(player2,N,jack); 0.25::card(player2,N,queen); 0.25::card(player2,N,king); 0.25::card(player2,N,ace) :- \+cheater.
0.0::card(player2,N,jack); 0.25::card(player2,N,queen); 0.25::card(player2,N,king); 0.5::card(player2,N,ace) :- cheater.
hand(Cards,straight) :- member(jack,Cards), member(queen,Cards), member(king,Cards), member(ace,Cards).
hand(Cards,pair(Rank)) :- select(Rank,Cards,Cards2), member(Rank,Cards2), rank(Rank,_).
hand(Cards,two_pair(Rank1,Rank2)) :- select(Rank1,Cards,Cards2), member(Rank1,Cards2), select(Rank2,Cards2,Cards3), member(Rank2,Cards3), rank(Rank1,_), rank(Rank2,_).
hand(Cards,threeofakind(Rank)) :- select(Rank,Cards,Cards2), member(Rank,Cards2), select(Rank,Cards2,Cards3), member(Rank,Cards3), rank(Ran1,_).
hand(Cards,highcard(Rank)) :- select(Rank,Cards,_), rank(Rank,_).
max2(X,Y,Max) :- X>Y, Max is X.
max2(X,Y,Max) :- X=<Y, Max is Y.
low2(X,Y,Low) :- X>Y, Low is Y.
low2(X,Y,Low) :- X=<Y, Low is X.
better(pair(Rank1),pair(Rank2)) :- rank(Rank1,N1), rank(Rank2,N2), N1>N2.
better(two_pair(Rank1a,Rank1b),two_pair(Rank2a,Rank2b)) :- rank(Rank1a,N1a), rank(Rank1b,N1b), rank(Rank2a,N2a), rank(Rank2b,N2b), max2(N1a,N1b,MaxN1), max2(N2a,N2b,MaxN2), low2(N1a,N1b,LowN1), low2(N2a,N2b,LowN2), (MaxN1>MaxN2; MaxN1=:=MaxN2, LowN1>LowN2).
better(threeofakind(Rank1),threeofakind(Rank2)) :- rank(Rank1,N1), rank(Rank2,N2), N1>N2.
better(straight(Rank1),straight(Rank2)) :- rank(Rank1,N1), rank(Rank2,N2), N1>N2.
better(highcard(Rank1),highcard(Rank2)) :- rank(Rank1,N1), rank(Rank2,N2), N1>N2.
better(straight(_),tris(_)).
better(straight(_),two_pair(_,_)).
better(straight(_),pair(_)).
better(straight(_),highcard(_)).
better(threeofakind(_),two_pair(_,_)).
better(threeofakind(_),pair(_)).
better(threeofakind(_),highcard(_)).
better(two_pair(_,_),pair(_)).
better(two_pair(_,_),highcard(_)).
better(pair(_),highcard(_)).
draw_hand(Player,Hand) :- maplist(card(Player),[1, 2, 3, 4],Hand).
game_outcome(Cards1,Cards2,Outcome) :- best_hand(Cards1,Hand1), best_hand(Cards2,Hand2), outcome(Hand1,Hand2,Outcome).
best_hand(Cards,Hand) :- hand(Cards,Hand), \+(hand(Cards,Hand2), better(Hand2,Hand)).
outcome(Hand1,Hand2,player1) :- better(Hand1,Hand2).
outcome(Hand1,Hand2,player2) :- better(Hand2,Hand1).
outcome(Hand1,Hand2,player1) :- \+better(Hand1,Hand2), \+better(Hand2,Hand1), coin(heads).
outcome(Hand1,Hand2,player2) :- \+better(Hand1,Hand2), \+better(Hand2,Hand1), coin(tails).
winner(1) :- game_outcome(Cards1,Cards2,player1).
winner(2) :- game_outcome(Cards1,Cards2,player2).
0.62128756589575::winner(1).
