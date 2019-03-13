classdef Card
    %UNTITLED3 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
%         Property1
        name
        cost
        treasure
        vp
        coins
        cards
        actions
        buys
%         potionCost
%         effect
        isAttack
        isDefense
%         reaction
%         duration
    end
    
    methods
        % Constructor method for Card class
        function obj = Card(name,cost,treasure,coins,cards,actions,buys,...
                isAttack,isDefense)
            %UNTITLED3 Construct an instance of this class
            %   Detailed explanation goes here
            
            if nargin > 0
                obj.name = name;
                obj.cost = cost;
                obj.treasure = treasure;
                obj.vp = vp;
                obj.coins = coins;
                obj.cards = cards;
                obj.actions = actions;
                obj.buys = buys;
                obj.isAttack = isAttack;
                obj.isDefense = isDefense;
            else
                error('Not enough arguments')
            end
        end
        
        % Need method for implementing actions, card draws, or buys
        function outputArg = method1(obj,inputArg)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            outputArg = obj.Property1 + inputArg;
        end
    end
end

