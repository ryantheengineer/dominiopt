function [child] = mutate(parentGene, currentGeneration)
numCards = length(parentGene.gain_priority);
switchThres = 0.4;
mutateThres = 0.2;
beta = 1;
alpha = (1-(currentGeneration-1)/mutateThres)^beta;
% for gain_priority
for i = 1:numCards
    % for first row (1~17, no repeated values)
    if (rand < switchThres)
        num1 = randi([1 numCards]);
        num2 = parentGene.gain_priority(1,i);
        index = find(parentGene.gain_priority(1,:)==num1, 1, 'first');
        parentGene.gain_priority(1,index) = num2;
        parentGene.gain_priority(1,i) = num1;      
    end
    % for second row mutation(binary)
    if (rand < mutateThres)
        parentGene.gain_priority(2,i) = round(rand);
    end   
end
% for gain_cutoffs
for i = 1:numCards
    % for first row (binary)
    if (rand < mutateThres)
        parentGene.gain_cutoffs(1,i) = round(rand);
    end
    % for second row (continusous number between 0 and 1)
    if (rand < mutateThres)
        r = rand;
        x = parentGene.gain_cutoffs(2,i);
        if (r <= x)
            parentGene.gain_cutoffs(2,i) = (r^alpha)*x^(1-alpha);
        elseif (r > x)
            parentGene.gain_cutoffs(2,i) = 1-((1-r)^alpha)*(1-x)^(1-alpha);
        end
    end
    % for third row (each col has desire max values) => later  
        
end
% for play_priority   %%%%%%%%%%%%%%%% May need to change
for i = 1:10
    if (rand < switchThres)
        num1 = randi([0 10]);
        num2 = parentGene.play_priority(1,i);
        index = find(parentGene.play_priority(1,:)==num1, 1, 'first');
        parentGene.play_priority(1,index) = num2;
        parentGene.play_priority(1,i) = num1;      
    end    
end
% for trash_priority
for i = 1:numCards
    if (rand < switchThres)
        num1 = randi([0 numCards]);
        num2 = parentGene.trash_priority(1,i);
        index = find(parentGene.trash_priority(1,:)==num1, 1, 'first');
        parentGene.trash_priority(1,index) = num2;
        parentGene.trash_priority(1,i) = num1;
    end
end

%%% gain_cutoffs thrid row
for i = 1:3
    if (rand < mutateThres)
        r = randi([0 12]);
        x = parentGene.gain_cutoffs(3,i);
        if (r <= x)
            parentGene.gain_cutoffs(3,i) = round((r^alpha)*x^(1-alpha));
        elseif (r > x)
            parentGene.gain_cutoffs(3,i) = round(12-((12-r)^alpha)*(12-x)^(1-alpha));
        end
    end
end
for i = 4:6
    if (rand < mutateThres)
        r = randi([0 30]);
        x = parentGene.gain_cutoffs(3,i);
        if (r <= x)
            parentGene.gain_cutoffs(3,i) = round((r^alpha)*x^(1-alpha));
        elseif (r > x)
            parentGene.gain_cutoffs(3,i) = round(30-((30-r)^alpha)*(30-x)^(1-alpha));
        end
    end
end
for i = 7:numCards
    if (rand < mutateThres)
        r = randi([0 10]);
        x = parentGene.gain_cutoffs(3,i);
        if (r <= x)
            parentGene.gain_cutoffs(3,i) = round((r^alpha)*x^(1-alpha));
        elseif (r > x)
            parentGene.gain_cutoffs(3,i) = round(10-((10-r)^alpha)*(10-x)^(1-alpha));
        end
    end
end
child = parentGene;


