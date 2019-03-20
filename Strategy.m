classdef Strategy < handle
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
%         Property1
        nvictory = 3;       % Number of victory cards being used
        ntreasure = 3;      % Number of treasure cards being used
        naction = 10;       % Number of action cards being used
        ncards = nvictory + ntreasure + naction;
        cards = Card.empty(ncards);
        gain_priority = zeros(ncards);      % list of unique integers that specifies the order in which to gain cards (buy or automatically get)
        gain_cutoffs = zeros(ncards);
        play_priority = zeros(ncards);
        discard_priority = zeros(ncards);
        
        
    end
    
    methods
        function obj = Strategy(inputArg1,inputArg2)
            %UNTITLED Construct an instance of this class
            %   Detailed explanation goes here
            obj.Property1 = inputArg1 + inputArg2;
        end
        
        function outputArg = method1(obj,inputArg)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            outputArg = obj.Property1 + inputArg;
        end
    end
end

