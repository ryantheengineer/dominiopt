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

cards = [province duchy estate curse gold silver copper village woodcutter smithy festival market laboratory chapel cellar moat harbinger];
actioncards = cards(7:end);
% cardcounts = [10 10 10 10 20 30 10 10 10 10 10 10 10 10 10 10];

[gain_priority,gain_cutoffs,play_priority,trash_priority] = random_strategy(cards);
strategy1 = Strategy(gain_priority,gain_cutoffs,play_priority,trash_priority);

[gain_priority,gain_cutoffs,play_priority,trash_priority] = random_strategy(cards);
strategy2 = Strategy(gain_priority,gain_cutoffs,play_priority,trash_priority);

% (Set non-random gain strategy just to make it clear when the code works or
% not)
strategy1.gain_priority(1,:) = [1 4 15 17 2 5 16 8 6 7 3 9 10 11 12 13 14];
% strategy1.gain_priority = [16 15 14 13 12 11 10 9 8 7 6 5 4 3 2 1];
strategy1.play_priority = [4 2 3 1 5 6 7 8 9 10];

%% Testing
% Test out process of checking buys and actions and then having a player
% buy according to a strategy priority list
player1 = Player(1);
player2 = Player(2);
players = [player1,player2];

strategies = [strategy1,strategy2];

game = Game(players,strategies,cards);
game.initialize_game(firstcards);

game.players(1).hand = [game.players(1).hand,gold];

% Play a turn for a single player
showcards(game.players(1));



% PLAY ACTION CARDS FIRST according to action card priority
% list in corresponding strategy
Actioncards = game.actioncards;
for i = 1:length(game.strategies(1).play_priority)
    if game.players(1).actions < 1
        break
    else
        Iplay = game.strategies(1).play_priority == i;
        preferred_action = Actioncards(Iplay);

        cardlocs = ismember(game.players(1).hand,preferred_action);
        havecard = any(cardlocs);

        % If you have the preferred card in hand, play it (need
        % to implement checking, in case a new card has been
        % gained through an action card power)
        if havecard == true
            chosen_action = preferred_action;
            game.players(1).play_action(chosen_action);

            str = sprintf('Player %d plays %s',1,chosen_action.name);
            disp(str);

            delta_actions = chosen_action.actions;
            delta_buys = chosen_action.buys;
            delta_coins = chosen_action.coins;
            game.players(1).change(delta_actions,delta_buys,delta_coins);

            % Add lines for applying other effects of action
            % cards here
            game.apply_effects(1,chosen_action);
        end
    end
end

% Choose which cards to buy and get them
handval = howrich(game.players(1));
str = sprintf('Hand value is: %d',handval);
disp(str);

for i = 1:length(game.strategies(1).gain_priority(1,:))
    if game.players(1).buys < 1
        break
    else
        % Find the indices where the gain_priority is i
        Igain = find(game.strategies(1).gain_priority(1,:) == i);
%                     if length(Igain) > 1
%                         disp('Igain did something weird');
%                     end
        str = sprintf('Preferred card to buy is: %s (cost = %d)',game.cards(Igain).name,game.cards(Igain).cost);
        disp(str);
        % If the preferred card has an off switch on it, skip
        % trying to buy this card (DOESN'T CURRENTLY WORK AS
        % INTENDED)
        if game.strategies(1).gain_priority(2,Igain) == 0
            disp('Actually, don''t buy that card');
            continue
        else
            cardpercent = game.get_percent(1,game.cards(Igain));
            

            % If gain_cutoffs specifies a percent constraint, follow
            % that logic
            if game.strategies(1).gain_cutoffs(1,Igain) == 0
                disp('Using percent constraint');
                str = sprintf('Player has %0.2f percent of desired card in deck',cardpercent);
                disp(str);
                while ((handval >= game.cards(Igain).cost) && (game.players(1).buys > 0)...
                        && (game.cardcounts(Igain) > 0) && (cardpercent < game.strategies(1).gain_cutoffs(2,Igain)))
                    game.players(1).gain(game.cards(Igain));
                    str = sprintf('Player 1 buys %s',game.cards(Igain).name);
                    disp(str);
                    game.players(1).buys = game.players(1).buys - 1;
                    game.cardcounts(Igain) = game.cardcounts(Igain) - 1;
                    handval = handval - game.cards(Igain).cost;
                end

            % Otherwise use a "cards left" constraint
            else
                disp('Using cards left constraint');
                while ((handval >= game.cards(Igain).cost) && (game.players(1).buys > 0) ...
                        && (game.cardcounts(Igain) > 0) && (game.cardcounts(Igain) < game.strategies(1).gain_cutoffs(3,Igain)))
                    game.players(1).gain(game.cards(Igain));
                    game.players(1).buys = game.players(1).buys - 1;
                    game.cardcounts(Igain) = game.cardcounts(Igain) - 1;
                    handval = handval - game.cards(Igain).cost;
                end

            end

            
        end
    end
    
end

% str = sprintf('Player %d buys %s',1,game.cards(Igain).name);
% disp(str);

game.players(1).next_turn;

