% Test drive creating a set of players and strategies, and then running n
% games to see how good strategy 1 is.

clear;

load Run6new_long_extension.mat % Load a saved workspace from an optimization run

% can set winstrategy to eliSet(index) to test the optimized strategy, or 
% use playHistory to choose any design from the optimization history
% winstrategy = playHistory(1);
winstrategy = eliSet(index);

%% Set up cards
cardlist;
cards = [province duchy estate curse gold silver copper smithy witch village woodcutter festival market bureaucrat councilroom moat chapel];
actioncards = [smithy witch village woodcutter festival market bureaucrat councilroom moat mine]; % Is this necessary anymore?

%% Set up strategies
strategy1 = Strategy(winstrategy.gain_priority,winstrategy.gain_cutoffs,winstrategy.play_priority,winstrategy.trash_priority);

strategy2 = chooseOpponent('BigMoney');
% strategy3 = chooseOpponent('BigSmithy');
% strategy4 = chooseOpponent('DoubleWitch');

strategies = [strategy1,strategy2];

%% Set up players
player1 = Player(1);
player2 = Player(2);
% player3 = Player(3);
% player4 = Player(4);

players = [player1,player2];

%% Set up and run game simulations

ngames = 10000;
[avg_score_margin] = Dominion(ngames,players,strategies,cards,firstcards);

str = sprintf('Avg score margin: %0.2f',avg_score_margin);
disp(str);