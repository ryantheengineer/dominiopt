classdef Player < handle
    % From dominiate-python repository:
    % "A PlayerState represents all the game state that is particular to a
    % player, including the number of actions, buys, and +coins they have.
    
    properties
        player;           % int
        actions     = 1;  % int
        buys        = 1;  % int
        coins       = 0;  % int
        hand        = []; % card array
        drawpile    = []; % card array
        discard     = []; % card array
        tableau     = []; % card array
    end
    
    methods
        function obj = Player(player)
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
        
        
        function initialize(obj,firstcards)
            % Initialize with 7 Copper and 3 Estate cards. firstcards must
            % be a 1x2 array with copper first and estate second.
            drawpile_0 = repelem(firstcards,[7,3]);
            
            % Randomly shuffle the cards so they are ready to be drawn
            n = numel(drawpile_0);
            ii = randperm(n);
            drawpile_0 = drawpile_0(ii);
            obj.drawpile = drawpile_0;
            
            obj.draw(5);
            
        end
        
        
        function draw(obj,n)
           if length(obj.drawpile) >= n
               drawn = obj.drawpile(1:n);
               drawpile_remaining = obj.drawpile((n+1):end);
               Hand = obj.hand;
               Hand = [Hand,drawn];
               obj.hand = Hand;
               obj.drawpile = drawpile_remaining;
               
           else
               % Shuffle the discard and append it to the drawpile, after
               % any cards that might be remaining
               Discard = obj.discard;
               n = numel(Discard);
               ii = randperm(n);
               Discard_shuffled = Discard(ii);
               Drawpile = obj.drawpile;
               Drawpile = [Drawpile,Discard_shuffled];
               obj.drawpile = Drawpile;
               
               % Clear the discard
               obj.discard = [];
               
           end
           % LATER IMPLEMENT WHAT TO DO IF THERE ARE FEWER CARDS LEFT IN
           % THE DRAWPILE THAN NEED TO BE DRAWN
           
            
        end
        
        
        function next_turn(obj)
            % First, discard everything. Then get 5 cards, 1 action, and 1
            % buy
            Discard = obj.discard;
            Hand = obj.hand;
            Tableau = obj.tableau;
            
            % If used incorrectly, this makes the discard and hand
            % properties grow when they shouldn't. Rewrite so the discard
            % doesn't grow absurdly
%             obj.discard = [obj.discard,obj.hand,obj.tableau];
            obj.discard = [Discard,Hand,Tableau];
            
            obj.hand = [];
            
            obj.actions = 1;
            obj.buys = 1;
            obj.coins = 0;
            
            obj.draw(5); % ADD DRAW FUNCTION LATER
            
        end
        
        
        function gain(obj,card)
            % Gain a single card
            Discard = obj.discard;
            obj.discard = [Discard,card];
        end
                    
        
        function trash_card(obj,card)
            % Remove a card from the game
            
            % Get index of card in hand (could find multiple)
            Hand = obj.hand;
            index = find(Hand == card);
            
            n = length(Hand);
            
            % Trash the first instance of card if multiple
            cardloc = index(1);
            if cardloc == 1
                Hand = Hand(2:n);
            elseif index(1) == n
                Hand = Hand(1:(n-1));
            else
                Hand = [Hand(1:cardloc-1),Hand((cardloc+1),n)];
            end
            
            obj.hand = Hand;
        end
        
        
        function discard_card(obj,card)
            % Discard a single card from the hand
            Hand = obj.hand;
            Discard = obj.discard;
            index = find(Hand == card);
            
            if isempty(index)
                error('Can''t discard a card that isn''t in your hand!');
            end
            
            n = length(Hand);
            
            cardloc = index(1);
            if cardloc == 1
                Hand = Hand(2:n);
            elseif cardloc == n
                Hand = Hand(1:(n-1));
            else
                Hand = [Hand(1:(cardloc-1)),Hand((cardloc+1):n)];
            end
            
            obj.hand = Hand;
            Discard = [Discard,card];
            obj.discard = Discard;
        end
        
        
        function play_card(obj,card)
            % Play a card from the hand into the tableau. Decreasing the
            % number of actions available is handled in play_action.
            Hand = obj.hand;
            index = find(Hand == card);
            
            % Remove the card from hand
            cardloc = index(1);
            if cardloc == 1
                Hand = Hand(2:n);
            elseif index(1) == n
                Hand = Hand(1:(n-1));
            else
                Hand = [Hand(1:cardloc-1),Hand((cardloc+1),n)];
            end
            obj.hand = Hand;
            
            % Put the card into the tableau
            Tableau = obj.tableau;
            Tableau = [Tableau,card];
            obj.tableau = Tableau;
        end
        
%         function gain_cards(obj,cards)
%             % Gain multiple cards
%             Discard = obj.discard;
%             obj.discard = [Discard,cards];
%         end
%         
%         
        
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
            
        
%         NEED TO MAKE THIS SYNTAX MORE MATLAB-FRIENDLY
%         function totalcoins = hand_value(obj)
%             % How many coins can the player spend?
%             totalcoins = obj.coins + sum(card.treasure for card in obj.hand)
%             end
        
    end
    
end

