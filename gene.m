classdef gene
    properties
        gain_priority
        gain_cutoffs
        play_priority
        trash_priority
    end
    methods
        function obj = gene()
            numCards =17;
            obj.gain_priority(1,:) = randperm(numCards);
            obj.gain_priority(2,:) = randi([0 1],1,numCards);
            
            obj.gain_cutoffs(1,:) = randi([0 1],1,numCards);
            obj.gain_cutoffs(2,:) = rand(1,numCards);
            for i = 1:3
                obj.gain_cutoffs(3,i) = randi([2 12]);
            end
            for i = 4:6
                obj.gain_cutoffs(3,i) = randi([2 12]);
            end
            for i = 7:numCards
                obj.gain_cutoffs(3,i) = randi([2 12]);
            end
            
            obj.play_priority(1,:) = randperm(10);
            
            obj.trash_priority(1,:) = randperm(numCards);
            obj.trash_priority(2,:) = randi([0 1],1,numCards);
        end

    end
end