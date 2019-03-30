function AIStrategy = chooseOpponent(AIname)
% Choose and create an 
    switch AIname
        case 'BigMoney'
            %Requires: 
            gain_priority = [];
            gain_cutoffs = [];
            play_priority = [];
            trash_priority = [];
            
        case 'BigSmithy'
            %Requires: 
            gain_priority = [];
            gain_cutoffs = [];
            play_priority = [];
            trash_priority = [];
            
        case 'UpgradeTrash'
            %Requires: 
            gain_priority = [];
            gain_cutoffs = [];
            play_priority = [];
            trash_priority = [];
            
        
        otherwise
            error('No valid opponent strategy specified');
    end
    
    AIStrategy = Strategy(gain_priority,gain_cutoffs,play_priority,trash_priority);


end