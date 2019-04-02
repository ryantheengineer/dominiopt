function [winner] = tournament(parents,size,cards,firstcards)
% size = number of parents to compete with each other
numParents = length(parents);
for j = 1:numParents
    for i = 1:size
        designNum(i) = 1 + floor(rand*numParents);
        Score(i) = getScore(parents(designNum(i)),cards,firstcards);
    end
    [value, index] = max(Score);
    winner(j) = parents(designNum(index));
end

