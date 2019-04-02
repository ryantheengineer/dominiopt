function AIStrategy = chooseOpponent(AIname)
% Choose and create an 
    switch AIname
        case 'BigMoney'
            %Requires: 
            % cards = [province duchy estate curse gold silver copper village woodcutter smithy festival market bureaucrat chapel cellar moat harbinger];
            gain_priority =  [1  3  6  17 2  4  5  7  8  9  10 11 12 13 14 15 16;
                              1  1  1  0  1  1  1  0  0  0  0  0  0  0  0  0  0];
            gain_cutoffs =   [1  1  1  1  1  1  1  1  1  1  1  1  1  1  1  1  1;
                              1  1  1  1  1  1  1  1  1  1  1  1  1  1  1  1  1;
                              12 12 12 12 12 12 12 12 12 12 12 12 12 12 12 12 12];
            play_priority =  [1  2  3  4  5  6  7  8  9  10];
            trash_priority = [17 16 15 1  14 13 12 11 10 9  8  7  6  5  4  3  2;
                              0  0  0  1  0  0  0  0  0  0  0  0  0  0  0  0  0];
            
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