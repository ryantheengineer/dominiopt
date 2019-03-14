classdef ChapelClass < handle
    %UNTITLED3 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (SetAccess = immutable)
        name = 'Chapel'
        cost = 2
        treasure = 0
        vp = 0
        coins = 0
        cards = 0
        actions = 0
        buys = 0
%         potionCost
%         effect            % NEED AN EFFECT HERE
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

