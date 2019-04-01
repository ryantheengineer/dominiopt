function [gain_priority,gain_cutoffs,play_priority,trash_priority] = random_strategy(cards)
    % ONLY GOOD FOR GENERATING COMPLETELY NEW STRATEGIES, NOT BASED ON
    % PREVIOUS PARENTS (MIGHT NOT BE IMPLEMENTED IN THE FINAL PROJECT, BUT
    % USEFUL FOR TESTING GAMEPLAY WITH RANDOM STRATEGIES TO SEE IF IT
    % BREAKS)
    numcards = length(cards);
    
    % Generate integer lists 
    gain_priority(1,:) = linspace(1,numcards,numcards); % Order in which cards should be preferred
    gain_priority(2,:) = randi([0 1],1,numcards); % Turn on or off a preference (use it or ignore it)
    gain_priority(2,1:7) = [1 1 1 0 1 1 1];
    gain_cutoffs(1,:) = randi([0 1],1,numcards); % Choose which cutoff to use (0 for ratio, 1 for cards left on table)
    gain_cutoffs(2,:) = unifrnd(0,1,[1,numcards]); % Random numbers between 0 and 1, continuous (for ratio of cards desired versus deck size)
    gain_cutoffs(3,:) = randi([0 8],1,numcards); % Random integers between some limits (might need to be different limits depending on the card), but values can repeat
%     gain_switch = randi([0 1],1,numcards); % 1 x numcards vector of 1s and 0s
    play_priority = linspace(1,10,10);
%     discard_priority = linspace(1,numcards,numcards); % might be unneeded, but Strategy class would need to be altered
    trash_priority(1,:) = linspace(1,numcards,numcards);
    trash_priority(2,:) = randi([0 1],1,numcards); % 1 x numcards vector of 1s and 0s
    
    gain_priority(1,:) = shuffle(gain_priority(1,:));
%     gain_cutoffs = shuffle(gain_cutoffs);
    play_priority = shuffle(play_priority);
%     discard_priority = shuffle(discard_priority);
    trash_priority(1,:) = shuffle(trash_priority(1,:));

end