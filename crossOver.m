function [child1, child2] = crossOver(parent1, parent2)
crossThres = 0.6;

% uniform cross over for all binary representation
numCards = length(parent1.gain_priority);
if (rand < crossThres)
    for i = 1:numCards
        %second row of gain priority
        if (rand <= 0.5)
            temp = parent1.gain_priority(2,i);
            parent1.gain_priority(2,i) = parent2.gain_priority(2,i);
            parent2.gain_priority(2,i) = temp;
        end
    end
end
if (rand < crossThres)
    for i = 1:numCards
        % first row of gain_cutoffs
        if (rand <= 0.5)
            temp = parent1.gain_cutoffs(1,i);
            parent1.gain_cutoffs(1,i) = parent2.gain_cutoffs(1,i);
            parent2.gain_cutoffs(1,i) = temp;
        end
    end
end
if (rand < crossThres)
    for i = 1:numCards
        %second row of trash_priority
        if (rand <= 0.5)
            temp = parent1.trash_priority(2,i);
            parent1.trash_priority(2,i) = parent2.trash_priority(2,i);
            parent2.trash_priority(2,i) = temp;
        end
    end
end
% blend cross over at each column for other representation
for i = 1:numCards
    %second row of gain cutoffs
    if (rand < crossThres)
        r = rand;
        x1 = parent1.gain_cutoffs(2,i);
        x2 = parent2.gain_cutoffs(2,i);
        parent1.gain_cutoffs(2,i) = r*x1+(1-r)*x2;
        parent2.gain_cutoffs(2,i) = (1-r)*x1+r*x2;
    end
    % third row of gain cutoffs
    if (rand < crossThres)
        r = rand;
        x1 = parent1.gain_cutoffs(3,i);
        x2 = parent2.gain_cutoffs(3,i);
        parent1.gain_cutoffs(3,i) = r*x1+(1-r)*x2;
        parent2.gain_cutoffs(3,i) = (1-r)*x1+r*x2;
    end
end
child1 = parent1;
child2 = parent2;