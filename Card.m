classdef Card < handle
    %UNTITLED3 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        name = [];
        cost = 0;
        treasure = 0;
        vp = 0;
        coins = 0;
        cards = 0;
        actions = 0;
        buys = 0;
        effect = [];
        isAttack = false;
        isDefense = false;
    end
    
    methods
        % Constructor method for Card class
        function obj = Card(name,cost,treasure,vp,coins,cards,actions,buys,...
                effect,isAttack,isDefense)
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
                obj.effect = effect;
                obj.isAttack = isAttack;
                obj.isDefense = isDefense;
            else
                error('Not enough arguments')
            end
        end
        
%         % Need method for implementing actions, card draws, or buys
%         function outputArg = method1(obj,inputArg)
%             %METHOD1 Summary of this method goes here
%             %   Detailed explanation goes here
%             outputArg = obj.Property1 + inputArg;
%         end
    end
end

