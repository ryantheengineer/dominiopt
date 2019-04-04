clc;clear;dbstop if error;
generation = 15;
population = 20;
numcompete = 3;

% Initialize cards
cardlist;
cards = [province duchy estate curse gold silver copper village woodcutter smithy festival market bureaucrat witch councilroom moat mine];


% generate initial parents
for i = 1:population
    Parents(i) = gene();
end


for currentGeneration = 1:generation
    %second param = number of parents in a competition
    winners = tournament(Parents,numcompete,cards,firstcards);
    children = [];
    for i = 1:length(winners)/2
        [child1,child2] = crossOver(winners(i),winners(i+1));
        children = [children,child1,child2];
    end
    for i = 1:length(children)
        result(i) = mutate(children(i), currentGeneration, generation);
    end
    
    %Elitism
    eliSet = [Parents,result];
    for i = 1:length(eliSet)
        Score(i) = getScore(eliSet(i),cards,firstcards);
    end
    keepSize = length(Parents);
    [B,I] = maxk(Score,keepSize);
    for i = 1:keepSize
        Parents(i) = eliSet(I(i));
    end
    [scoreHistory(currentGeneration), ind] = max(Score);
    playHistory(currentGeneration) = eliSet(ind);
end
[value, index] = max(Score)

disp('Best strategy:');
interpret_gene(eliSet(index),cards);