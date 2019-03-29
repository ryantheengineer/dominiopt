function AIStrategy = chooseOpponent(AIname)
% Choose and create an 
    switch AIname
        case 'BigMoney'
            gain_priority = [];
            gain_cutoffs = [];
            play_priority = [];
            trash_priority = [];
            
        
        otherwise
            error('No valid opponent strategy specified');
    end
    
    AIStrategy = Strategy(gain_priority,gain_cutoffs,play_priority,trash_priority);


end