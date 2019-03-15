classdef PlayerState < handle
    % From dominiate-python repository:
    % "A PlayerState represents all the game state that is particular to a
    % player, including the number of actions, buys, and +coins they have.
    
    properties
        player      = 0;  % int
        actions     = 0;  % int
        buys        = 0;  % int
        coins       = 0;  % int
        hand        = []; % tuple in Python, maybe a character array?
        drawpile    = []; % tuple in Python, maybe a character array?
        discard     = []; % tuple in Python, maybe a character array?
        tableau     = []; % tuple in Python, maybe a character array?
    end
    
    methods
        function obj = PlayerState(player)
            %PLAYERSTATE Construct an instance of this class
            %   Detailed explanation goes here
            obj.player = player;
%             obj.actions = actions;
%             obj.buys = buys;
%             obj.coins = coins;
%             obj.hand = hand;
%             obj.drawpile = drawpile;
%             obj.discard = discard;
%             obj.tableau = tableau;
        end
        
        function change(obj,delta_actions)
            obj.actions = obj.actions + delta_actions;
        end
        
    end
    
end

