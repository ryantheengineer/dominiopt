classdef Strategy < handle
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        gain_priority;      % list of unique integers that specifies the order in which to gain cards (buy or automatically get)
        gain_cutoffs;       % priority index list for cutoffs (when to buy or not buy a card). Might need to be 2 columns instead of 1 for the 2 cutoff types
        play_priority;      % priority index list for cards to play
        trash_priority;     % priority index list for trashing cards (may not implement for project to keep things simple)
        
    end
    
    methods
        function obj = Strategy(gain_priority,gain_cutoffs,play_priority,trash_priority)
            %UNTITLED Construct an instance of this class
            % COULD ASSERT DIMENSIONS OF PROPERTIES HERE
            obj.gain_priority = gain_priority;
            obj.gain_cutoffs = gain_cutoffs;
            obj.play_priority = play_priority;
            obj.trash_priority = trash_priority;
        end
        
%         function outputArg = method1(obj,inputArg)
%             %METHOD1 Summary of this method goes here
%             %   Detailed explanation goes here
%             outputArg = obj.Property1 + inputArg;
%         end
    end
end

