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

cards = [province duchy estate gold silver copper village woodcutter smithy];
cardcounts = [10 10 10 10 20 30 10 10 10];

[gain_priority,gain_cutoffs,play_priority,discard_priority,trash_priority] = random_strategy(cards);
strategy1 = Strategy(cards,gain_priority,gain_cutoffs,play_priority,discard_priority,trash_priority);

[gain_priority,gain_cutoffs,play_priority,discard_priority,trash_priority] = random_strategy(cards);
strategy2 = Strategy(cards,gain_priority,gain_cutoffs,play_priority,discard_priority,trash_priority);

% (Set non-random gain strategy just to make it clear when the code works or
% not)
% strategy1.gain_priority = [1 2 5 3 4 6 7 8 9];

%% Testing
% Test out process of checking buys and actions and then having a player
% buy according to a strategy priority list

% 
roundnum = 1;
endcondition = find(cardcounts == 0);

% Simulate game where people only buy stuff they can afford until the game
% is over, and get an output for which player won
while isempty(endcondition)
    
    % PLAYER 1 TAKES TURN
    % Check value of hand (may need something to determine whether or not to
    % prefer playing action cards first, could be a simple binary variable)
    handval_1 = 0;
    for i = 1:length(player1.hand)
        handval_1 = handval_1 + player1.hand(i).treasure;
    end

    
    handval_1
    % Cycle through priority list and buy the highest priority card first
    for i = 1:length(strategy1.gain_priority)
        if player1.buys < 1
            break
        else
            str = sprintf('Buys left: %d',player1.buys);
            disp(str);
            handval_1;
            Igain = find(strategy1.gain_priority == i);
            str = sprintf('Preferred card is: %s',cards(Igain).name);
            disp(str);
            while (handval_1 >= cards(Igain).cost) && (player1.buys > 0)
                player1.gain(cards(Igain));
                str = sprintf('BOUGHT: %s',cards(Igain).name);
                disp(str);
                % Decrement buys left, cards in piles, 
                player1.buys = player1.buys - 1;
                cardcounts(Igain) = cardcounts(Igain) - 1;
                handval_1 = handval_1 - cards(Igain).cost;
            end
        end

    end

    player1.next_turn;
    
    
    % PLAYER 2 TAKES TURN
    % Check value of hand (may need something to determine whether or not to
    % prefer playing action cards first, could be a simple binary variable)
    handval_2 = 0;
    for i = 1:length(player2.hand)
        handval_2 = handval_2 + player2.hand(i).treasure;
    end

    % Cycle through priority list and buy the highest priority card first
    for i = 1:length(strategy2.gain_priority)
        if player2.buys < 1
            break
        else
            str = sprintf('Buys left: %d',player2.buys);
            disp(str);
            handval_2;
            Igain = find(strategy2.gain_priority == i);
            str = sprintf('Preferred card is: %s',cards(Igain).name);
            disp(str);
            while (handval_2 >= cards(Igain).cost) && (player2.buys > 0)
                player2.gain(cards(Igain));
                str = sprintf('BOUGHT: %s',cards(Igain).name);
                disp(str);
                % Decrement buys left, cards in piles, 
                player2.buys = player2.buys - 1;
                cardcounts(Igain) = cardcounts(Igain) - 1;
                handval_2 = handval_2 - cards(Igain).cost;
            end
        end

    end

    player2.next_turn;
    
    roundnum = roundnum + 1
    endcondition = find(cardcounts == 0);
    
end

%% NEXT IMPLEMENT WITH 3 OR 4 PLAYERS TO MAKE SURE STRUCTURE WORKS!

% Check final card counts and score
cardcounts
totalscore1 = 0;
for i = 1:length(player1.hand)
    totalscore1 = totalscore1 + player1.hand(i).vp;
    if player1.hand(i).isVictory == true
        player1.hand(i).name;
    end
end
for i = 1:length(player1.drawpile)
    totalscore1 = totalscore1 + player1.drawpile(i).vp;
    if player1.drawpile(i).isVictory == true
        player1.drawpile(i).name;
    end
end
for i = 1:length(player1.discard)
    totalscore1 = totalscore1 + player1.discard(i).vp;
    if player1.discard(i).isVictory == true
        player1.discard(i).name;
    end
end

totalscore1

totalscore2 = 0;
for i = 1:length(player2.hand)
    totalscore2 = totalscore2 + player2.hand(i).vp;
    if player2.hand(i).isVictory == true
        player2.hand(i).name;
    end
end
for i = 1:length(player2.drawpile)
    totalscore2 = totalscore2 + player2.drawpile(i).vp;
    if player2.drawpile(i).isVictory == true
        player2.drawpile(i).name;
    end
end
for i = 1:length(player1.discard)
    totalscore2 = totalscore2 + player2.discard(i).vp;
    if player2.discard(i).isVictory == true
        player2.discard(i).name;
    end
end

totalscore2

if totalscore1 > totalscore2
    disp('PLAYER 1 WINS!');
elseif totalscore1 < totalscore2
    disp('PLAYER 2 WINS!');
else
    disp('TIE GAME');
end

%% Old
% player1.draw(5);
% showcards(player1);

% disp(' ');
% disp('Discarding a copper');
% player1.discard_card(copper);
% 
% showcards(player1);
