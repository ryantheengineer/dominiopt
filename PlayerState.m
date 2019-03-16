classdef PlayerState < handle
    % From dominiate-python repository:
    % "A PlayerState represents all the game state that is particular to a
    % player, including the number of actions, buys, and +coins they have.
    
    properties
        player;           % int
        actions     = 0;  % int
        buys        = 1;  % int
        coins       = 0;  % int
        hand        = []; % tuple in Python, maybe a character array?
        drawpile    = []; % tuple in Python, maybe a character array?
        discard     = []; % tuple in Python, maybe a character array?
        tableau     = []; % tuple in Python, maybe a character array?       
    end
    
    methods
        function obj = PlayerState(player)
            %PLAYERSTATE Construct an instance of this class
            obj.player = player;    % Initialize with an integer that indicates the player number
        end
        
        
        % Change the currently available number of actions, buys, and coins
        function change(obj,delta_actions,delta_buys,delta_coins)
            % Change the number of actions, buys, cards, or coins available
            % on this turn.
            obj.actions = obj.actions + delta_actions;
            obj.buys = obj.buys + delta_buys;
            obj.coins = obj.coins + delta_coins;
        end
        
        function [totalcards] = all_cards(obj)
            totalcards = obj.hand + obj.tableau + obj.drawpile + obj.discard;
        end
        
        function [handsize] = hand_size(obj)
            handsize = length(obj.hand);
        end
        
        function gain_cards(obj,cards)
            obj.discard = obj.discard + cards;
        end
        
        function [buysleft] = buyable(obj)
            % Can this hand still buy a card?
            buysleft = obj.buys > 0;
        end
        
        
        function initialize_drawpile(obj,firstcards)
            % Initialize with 7 Copper and 3 Estate cards. firstcards must
            % be a 1x2 array with copper first and estate second.
            drawpile_0 = repelem(firstcards,[7,3]);
            
            % Randomly shuffle the cards so they are ready to be drawn
            n = numel(drawpile_0);
            ii = randperm(n);
            drawpile_0 = drawpile_0(ii);
            obj.drawpile = drawpile_0;
            
        end
        
        
        
        
%         function isactionable = actionable(obj)
%             % Are there any actions left to take with this hand?
%             if obj.actions > 0 && 
%             end
%         end
        
%         NEED TO FIGURE OUT THIS AND PLAY_ACTION FUNCTIONS
%         function play_card(obj,card)
%             % Play a card from the hand into the tableau.
%             % Decreasing the number of actions available is handled in
%             % play_action function
            
            
        
%         NEED TO UNDERSTAND HOW DRAW FUNCTION WORKS MORE BEFORE
%         IMPLEMENTING
%         function draw(obj,n)
%             % Returns a new PlayerState in which n cards have been drawn
%             % (shuffling if necessary)
%             if length(obj.drawpile) >= n
%                 obj.hand
        
%         NEED TO MAKE THIS SYNTAX MORE MATLAB-FRIENDLY
%         function totalcoins = hand_value(obj)
%             % How many coins can the player spend?
%             totalcoins = obj.coins + sum(card.treasure for card in obj.hand)
%             end
        
    end
    
end

