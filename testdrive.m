% Test drive creating a set of players and strategies, and then running n
% games to see how good strategy 1 is.

clear;

%% Set up cards
cardlist;
cards = [province duchy estate gold silver copper village woodcutter smithy festival market bureaucrat chapel cellar moat harbinger];
actioncards = [village woodcutter smithy festival market laboratory chapel cellar moat harbinger];

%% Set up strategies
[gain_priority,gain_cutoffs,play_priority,trash_priority] = random_strategy(cards);
strategy1 = Strategy(gain_priority,gain_cutoffs,play_priority,trash_priority);
strategy1.gain_priority = [1 4 15 2 5 16 8 6 7 3 9 10 11 12 13 14];
strategy1.play_priority = [4 2 3 1 5 6 7 8 9 10];

[gain_priority,gain_cutoffs,play_priority,trash_priority] = random_strategy(cards);
strategy2 = Strategy(gain_priority,gain_cutoffs,play_priority,trash_priority);

strategies = [strategy1,strategy2];

%% Set up players
player1 = Player(1);
player2 = Player(2);

players = [player1,player2];

%% Set up and run game simulations

ngames = 100;
[avg_score_margin] = Dominion(ngames,players,strategies,cards,firstcards);

str = sprintf('Avg score margin: %0.2f',avg_score_margin);
disp(str);
% str = sprintf('Standard deviation of the score margins: %0.2f',std_score_margin);
% disp(str);