% Test script for running class and method tests quickly, instead of
% through the command line

%% Setup
clear;


% Set up the card variables
cardlist;

% Get player1 ready (beginning of game state, with 10 cards (7 copper, 3
% estate) shuffled and the first 5 cards drawn into hand
player1 = Player(1);
player1.initialize(firstcards);

player2 = Player(2);
player2.initialize(firstcards);

cards = [province duchy estate chapel gold silver copper];

[gain_priority,gain_cutoffs,play_priority,discard_priority,trash_priority] = random_strategy(cards);
strategy1 = Strategy(cards,gain_priority,gain_cutoffs,play_priority,discard_priority,trash_priority);

[gain_priority,gain_cutoffs,play_priority,discard_priority,trash_priority] = random_strategy(cards);
strategy2 = Strategy(cards,gain_priority,gain_cutoffs,play_priority,discard_priority,trash_priority);

%% Testing
% Test out process of checking buys and actions and then having a player
% buy according to a strategy priority list

% Add some money and buys to see what choices are made
player1.hand = [player1.hand, gold, gold, gold, gold, gold];
player1.buys = 3;

% Check value of hand (may need something to determine whether or not to
% prefer playing action cards first, could be a simple binary variable)
handval_1 = 0;
for i = 1:length(player1.hand)
    handval_1 = handval_1 + player1.hand(i).treasure;
end

handval_1

% (Set non-random gain strategy just to make it clear when the code works or
% not)
strategy1.gain_priority = [1 2 3 4 5 6 7];

% Cycle through priority list and buy the highest priority card first
for i = 1:length(strategy1.gain_priority)
    if player1.buys < 1
        break
    else
        player1.buys
        handval_1
        Igain = find(strategy1.gain_priority == i);
        str = sprintf('Preferred card is: %s',cards(Igain).name);
        disp(str);
        if handval_1 >= cards(Igain).cost
            player1.gain(cards(Igain));
            str = sprintf('BOUGHT: %s',cards(Igain).name);
            disp(str);
            player1.buys = player1.buys - 1;
            handval_1 = handval_1 - cards(Igain).cost;
        end
    end
   
end



%% Old
% player1.draw(5);
% showcards(player1);

% disp(' ');
% disp('Discarding a copper');
% player1.discard_card(copper);
% 
% showcards(player1);
