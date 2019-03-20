function [] = random_strategy(cards)
    % Take in list of cards being used this game and output random strategy
    % arrays to feed into a Strategy class constructor
    nvictory = 0;
    ntreasure = 0;
    naction = 0;
    
    for i = 1:length(cards)
        if cards(i).isVictory == true
            nvictory = nvictory + 1;
        elseif cards(i).isTreasure == true
            ntreasure = ntreasure + 1;
        elseif cards(i).isAction == true
            naction = naction + 1;
        else
            error('Something is wrong with a card input');
        end
    end
    
    

end