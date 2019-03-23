function [gain_priority,gain_cutoffs,play_priority,discard_priority,trash_priority] = random_strategy(cards)
    % ONLY GOOD FOR GENERATING COMPLETELY NEW STRATEGIES, NOT BASED ON
    % PREVIOUS PARENTS (MIGHT NOT BE IMPLEMENTED IN THE FINAL PROJECT, BUT
    % USEFUL FOR TESTING GAMEPLAY WITH RANDOM STRATEGIES TO SEE IF IT
    % BREAKS)
    numcards = length(cards);
    
    % Generate integer lists 
    gain_priority = linspace(1,numcards,numcards);
    gain_cutoffs = linspace(1,numcards,numcards);
    play_priority = linspace(1,3,3);
%     play_priority = linspace(1,numcards,numcards);
    discard_priority = linspace(1,numcards,numcards);
    trash_priority = linspace(1,numcards,numcards);
    
    gain_priority = shuffle(gain_priority);
    gain_cutoffs = shuffle(gain_cutoffs);
    play_priority = shuffle(play_priority);
    discard_priority = shuffle(discard_priority);
    trash_priority = shuffle(trash_priority);

end