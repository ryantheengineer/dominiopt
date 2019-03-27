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
        cardcounts     = [10 10 10 10 20 30 10 10 10 10 10 10 10 10 10 10];
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
                    end
                end
            end
            
            % Choose which cards to buy and get them
            handval = howrich(obj.players(playernum));
            
            for i = 1:length(obj.strategies(playernum).gain_priority)
                if obj.players(playernum).buys < 1
                    break
                else
                    Igain = obj.strategies(playernum).gain_priority == i;
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
                    obj.chapel_action(obj.players(playernum));
                    
                    
                    % Add other card effects here
            end
            
        end
        
        
        
        function chapel_action(obj,playernum)
            % Trash up to 4 cards from your hand
            trashcount = 0;
            
            Hand = obj.players(playernum).hand;
            
            for i = 1:length(obj.strategies(playernum).play_priority)
                if trashcount > 4
                    break
                else
                    Itrash = obj.strategies(playernum).trash_priority == i;
                    preferred_trash = Hand(Itrash);
                    
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
        
        
        
        
%         % NOT ENTIRELY SURE OF THE LOGIC FOR THIS FUNCTION...
%         function State = state(obj)
%             % Get the game's state for the current player. Most methods
%             % that do anything interesting need to do this.
%             State = obj.players(obj.player_turn);
%         end
        
        
%         function current_play_card(obj,card)
%             % Play a card in the current state without decrementing the
%             % action count.
%             obj.replace_current_state(obj.state().play_card(card));
%         end
        
%         function current_play_action(obj,card)
%             % This function plays an action card for the current player and
%             % decrements the action count
%             obj.replace_current_state(obj.state().play_action(card));
%         end
%         
%         
%         function current_draw_cards(obj,n)
%             % The current player draws n cards
%             obj.replace_current_state(obj.state().draw(n));
%         end
        
%         % NOT SURE WHERE .player COMES FROM ON THE END
%         function current_player(obj)
%             obj.state().player;
%         end
        
        
        
%         function [newgame] = replace_states(obj,newstates)
%             % Do something with the current player's state and make a new
%             % overall game state from it.
%             newgame = obj.copy();
%             newgame.playerstates = newstates;
%         end
        
%         function [newgame] = replace_current_state(obj,newstate)
%             % Do something with the current player's state and make a new
%             % overall game state from it.
%             newgame = obj.copy();
%             newgame.playerstates(obj.player_turn) = newstate;
%         end
        
        % DON'T UNDERSTAND CHANGE_CURRENT_STATE FUNCTION
        
        
        
        
%         function outputArg = method1(obj,inputArg)
%             %METHOD1 Summary of this method goes here
%             %   Detailed explanation goes here
%             outputArg = obj.Property1 + inputArg;
%         end
    end
end

