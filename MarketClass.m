classdef MarketClass < handle
    %UNTITLED3 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (SetAccess = immutable)
        name = 'Market'
        cost = 5
        treasure = 0
        vp = 0
        coins = 1
        cards = 1
        actions = 1
        buys = 1
%         potionCost
%         effect
        isAttack = false
        isDefense = false
%         reaction
%         duration
    end
    
    methods        
        % Need method for implementing actions, card draws, or buys
%         function outputArg = method1(obj,inputArg)
%             %METHOD1 Summary of this method goes here
%             %   Detailed explanation goes here
%             outputArg = obj.Property1 + inputArg;
%         end
    end
end

