% Test script for running class and method tests quickly, instead of
% through the command line
clear;


% Set up the card variables
cardlist;

% Get player1 ready (beginning of game state, with 10 cards (7 copper, 3
% estate) shuffled and the first 5 cards drawn into hand
player1 = Player(1);
player1.initialize(firstcards);

player1

% player1.draw(5);
showcards(player1);

% disp(' ');
% disp('Discarding a copper');
% player1.discard_card(copper);
% 
% showcards(player1);
