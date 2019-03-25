% Test script for running class and method tests quickly, instead of
% through the command line

%% Setup
clear;


% Set up the card variables
cardlist;

% Get player1 ready (beginning of game state, with 10 cards (7 copper, 3
% estate) shuffled and the first 5 cards drawn into hand
% player1 = Player(1);
% player1.initialize(firstcards);
% 
% player2 = Player(2);
% player2.initialize(firstcards);

cards = [province duchy estate gold silver copper village woodcutter smithy festival market laboratory chapel cellar moat harbinger];
actioncards = cards(7:end);
% cardcounts = [10 10 10 10 20 30 10 10 10 10 10 10 10 10 10 10];

[gain_priority,gain_cutoffs,play_priority,discard_priority,trash_priority] = random_strategy(cards);
strategy1 = Strategy(cards,gain_priority,gain_cutoffs,play_priority,discard_priority,trash_priority);

[gain_priority,gain_cutoffs,play_priority,discard_priority,trash_priority] = random_strategy(cards);
strategy2 = Strategy(cards,gain_priority,gain_cutoffs,play_priority,discard_priority,trash_priority);

% (Set non-random gain strategy just to make it clear when the code works or
% not)
strategy1.gain_priority = [1 4 15 2 5 16 8 6 7 3 9 10 11 12 13 14];
% strategy1.gain_priority = [16 15 14 13 12 11 10 9 8 7 6 5 4 3 2 1];
strategy1.play_priority = [4 2 3 1 5 6 7 8 9 10];

%% Testing
% Test out process of checking buys and actions and then having a player
% buy according to a strategy priority list

gameswon = 0;
gamesplayed = 0;
ngames = 20;
% Simulate ngames and determine the percentage of wins for player 1
for gamenum = 1:ngames
    disp(' ');
    disp(' ');
    str = sprintf('GAME %d',gamenum);
    disp(str);
    
    player1 = Player(1);
    player1.initialize(firstcards);

    player2 = Player(2);
    player2.initialize(firstcards);

    cardcounts = [10 10 10 10 20 30 10 10 10 10 10 10 10 10 10 10];
    
    % 
    roundnum = 1;
    endcondition = find(cardcounts == 0);

    % Simulate game where people only buy stuff they can afford until the game
    % is over, and get an output for which player won
    while isempty(endcondition)
        %% PLAYER 1 TAKES TURN
        % Check if any of the cards in hand are an action, and then play
        % according to highest priority in the play_priority property of
        % the strategy
        disp(' ');
        disp('PLAYER 1 TURN');
        showcards(player1);
        actions_available = [];
        for i = 1:length(strategy1.play_priority)
            if player1.actions < 1
                break
            else
                % Get index (in action card list) of preferred card to play
                Iplay = find(strategy1.play_priority == i);
                preferred_action = actioncards(Iplay);
                str = sprintf('Preferred action is: %s',preferred_action.name);
                disp(str);

                % Check if preferred_action is in the current hand
                cardlocs = ismember(player1.hand,preferred_action);
                havecard = any(cardlocs);

                if havecard == true
                    chosen_action = preferred_action;
                    player1.play_action(chosen_action);
                    str = sprintf('Player 1 plays %s',chosen_action.name);
                    disp(str);

                    delta_actions = chosen_action.actions;
                    delta_buys = chosen_action.buys;
                    delta_coins = chosen_action.coins;
                    player1.change(delta_actions,delta_buys,delta_coins);
                end
            end
        end
                
        
        % Check value of hand (may need something to determine whether or not to
        % prefer playing action cards first, could be a simple binary variable)
        handval_1 = 0;
        for i = 1:length(player1.hand)
            handval_1 = handval_1 + player1.hand(i).treasure;
        end

    %     handval_1
%         disp('PLAYER 1 TURN');
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
                while (handval_1 >= cards(Igain).cost) && (player1.buys > 0) && (cardcounts(Igain) > 0)
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


        %% PLAYER 2 TAKES TURN
        disp(' ');
        disp('PLAYER 2 TURN');
        showcards(player2);
        % Check if any of the cards in hand are an action, and then play
        % according to highest priority in the play_priority property of
        % the strategy
        actions_available = [];
        for i = 1:length(strategy2.play_priority)
            if player2.actions < 1
                break
            else
                % Get index (in action card list) of preferred card to play
                Iplay = find(strategy2.play_priority == i);
                preferred_action = actioncards(Iplay);
                str = sprintf('Preferred action is: %s',preferred_action.name);
                disp(str);

                % Check if preferred_action is in the current hand
                cardlocs = ismember(player2.hand,preferred_action);
                havecard = any(cardlocs);

                if havecard == true
                    chosen_action = preferred_action;
                    player2.play_action(chosen_action);
                    str = sprintf('Player 2 plays %s',chosen_action.name);
                    disp(str);

                    delta_actions = chosen_action.actions;
                    delta_buys = chosen_action.buys;
                    delta_coins = chosen_action.coins;
                    player2.change(delta_actions,delta_buys,delta_coins);
                end
            end
        end
        
        
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
                while (handval_2 >= cards(Igain).cost) && (player2.buys > 0)  && (cardcounts(Igain) > 0)
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

        roundnum = roundnum + 1;
        endcondition = find(cardcounts == 0);

    end

    %% NEXT IMPLEMENT WITH 3 OR 4 PLAYERS TO MAKE SURE STRUCTURE WORKS!

    % Check final card counts and score
%     cardcounts
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
    for i = 1:length(player2.discard)
        totalscore2 = totalscore2 + player2.discard(i).vp;
        if player2.discard(i).isVictory == true
            player2.discard(i).name;
        end
    end

    totalscore2

    if totalscore1 > totalscore2
%         disp('PLAYER 1 WINS!');
        gameswon = gameswon + 1;
    elseif totalscore1 < totalscore2
%         disp('PLAYER 2 WINS!');
    else
%         disp('TIE GAME');
    end

    gamesplayed = gamesplayed + 1;
    
end


% Calculate and display win percentage
% winpercent = 100*(gameswon/gamesplayed);
disp(' ');
str = sprintf('PLAYER 1 WON %d OUT OF %d GAMES PLAYED',gameswon,gamesplayed);
disp(str);

%% Old
% player1.draw(5);
% showcards(player1);

% disp(' ');
% disp('Discarding a copper');
% player1.discard_card(copper);
% 
% showcards(player1);
