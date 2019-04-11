function AIStrategy = chooseOpponent(AIname)
% Choose and create an 
    switch AIname
        case 'BigMoney'
            %Requires: basic setup (order of cards doesn't matter)
            % cards = [province duchy estate curse gold silver copper ...
            %          village woodcutter smithy festival market bureaucrat chapel cellar moat harbinger];
            gain_priority =  [1  3  6  17 2  4  5  7  8  9  10 11 12 13 14 15 16;
                              1  1  1  0  1  1  1  0  0  0  0  0  0  0  0  0  0];
            gain_cutoffs =   [1  1  1  1  1  1  1  1  1  1  1  1  1  1  1  1  1;
                              1  1  1  1  1  1  1  1  1  1  1  1  1  1  1  1  1;
                              12 12 12 12 12 12 12 12 12 12 12 12 12 12 12 12 12];
            play_priority =  [1  2  3  4  5  6  7  8  9  10];
            trash_priority = [17 16 15 1  14 13 12 11 10 9  8  7  6  5  4  3  2;
                              0  0  0  1  0  0  0  0  0  0  0  0  0  0  0  0  0];
            
        case 'BigSmithy'
            %Requires: Smithy (put smithy as first action, nothing else
            %matters)
            % cards = [victory... smithy...doesn't matter]
            gain_priority =  [1  2  3  17 4  6  7  5  8  9  10 11 12 13 14 15 16;
                              1  1  1  0  1  1  1  1  0  0  0  0  0  0  0  0  0];
            gain_cutoffs =   [1  1  1  1  1  1  1  0  1  1  1  1  1  1  1  1  1;
                              1  1  1  1  1  1  1  0.125 1  1  1  1  1  1  1  1  1;
                              6  5  2  12 12 12 3  12 12 12 12 12 12 12 12 12 12];
            play_priority =  [1  2  3  4  5  6  7  8  9  10];
            trash_priority = [17 16 15 1  14 13 12 11 10 9  8  7  6  5  4  3  2;
                              0  0  0  1  0  0  0  0  0  0  0  0  0  0  0  0  0];
            
                          
                          
        case 'DoubleWitch'
            % Requires: Witch (put witch in 2nd position so it doesn't
            % conflict with BigSmithy)
            gain_priority =  [1  3  4  17 5  6  7  8  2  9  10 11 12 13 14 15 16;
                              1  1  1  0  1  1  1  0  1  0  0  0  0  0  0  0  0];
            gain_cutoffs =   [1  1  1  1  1  1  1  1  0  1  1  1  1  1  1  1  1;
                              1  1  1  1  1  1  1  1 0.1 1  1  1  1  1  1  1  1;
                              12 5  2  12 12 12 12 12 12 12 12 12 12 12 12 12 12];
            play_priority =  [10  1  2  3  4  5  6  7  8  9];
            trash_priority = [17 16 15 1  14 13 12 11 10 9  8  7  6  5  4  3  2;
                              0  0  0  1  0  0  0  0  0  0  0  0  0  0  0  0  0];
            
                          
        case 'Spencer'
            % Requires:
            % cards = [province duchy estate curse gold silver copper smithy witch village woodcutter festival market bureaucrat councilroom moat mine]
            gain_priority =  [1  2  3  17 5  6  7  8  9  10 11 4  12 13 14 15 16;
                              1  1  1  0  1  1  1  0  0  0  0  1  0  0  0  0  0];
            gain_cutoffs =   [1  1  1  1  1  1  1  1  1  1  1  0  1  1  1  1  1;
                              1  1  1  1  1  1  1  1  1  1  1  0.4  1  1  1  1  1;
                              12 6  3  12 12 12 12 12 12 12 12 12 12 12 12 12 12];
            play_priority =  [0  0  0  0  1  0  0  0  0  0];
            trash_priority = [17 16 15 1  14 13 12 11 10 9  8  7  6  5  4  3  2;
                              0  0  0  1  0  0  0  0  0  0  0  0  0  0  0  0  0];
            
%         case 'UpgradeTrash'
%             %Requires: 
%             gain_priority = [];
%             gain_cutoffs = [];
%             play_priority = [];
%             trash_priority = [];
            
        
        otherwise
            error('No valid opponent strategy specified');
    end
    
    AIStrategy = Strategy(gain_priority,gain_cutoffs,play_priority,trash_priority);


end