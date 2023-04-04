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

% all the  other questions answered in the pdf file attached 

%%%% Is Draw1 marginally independent of Coin ? ( Yes / No)    
%%%% Your answer : No, Draw1 is not marginally independent of Coin in our probabilistic model.

%%%% Is Draw1 marginally independent of Coin given Winner ? ( Yes / No)    
%%%% Your answer : Yes, Draw1 and Coin are marginally independent given that we know Winner because Winner is the only variable that directly depends on both Draw1 and Coin.


%%%% Given the observations in Table 1, learn the probability that player 2 is a cheater (keep the other parameters
fixed). Use the learning tab from the online editor to do this. What is the final probability?
%%%% Your answer : 

% evidence(draw1,1).
% evidence(winner,1).
% ---
% evidence(draw1,4).
% evidence(winner,2).
% ---
% evidence(draw1,4).
% evidence(winner,1).
% ---
% evidence(draw1,3).
% evidence(winner,2).
% 
% 
% %% then I tested learning with initializing (values after learning -> ...)
% t(0.2)::cheater. -> 0.2
% t(0.8)::fair. -> 0.8
% 
% without init
% t(_)::cheater. -> 0.76
% t(_)::fair. -> 0.468
% 
%  and with only initializing fair 
%  
% t(_)::cheater. -> 0.262
% t(0.8)::fair. -> 0.8
% 
% if we only use cheater and dont use fair as in the code then
%  t(_)::cheater. -> 0.440, however, this value changes any time I run it

