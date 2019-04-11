clc;clear;dbstop if error;
generation = 5;
population = 5;
numcompete = 2; % Number of individuals pitted against each other in tournament selection

% Initialize cards
cardlist;
cards = [province duchy estate curse gold silver copper smithy witch village woodcutter festival market bureaucrat councilroom moat chapel];


% generate initial parents
for i = 1:population
    Parents(i) = gene();
end

BestDesign = [];
secondDesign = [];
thirdDesign = [];
for currentGeneration = 1:generation
    currentGeneration
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
    eliSet = [Parents,result, BestDesign,secondDesign,thirdDesign];
    for i = 1:length(eliSet)
        Score(i) = getScore(eliSet(i),cards,firstcards);
    end
    keepSize = length(Parents);
    [B,I] = maxk(Score,keepSize);
    for i = 1:keepSize
        Parents(i) = eliSet(I(i));
    end
    [value, index] = max(Score);
    [scoreHistory(currentGeneration), ind] = max(Score); % Save the maximum score from each generation (what does ind do here?)
    Score(ind) = -Inf;
    [secondScore, ind2] = max(Score);
    Score(ind2) = -Inf;
    [thirdScore, ind3] = max(Score);
    BestDesign = eliSet(ind);
    secondDesign = eliSet(ind2);
    thirdDesign = eliSet(ind3);
    playHistory(currentGeneration) = BestDesign;
end
value
index

disp('BEST STRATEGY:');
interpret_gene(eliSet(index),cards);