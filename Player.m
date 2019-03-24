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
        
        
        function [buysleft] = buyable(obj)
            % Can this hand still buy a card?
            buysleft = obj.buys > 0;
        end
        
        
        function [actionsleft] = actionable(obj)
            % Are there actions left to take with this hand?
            if obj.actions > 0
                n = length(obj.hand);
                numActionCards = 0;
                for i = 1:n
                    if obj.hand(i).isAction == true
                        numActionCards = numActionCards + 1;
                    end
                end
                if numActionCards > 0
                    actionsleft = true;
                end
            else
                actionsleft = false;
            end
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
           
            if length(obj.drawpile) < n
                % Shuffle the discard pile
                Discard = obj.discard;
                N = numel(Discard);
                ii = randperm(N);
                Discard_shuffled = Discard(ii);
                
                % Append the shuffled discard pile to the draw pile
                Drawpile = obj.drawpile;
                Drawpile = [Drawpile,Discard_shuffled];
                obj.drawpile = Drawpile;
                
                % Clear the discard
                obj.discard = [];
            end
           
            drawn = obj.drawpile(1:n);
            drawpile_remaining = obj.drawpile((n+1):end);
            Hand = obj.hand;
            Hand = [Hand,drawn];
            obj.hand = Hand;
            obj.drawpile = drawpile_remaining;         
            
        end
        
        % CREATE FUNCTION HERE THAT DISCARDS ENTIRE HAND?
%         function discard_hand(obj)
%             
%         end
        
        
        function next_turn(obj)
            % First, discard everything. Then get 5 cards, 1 action, and 1
            % buy
            Discard = obj.discard;
            Hand = obj.hand;
            Tableau = obj.tableau;
            
            obj.discard = [Discard,Hand,Tableau];
            
            % Empty hand and tableau of cards
            obj.hand = [];
            obj.tableau = [];
            
            obj.actions = 1;
            obj.buys = 1;
            obj.coins = 0;
            
            obj.draw(5);
            
        end
        
        
        function gain(obj,card)
            % Gain a single card
            Discard = obj.discard;
            obj.discard = [Discard,card];
        end
        
        
        function gain_cards(obj,cards)
            % Gain multiple cards
            Discard = obj.discard;
            obj.discard = [Discard,cards];
        end
                    
        
        function trash_card(obj,card)
            % Remove a card from the game
            
            % Get index of card in hand (could find multiple)
            Hand = obj.hand;
            index = find(Hand == card);
            
            if isempty(index)
                error('Can''t trash a card that isn''t in your hand!');
            end
            
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
        
        
        function display_hand(obj)
            disp('Hand includes:');
            for i = 1:length(obj.hand)
                disp(obj.hand(i).name);
            end
        end
        
        function play_card(obj,card)
            % Play a card from the hand into the tableau. Decreasing the
            % number of actions available is handled in play_action.
            Hand = obj.hand;
            index = find(Hand == card);
            if isempty(index)
                error('Can''t play a card that isn''t in your hand!');
            end
            n = length(Hand);
            
            % Remove the card from hand (NEED TO IMPLEMENT THIS IN TRASH
            % AND DRAW FUNCTIONS AS WELL)
            cardloc = index(1);
            Hand(cardloc) = [];            
            obj.hand = Hand;
            
            % Put the card into the tableau
            Tableau = obj.tableau;
            Tableau = [Tableau,card];
            obj.tableau = Tableau;
        end
        
        
        function play_action(obj,card)
            % Verify that the card chosen is an action card
            if card.isAction == false
                error('This isn''t an action card!');
            end
            
            % Verify that the player still has actions left to use
            assert(obj.actions > 0);
            
            % Use play_card and decrease the number of actions by 1
            obj.play_card(card);
            obj.change(-1,0,0);
        end
        
        %%%%%%% Functions for enacting external effects from other players'
        %%%%%%% played cards
        function bureaucrat_effect(obj)
            count = 0;
            Hand = obj.hand;
            for i = 1:length(Hand)
                if (Hand(i).isVictory == true) && (count < 1)
                    Drawpile = obj.drawpile;
                    Drawpile = [obj.hand(i),Drawpile];
                    obj.drawpile = Drawpile;
                    obj.hand(i) = [];
                    count = count + 1;
                end
            end
        end
        
        
            
        
        function bandit_effect(obj)
            % Draw function appends new card to the end of the hand
            obj.draw(2);
            Hand = obj.hand;
            n = length(Hand);
            
            firstcard = Hand(n-1);
            firstflag = false;
            secondcard = Hand(n);
            secondflag = false;
            
            first_notcopper = true;
            second_notcopper = true;
            
            if firstcard == copper
                first_notcopper = false;
            end
            if secondcard == copper
                second_notcopper = false;
            end
            
            
            if firstcard.isTreasure && first_notcopper == true
                firstflag = true;
            end
            if secondcard.isTreasure && second_notcopper == true
                secondflag = true;
            end
            
            if firstflag == true && secondflag == false
                obj.trash_card(firstcard);
            elseif firstflag == false && secondflag == true
                obj.trash_card(secondcard);
            elseif firstflag == true && secondflag == true
                firstval = firstcard.treasure;
                secondval = secondcard.treasure;
                
                if firstval <= secondval
                    obj.trash_card(firstcard);
                else
                    obj.trash_card(secondcard);
                end
            end
            
        end
        
            
            
            
        % Militia effects might need to be handled at the game level since
        % it involves a discard priority list
%         function militia_effect(obj)
    end
    
end

