classdef PlayerState
    % From dominiate-python repository:
    % "A PlayerState represents all the game state that is particular to a
    % player, including the number of actions, buys, and +coins they have.
    
    properties
        player      % int
        actions     % int
        buys        % int
        coins       % int
        hand        % tuple in Python, maybe a character array?
        drawpile    % tuple in Python, maybe a character array?
        discard     % tuple in Python, maybe a character array?
        tableau     % tuple in Python, maybe a character array?
    end
    
    methods
        
        function obj = change(delta_actions, delta_buys, delta_cards, delta_coins)
            %Change the number of actions, buys, cards, or coins available
            %on this turn.
            
            if delta_actions > 0
                obj.actions = obj.actions + delta_actions;
            end
            
            if delta_buys > 0
                obj.buys = obj.buys + delta_buys;
            end
            
            if delta_cards > 0
                obj.cards = obj.cards + delta_cards;
            end
            
            if delta_coins > 0
                obj.coins = obj.coins + delta_coins;
            end
            
        end
        
    end
end

