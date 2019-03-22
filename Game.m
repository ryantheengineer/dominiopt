classdef Game < handle
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        players         = empty.Player();   % Vector of Player objects
        strategies      = empty.Strategy();   % Vector of Strategy classes
        cards           = [];
        card_counts     = []; % Implement a card array based on the number of players and cards chosen to play with
        turn            = 1;
        player_turn     = 1;
        round           = 1;
        simulated       % NOT SURE IF THIS IS NECESSARY
        
    end
    
    methods
        % Constructor method
        function obj = Game(players,strategies,cards)
            %UNTITLED Construct an instance of this class
            %   Detailed explanation goes here
            obj.players = players;
            obj.strategies = strategies;
            obj.cards = cards;
        end
        
%         function card_counts_setup(players,cards)
%             numplayers = length(players);
%             
%         end
        
        % NOT ENTIRELY SURE OF THE LOGIC FOR THIS FUNCTION...
        function State = state(obj)
            % Get the game's state for the current player. Most methods
            % that do anything interesting need to do this.
            State = obj.players(obj.player_turn);
        end
        
        
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

