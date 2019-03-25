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
        
%         function cardcounts_setup(players,cards)
%             numplayers = length(players);
%             
%         end
        
%         % NOT ENTIRELY SURE OF THE LOGIC FOR THIS FUNCTION...
%         function State = state(obj)
%             % Get the game's state for the current player. Most methods
%             % that do anything interesting need to do this.
%             State = obj.players(obj.player_turn);
%         end
        
        
        function current_play_card(obj,card)
            % Play a card in the current state without decrementing the
            % action count.
            obj.replace_current_state(obj.state().play_card(card));
        end
        
        function current_play_action(obj,card)
            % This function plays an action card for the current player and
            % decrements the action count
            obj.replace_current_state(obj.state().play_action(card));
        end
        
        
        function current_draw_cards(obj,n)
            % The current player draws n cards
            obj.replace_current_state(obj.state().draw(n));
        end
        
        % NOT SURE WHERE .player COMES FROM ON THE END
        function current_player(obj)
            obj.state().player;
        end
        
        function [NumPlayers] = num_players(obj)
            NumPlayers = length(obj.players);
        end
        
        function [newgame] = replace_states(obj,newstates)
            % Do something with the current player's state and make a new
            % overall game state from it.
            newgame = obj.copy();
            newgame.playerstates = newstates;
        end
        
        function [newgame] = replace_current_state(obj,newstate)
            % Do something with the current player's state and make a new
            % overall game state from it.
            newgame = obj.copy();
            newgame.playerstates(obj.player_turn) = newstate;
        end
        
        % DON'T UNDERSTAND CHANGE_CURRENT_STATE FUNCTION
        
        
        
        
%         function outputArg = method1(obj,inputArg)
%             %METHOD1 Summary of this method goes here
%             %   Detailed explanation goes here
%             outputArg = obj.Property1 + inputArg;
%         end
    end
end

