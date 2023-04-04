%%%% The Problog program implementing the Bayesian network.
% t(_)::cheater.

0.2::cheater.

% ranks 
rank(jack, 10).
rank(queen, 11).
rank(king, 12).
rank(ace, 13).

% Rules
0.25::draw1(jack); 0.25::draw1(queen); 0.25::draw1(king); 0.25::draw1(ace). 
0.25::draw2(jack); 0.25::draw2(queen); 0.25::draw2(king); 0.25::draw2(ace) :- \+ cheater.

% If player 2 is cheating, replace jacks with aces
0.5::draw2(ace); 0.25::draw2(queen); 0.25::draw2(king); 0.0::draw2(jack) :- cheater.

% If player 2 is cheating, coin always comes up tails
1.0::coin(tails); 0.0::coin(heads) :- cheater.
0.5::coin(tails); 0.5::coin(heads) :- \+ cheater.

% Compute the highest card
highest(1) :- draw1(Card1), draw2(Card2), rank(Card1,Rank1),rank(Card2,Rank2), Rank1 > Rank2.
highest(2) :- draw1(Card1), draw2(Card2), rank(Card1,Rank1),rank(Card2,Rank2), Rank1 < Rank2.
highest(0) :- draw1(Card1), draw2(Card2), rank(Card1,Rank1),rank(Card2,Rank2), Rank1 = Rank2.

% Determine the winner based on the highest card and the coin flip
winner(1) :- coin(heads), highest(0).
winner(2) :- coin(tails), highest(0).
winner(1) :- highest(1).
winner(2) :- highest(2).
% Queries

% winner(_).
query(winner(_)).

%%%% winner(1)	 0.4375
%%%% winner(2)	 0.5625

% all the questions answered in the pdf file attached 