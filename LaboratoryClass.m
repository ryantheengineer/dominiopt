classdef LaboratoryClass < handle
    %UNTITLED3 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (SetAccess = immutable)
        name = 'Laboratory'
        cost = 5
        treasure = 0
        vp = 0
        coins = 0
        cards = 2
        actions = 1
        buys = 0
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
