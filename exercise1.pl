%%%% The Problog program implementing the Bayesian network.

0.2::cheater.
% t(_)::fair.

% Rules
0.25::draw1(1); 0.25::draw1(2); 0.25::draw1(3); 0.25::draw1(4). % :- fair; cheater.
0.25::draw2(1); 0.25::draw2(2); 0.25::draw2(3); 0.25::draw2(4) :- \+ cheater.

% If player 2 is cheating, replace jacks with aces
0.5::draw2(4); 0.25::draw2(2); 0.25::draw2(3); 0.0::draw2(1) :- cheater.

% If player 2 is cheating, coin always comes up tails
1.0::coin(0); 0.0::coin(1) :- cheater.
0.5::coin(0); 0.5::coin(1) :- \+ cheater.



% Compute the highest card
highest(1) :- draw1(Card1), draw2(Card2), Card1 > Card2.
highest(2) :- draw1(Card1), draw2(Card2), Card1 < Card2.
highest(0) :- draw1(Card1), draw2(Card2), Card1 == Card2.

% Determine the winner based on the highest card and the coin flip
winner(1) :- coin(1), highest(0).
winner(2) :- coin(0), highest(0).
winner(1) :- highest(1).
winner(2) :- highest(2).
% Queries

% winner(_).
query(winner(_)).
query(winner(_)).

%%%% winner(1)	 0.4375
%%%% winner(2)	 0.5625
