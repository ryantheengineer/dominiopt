classdef Game < handle
    % Class for holding the characteristics of a specific set of strategies
    % and players
    
    % NEED FUNCTION FOR PLAYING A NEW GAME, A SINGLE PLAYER TURN, AND
    % PLAYING A ROUND. ALSO A GET FINAL SCORE MARGIN OUTPUT.
    
    properties
        players         = [];   % Vector of Player objects
        strategies      = [];   % Vector of Strategy classes
        cards           = []; % Full list of cards in play (3 victory, 3 treasure, 10 actions)
        actioncards     = []; % 10 action cards in same order as in cards
        cardcounts     = [12 12 12 10 20 30 10 10 10 10 10 10 10 10 10 10];
        round           = 1; %NOT SURE IF THIS IS NECESSARY
        % detail_flag        = false; % flag for turning on or off the
        % string outputs that describe the game
        
        % Properties that might need to go in a simulation class
        numgames        = 10; % Choose the number of games to play (default is 10)
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
            assert(length(cards) == 16);
            obj.actioncards = cards(7:end);
        end
        
        
        function initialize_game(obj,firstcards)
            % Give all players their starting cards
            Players = obj.players;
            for i = 1:length(Players)
                Players(i).initialize(firstcards);
            end
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
                        
%                       str = sprintf('Player 1 plays %s',chosen_action.name);
%                       disp(str);

                        delta_actions = chosen_action.actions;
                        delta_buys = chosen_action.buys;
                        delta_coins = chosen_action.coins;
                        obj.players(playernum).change(delta_actions,delta_buys,delta_coins);
                        
                        % Add lines for applying other effects of action
                        % cards here
                        obj.apply_effects(playernum,chosen_action);
                    end
                end
            end
            
            % Choose which cards to buy and get them
            handval = howrich(obj.players(playernum));
            
            for i = 1:length(obj.strategies(playernum).gain_priority)
                if obj.players(playernum).buys < 1
                    break
                else
                    Igain = obj.strategies(playernum).gain_priority(1,:) == i;
                    while (handval >= obj.cards(Igain).cost) && (obj.players(playernum).buys > 0) && (obj.cardcounts(Igain) > 0)
                        obj.players(playernum).gain(obj.cards(Igain));
                        obj.players(playernum).buys = obj.players(playernum).buys - 1;
                        obj.cardcounts(Igain) = obj.cardcounts(Igain) - 1;
                        handval = handval - obj.cards(Igain).cost;
                    end
                end
            end
            
            obj.players(playernum).next_turn;
            
        end
        
        function play_round(obj)
            % Play a single round (all players take one turn)
            numplayers = obj.num_players;
            for i = 1:numplayers
                obj.play_turn(i);
            end
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
        
        
        %% Card effect actions that require a strategy input
        function apply_effects(obj,playernum,card_played)
            % Apply the appropriate effect based on the card effect (if
            % there is one)
            effect = card_played.effect;
            
            switch effect
                case 'chapel_effect'
                    obj.chapel_action(playernum);
                    disp('Chapel card effect happens!');
                case 'bureaucrat_effect'
                    disp('Bureaucrat card effect happens!');
                    obj.bureaucrat_action(playernum)
                otherwise
%                     disp('This is what happens when another action card is played');
            end
            
        end
        
        function bureaucrat_action(obj,playernum)
            % Gain a Silver onto your deck. Each other player reveals a
            % Victory card from their hand and puts it onto their deck (or
            % reveals a hand with no Victory cards)
            silvercount = obj.cardcounts(5);
            if silvercount > 0
                obj.players(playernum).gain(obj.cards(5));
                obj.cardcounts(5) = silvercount - 1;
            end
            
            % Each other player goes through their hand to put a Victory
            % card on top of their deck
            NumPlayers = obj.num_players;
            for i = 1:NumPlayers
                if i ~= playernum
                    victory_in_hand = 0;
                    Hand = obj.players(i).hand;
                    Drawpile = obj.players(i).drawpile;
                    % Cycle through player i's hand
                    for j = 1:length(Hand)
                        % Check if they haven't already pulled out a
                        % victory card
                        if victory_in_hand < 1
                            % Get the card in question
                            check_card = obj.players(i).hand(j);
                            if check_card.isVictory == true
                                % If it's a victory card, put the card on
                                % top of the draw pile
                                Drawpile = [check_card,Drawpile];
                                obj.players(i).drawpile = Drawpile;
                                
                                % Remove the victory card from the hand
                                Hand(j) = [];
                                obj.players(i).hand = Hand;
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
            
            for i = 1:length(obj.strategies(playernum).trash_priority)
                if trashcount > 4
                    break
                else
%                       (The logicical indexing appears to be off at this
%                       point)
                    % Get the index in the trash_priority list where the
                    % priority is equal to i
                    Itrash = obj.strategies(playernum).trash_priority(1,:) == i;
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
                        str = sprintf('Player trashes %s card',chosen_trash.name);
                        disp(str);
                        trashcount = trashcount + 1;   
                    end
                end
            end
            
        end
        
        
        function harbinger_action(obj,playernum)
            % Look through your discard pile. You may put a card from it
            % onto your deck (do this according to gain_priority, with
            % modifiers to keep from putting victory cards on top of your
            % deck)
            Discard = obj.players(playernum).discard;
            Drawpile = obj.players(playernum).drawpile;
            for i = 1:length(Discard)
                for j = 1:length(obj.strategies(playernum).gain_priority)
                    % Get index in cards where the preferred card, according
                    % to gain_priority, is located
                    Igain = obj.strategies(playernum).gain_priority == j;
                    
                    
                    % WORK ON THE LOGIC HERE!!!!!
                    
                    
%                     % If the preferred card is not a victory card, get it
%                     % from the discard (gain and remove from discard)
%                     if obj.cards(Igain).isVictory == false
%                         % Gain the chosen card ONTO THE TOP OF THE DRAWPILE
% %                         obj.players(playernum).gain(obj.cards(Igain));
%                         
%                         % Get index of card in hand (could find multiple)
%                         index = find(Discard == card);
% 
%                         if isempty(index)
%                             error('Can''t trash a card that isn''t in your hand!');
%                         end
% 
%                         % Trash the first instance of card if multiple
%                         % Remove the card from hand
%                         cardloc = index(1);
%                         Hand(cardloc) = [];            
%                         obj.hand = Hand;
%                         
%                         
%                     end
                end
            end
            
        end
            
            
        
        
        
    end % END OF METHODS
    
end

