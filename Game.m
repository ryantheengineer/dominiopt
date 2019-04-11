classdef Game < handle
    % Class for holding the characteristics of a specific set of strategies
    % and players
    
    properties
        players         = [];   % Vector of Player objects
        strategies      = [];   % Vector of Strategy classes
        cards           = []; % Full list of cards in play (3 victory, 3 treasure, 10 actions)
        actioncards     = []; % 10 action cards in same order as in cards
        cardcounts     = [12 12 12 30 30 40 40 10 10 10 10 10 10 10 10 10 10];
        round           = 1; %NOT SURE IF THIS IS NECESSARY
        % detail_flag        = false; % flag for turning on or off the
        % string outputs that describe the game
        
        % Properties that might need to go in a simulation class
%         numgames        = 10; % Choose the number of games to play (default is 10)
        scores          = []; % Array for holding scores from players (columns are the players and rows are the scores)
        margins         = []; % Array for holding score margins for player 1 against the closest scoring player

        
    end
    
    methods
        % Constructor method
        function obj = Game(players,strategies,cards)
            %UNTITLED Construct an instance of this class
            %   Detailed explanation goes here
            obj.players = players;
            obj.strategies = strategies;
            obj.cards = cards;
            assert(length(cards) == 17);
            obj.actioncards = cards(8:end);
        end
        
        
        function initialize_game(obj,firstcards)
            % Give all players their starting cards
            Players = obj.players;
            for i = 1:length(Players)
                Players(i).initialize(firstcards);
            end
        end
        
        function clear_game(obj)
            % Clear all player cards in the game object so it's ready for
            % another simulation
            for i = 1:length(obj.players)
                obj.players(i).hand = [];
                obj.players(i).drawpile = [];
                obj.players(i).discard = [];
                obj.players(i).tableau = [];
            end
            
            % Reset cardcounts
            obj.cardcounts = [12 12 12 30 30 40 40 10 10 10 10 10 10 10 10 10 10];
        end
        
        function [gameover] = isgameover(obj)
            % Return true if either a single pile of victory cards is gone,
            % or if any 3 other piles are gone
            victory_endcondition = find(obj.cardcounts(1:3) == 0);
            other_endcondition = find(obj.cardcounts(4:end) == 0);
            
            gone_victory = length(victory_endcondition);
            gone_other = length(other_endcondition);
            
            if gone_victory >= 1 || gone_other >= 3
                gameover = true;
            else
                gameover = false;
            end
        end
        
        
        function play_turn(obj,playernum)
            % Play a turn. First play preferred actions until no more
            % actions are possible. Then buy the preferred cards according
            % to the conditions set in the player's strategy.
            obj.play_actions(playernum);            
            obj.buy_preferred(playernum);
            obj.players(playernum).next_turn;
            
        end
        
        
        function play_actions(obj,playernum)
           % Play a turn for a single player
%             showcards(obj.players(playernum));

            % PLAY ACTION CARDS FIRST according to action card priority
            % list in corresponding strategy
            Actioncards = obj.actioncards;
            for i = 1:length(obj.strategies(playernum).play_priority)
                if obj.players(playernum).actions < 1
                    break
                else
                    Iplay = obj.strategies(playernum).play_priority == i;
                    preferred_action = Actioncards(Iplay);
                    
                    cardlocs = ismember(obj.players(playernum).hand,preferred_action);
                    havecard = any(cardlocs);
                    
                    % If you have the preferred card in hand, play it (need
                    % to implement checking, in case a new card has been
                    % gained through an action card power)
                    if havecard == true
                        chosen_action = preferred_action;
                        obj.players(playernum).play_action(chosen_action);
                        
%                         str = sprintf('Player %d plays %s',playernum,chosen_action.name);
%                         disp(str);

                        delta_actions = chosen_action.actions;
                        delta_buys = chosen_action.buys;
                        delta_coins = chosen_action.coins;
                        obj.players(playernum).change(delta_actions,delta_buys,delta_coins);
                        
                        % Add lines for applying other effects of action
                        % cards here
                        obj.apply_effects(playernum,chosen_action);
%                         str = sprintf('%s action played',chosen_action.name);
%                         disp(str);
                    end
                end
            end 
        end
        
        function buy_preferred(obj,playernum)
        % Choose which cards to buy and get them
            handval = howrich(obj.players(playernum));
            
            for i = 1:length(obj.strategies(playernum).gain_priority(1,:))
                if obj.players(playernum).buys < 1
                    break
                else
                    % Find the indices where the gain_priority is i
                    Igain = obj.strategies(playernum).gain_priority(1,:) == i;
%                     if length(Igain) > 1
%                         disp('Igain did something weird');
%                     end

                    % If the preferred card has an off switch on it, skip
                    % trying to buy this card (DOESN'T CURRENTLY WORK AS
                    % INTENDED)
                    if obj.strategies(playernum).gain_priority(2,Igain) == 0
%                         disp(obj.strategies(playernum).gain_priority(2,Igain));
                        continue
                    else
                        cardpercent = obj.get_percent(playernum,obj.cards(Igain));

                        % If gain_cutoffs specifies a percent constraint, follow
                        % that logic
                        if obj.strategies(playernum).gain_cutoffs(1,Igain) == 0
                            while ((handval >= obj.cards(Igain).cost) && (obj.players(playernum).buys > 0)...
                                    && (obj.cardcounts(Igain) > 0) && (cardpercent < obj.strategies(playernum).gain_cutoffs(2,Igain)))
                                obj.players(playernum).gain(obj.cards(Igain));
                                obj.players(playernum).buys = obj.players(playernum).buys - 1;
                                obj.cardcounts(Igain) = obj.cardcounts(Igain) - 1;
                                handval = handval - obj.cards(Igain).cost;
                            end

                        % Otherwise use a "cards left" constraint
                        else
                            % Check least victory cards left
                            min_cardsleft = obj.check_victory_left();
                            
                            % Check least three action card deck amounts
                            lowest_three_actions = obj.check_action_decks();
                            
                            % Get logical value for if either min_cardsleft
                            % or all the elements of lowest_three_actions
                            % are below a threshold called out by player's
                            % strategy (fed into the while loop conditions
                            % below)
                            cardsleft_condition = ((min_cardsleft <= obj.strategies(playernum).gain_cutoffs(3,Igain)) ...
                                || all(lowest_three_actions <= obj.strategies(playernum).gain_cutoffs(3,Igain)));
                            
                            
                            while ((handval >= obj.cards(Igain).cost) && (obj.players(playernum).buys > 0) ...
                                    && (obj.cardcounts(Igain) > 0) && cardsleft_condition == true)
                                obj.players(playernum).gain(obj.cards(Igain));
                                obj.players(playernum).buys = obj.players(playernum).buys - 1;
                                obj.cardcounts(Igain) = obj.cardcounts(Igain) - 1;
                                handval = handval - obj.cards(Igain).cost;
                            end

                        end

%                         str = sprintf('Player %d buys %s',playernum,obj.cards(Igain).name);
%                         disp(str);
                    end
                end
            end    
        end
              
        function [min_cardsleft] = check_victory_left(obj)
            % Check the lowest number of victory cards left to see how
            % close the game is to ending (ignoring Curse cards)
            cards_to_check = obj.cardcounts(1:3);
            min_cardsleft = min(cards_to_check);
        end
        
        function [lowest_three_actions] = check_action_decks(obj)
            % Check the action card piles to see what the lowest three
            % numbers of cards left are (used for checking if game is
            % approaching end)
            n = 3;
            lowest_three_actions = zeros(1,n);
            ActionCounts = obj.cardcounts(8:end);
            for i = 1:n
                [lowest_three_actions(i),idx] = min(ActionCounts);
                % remove the lowest index for the next iteration
                ActionCounts(idx) = [];
            end
        end
        
        
        function play_round(obj)
            % Play a single round (all players take one turn)
            numplayers = obj.num_players;
            for i = 1:numplayers
                obj.play_turn(i);
            end
%             str = sprintf('%d ',obj.cardcounts);
%             disp(str);
        end
        
        
        function [NumPlayers] = num_players(obj)
            NumPlayers = length(obj.players);
        end
        
        
        function play_game(obj,firstcards)
            % Play a full game (play rounds until the end game condition is
            % tripped
            obj.initialize_game(firstcards);
            gameover = false;
            while gameover == false
                obj.play_round;
                gameover = obj.isgameover;
            end
            obj.get_scores()
%             obj.scores
        end
        
        
        function get_scores(obj)
           % Output the final scores into a row vector (columns correspond
           % to the different players)
           NumPlayers = obj.num_players;
           Scores = zeros(1,NumPlayers);
           Margins = zeros(1,(NumPlayers-1));           
           
           for i = 1:NumPlayers
               % Move all cards in the player deck to one place for easy
               % counting
               Hand = obj.players(i).hand;
               Discard = obj.players(i).discard;
               Drawpile = obj.players(i).drawpile;
               Tableau = obj.players(i).tableau;

               allcards = [Hand,Discard,Drawpile,Tableau];
               
               for j = 1:length(allcards)
                   Scores(i) = Scores(i) + allcards(j).vp;
               end
           end
           
           obj.scores = Scores;
           
           for i = 2:NumPlayers
               Margins(i-1) = Scores(1) - Scores(i);
           end
           
           obj.margins = Margins;
            
        end
        
        function [decklength] = decksize(obj,playernum)
            Handsize = length(obj.players(playernum).hand);
            Drawpilesize = length(obj.players(playernum).drawpile);
            Discardsize = length(obj.players(playernum).discard);
            Tableausize = length(obj.players(playernum).tableau);
            
            decklength = Handsize + Drawpilesize + Discardsize + Tableausize;
            
        end
        
        
        function [cardpercent] = get_percent(obj,playernum,checkcard)
            % Check the percentage of checkcard in the player's entire deck
            handcount = sum(obj.players(playernum).hand == checkcard);
            drawcount = sum(obj.players(playernum).drawpile == checkcard);
            discardcount = sum(obj.players(playernum).discard == checkcard);
            tableaucount = sum(obj.players(playernum).tableau == checkcard);

            cardcount = handcount + drawcount + discardcount + tableaucount;            
            
            % Get the total number of cards in the deck
            decklength = obj.decksize(playernum);
            
            % Calculate percent of desired card in the deck
            cardpercent = cardcount/decklength;
            
        end
        
        
        %% Card effect actions that require a strategy input
        function apply_effects(obj,playernum,card_played)
            % Apply the appropriate effect based on the card effect (if
            % there is one)
            effect = card_played.effect;
            
            switch effect
                case 'chapel_effect'
%                     disp('Chapel card effect happens!');
                    obj.chapel_action(playernum);
                case 'bureaucrat_effect'
%                     disp('Bureaucrat card effect happens!');
                    obj.bureaucrat_action(playernum);
                case 'harbinger_effect'
%                     disp('Harbinger card effect happens!');
                    obj.harbinger_action(playernum);
                case 'councilroom_effect'
%                     disp('Council Room card effect happens!');
                    obj.councilroom_action(playernum);
                case 'mine_effect'
%                     disp('Mine card effect happens!');
                    obj.mine_action(playernum);
                otherwise
%                     disp('This is what happens when another action card is played');
            end
            
        end
        
        function bureaucrat_action(obj,playernum)
            % Gain a Silver onto your deck. Each other player reveals a
            % Victory card from their hand and puts it onto their deck (or
            % reveals a hand with no Victory cards)
            silvercount = obj.cardcounts(6);
            if silvercount > 0
                obj.players(playernum).gain(obj.cards(6));
                obj.cardcounts(6) = silvercount - 1;
            end
            
            % Each other player goes through their hand to put a Victory
            % card on top of their deck
            NumPlayers = obj.num_players;
            for j = 1:NumPlayers
                if j ~= playernum
                    victory_in_hand = 0;
                    Hand = obj.players(j).hand;
                    Drawpile = obj.players(j).drawpile;
                    % Cycle through player i's hand
                    for i = 1:length(Hand)
                        % Check if they haven't already pulled out a
                        % victory card
                        if victory_in_hand < 1
                            % Get the card in question
                            check_card = obj.players(j).hand(i);
                            if check_card.isVictory == true
                                % If it's a victory card, put the card on
                                % top of the draw pile
                                Drawpile = [check_card,Drawpile];
                                obj.players(j).drawpile = Drawpile;
                                
                                % Remove the victory card from the hand
                                Hand(i) = [];
                                obj.players(j).hand = Hand;
                                victory_in_hand = 1;
                            end
                        end
                    end
                end
            end
        end
        
            
        
        function chapel_action(obj,playernum)
            % Trash up to 4 cards from your hand
            trashcount = 0;
            
            Hand = obj.players(playernum).hand;
            
            for j = 1:length(obj.strategies(playernum).trash_priority)
                if trashcount > 4
                    break
                else
%                       (The logicical indexing appears to be off at this
%                       point)
                    % Get the index in the trash_priority list where the
                    % priority is equal to i
                    Itrash = find(obj.strategies(playernum).trash_priority(1,:) == j);
                    if obj.strategies(playernum).trash_priority(2,Itrash) == 0
                        continue
                    else
                        preferred_trash = obj.cards(Itrash);

                        cardlocs = ismember(obj.players(playernum).hand,preferred_trash);
                        havecard = any(cardlocs);

                        % If you have the preferred card in hand, play it (need
                        % to implement checking, in case a new card has been
                        % gained through an action card power)
                        if havecard == true
                            chosen_trash = preferred_trash;
                            obj.players(playernum).trash_card(chosen_trash);

                            % NOT SURE IF THIS IS WORKING; NOT SHOWING THIS
                            % OUTPUT IN TESTDRIVE.M
%                             str = sprintf('Player trashes %s card',chosen_trash.name);
%                             disp(str);
                            trashcount = trashcount + 1;   
                        end
                    end
                end
            end
            
        end
        
        
        function harbinger_action(obj,playernum)
            % Look through your discard pile. You may put a card from it
            % onto your deck (do this according to gain_priority, with
            % modifiers to keep from putting victory cards on top of your
            % deck)
            
            % Holding variables for player properties that will be affected
            Discard = obj.players(playernum).discard;
            Drawpile = obj.players(playernum).drawpile;
            
            % Cycle through the gain priority list and find the desired
            % card (if not a victory card)
            for i = 1:length(obj.strategies(playernum).gain_priority(1,:))
                % Find the indices where the gain_priority is i
                Igain = obj.strategies(playernum).gain_priority(1,:) == i;
                
                
                
                % If the chosen card doesn't have an off switch, and if
                % it's not a victory card, then retrieve it from the
                % discard pile and put it on top of the draw pile
                if (obj.strategies(playernum).gain_priority(2,Igain) ~= 0)...
                        && (obj.cards(Igain).isVictory == false)
                    
%                     str = sprintf('Preferred card is %s',obj.cards(Igain).name);
%                     disp(str);
                    
                    % Cycle through the discard until the chosen card is
                    % found
                    for j = 1:length(obj.players(playernum).discard)
                        gotname = strcmp(obj.players(playernum).discard(j).name, obj.cards(Igain).name);
                        % If the name matches, get the card and remove it
                        % from the discard
                        if gotname == true
%                             str = sprintf('Found %s in discard',obj.cards(Igain).name);
%                             disp(str);
                            Discard(j) = [];
                            obj.players(playernum).discard = Discard;
                            Drawpile = [obj.cards(Igain),Drawpile];
                            obj.players(playernum).drawpile = Drawpile;
                            break
                        end
                    end                   
                end
                break
            end
                        
        end
            
            
        function councilroom_action(obj,playernum)
           % Have each other player draw a card
           for i = 1:length(obj.players)
               if i ~= playernum
                   obj.players(i).draw(1);
               end
           end
            
        end
        
        
        function mine_action(obj,playernum)
            % Trash a Treasure card from your hand. Gain a Treasure card
            % costing up to 3 more; put it into your hand.
            
            % If you have a Copper in hand, trash that and replace with a
            % Silver. If you only have Silvers and Golds, then trash a
            % Silver for a Gold.
            for i = 1:length(obj.players(playernum).hand)
                checkcard = obj.players(playernum).hand(i);
                if (strcmp(obj.players(playernum).hand(i).name,'Copper') == true)...
                        && (obj.cardcounts(6) > 0)
                    obj.players(playernum).trash_card(checkcard);
                    Hand = obj.players(playernum).hand;
                    Hand = [obj.cards(6),Hand];
                    obj.players(playernum).hand = Hand;
                    obj.cardcounts(6) = obj.cardcounts(6) - 1;
                    break
                elseif (strcmp(obj.players(playernum).hand(i).name,'Silver') == true)...
                        && (obj.cardcounts(5) > 0)
                    obj.players(playernum).trash_card(checkcard);
                    Hand = obj.players(playernum).hand;
                    Hand = [obj.cards(5),Hand];
                    obj.players(playernum).hand = Hand;
                    obj.cardcounts(5) = obj.cardcounts(5) - 1;
                    break
                end
            end
        end
        
        
        function witch_action(obj,playernum)
            % Each other player gains a Curse card
            for i = 1:length(obj.players)
                if i ~= playernum
                    obj.players(i).gain(obj.cards(4));                    
                end
            end
            
        end
        
%         function militia_action(obj,playernum)
%             % Each other player discards down to 3 cards in his hand
%             for i = 1:length(obj.players)
%                 if i ~= playernum
%                     % Discard until 3 cards are left in hand
%                     while length(obj.players(i).hand) > 3
%                         % Cycle through cards to check for victory first
%                         for j = 1:length(obj.players(i).hand)
%                             if (obj.players(i).hand(j).isVictory == true) && (length(obj.players(i).hand) > 3)
%                                 obj.players(i).discard_card(obj.players(i).hand(j));
%                             end
%                         end
%                         
%                         % Break for this player if the hand size has been
%                         % reduced to 3
%                         if length(obj.players(i).hand) == 3
%                             break
%                         end
%                         
%                         % If there aren't any victory cards left to discard
%                         % but the hand is still greater than 3, discard
%                         % according to trash priority
%                         
%                         for j = 1:length(obj.strategies(playernum).trash_priority)
%                             Itrash = find(obj.strategies(playernum).trash_priority(1,:) == j);
%                             if obj.strategies(playernum).trash_priority(2,Itrash) == 0
%                                 continue
%                             else
%                                 preferred_discard = obj.cards(Itrash);
% 
%                                 cardlocs = ismember(obj.players(playernum).hand,preferred_discard);
%                                 havecard = any(cardlocs);
% 
%                                 % If you have the preferred card in hand, discard it
%                                 if havecard == true && length(obj.players(i).hand > 3)
%                                     chosen_discard = preferred_discard;
%                                     obj.players(playernum).discard_card(chosen_discard);
%                                 end
%                             end
%                         end
%                         
%                         % If for some reason the player still hasn't 
%                     end
%                 end
%             end
%             
%         end
        
        
        
    end % END OF METHODS
    
end

