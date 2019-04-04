function interpret_gene(chosen_gene,cards)
    % Print out the strategy of the chosen gene (won't work on a strategy
    % class, but the structure should be the same)
    
    disp('Player Strategy:');
    disp('Play action cards in this order:');
    actioncards = cards(8:17);
    for i = 1:10
        Iplay = find(chosen_gene.play_priority == i);
        if chosen_gene.gain_priority(2,(Iplay+7)) == 1
            preferred_action = actioncards(Iplay);
            actstr = sprintf('\t %s',preferred_action.name);
            disp(actstr);
        end
    end
    
    disp('Buy these cards in this order of preference, under conditions:');
    for i = 1:17
        Igain = chosen_gene.gain_priority(1,:) == i;
        if chosen_gene.gain_priority(2,Igain) == 1
            % If percent constraint, show that
            if chosen_gene.gain_cutoffs(1,Igain) == 0
                gainstr = sprintf('\t %s if percentage of %s in deck is less than %0.2f',...
                    cards(Igain).name, cards(Igain).name, (chosen_gene.gain_cutoffs(2,Igain)));
                disp(gainstr);
                
            % If cards left constraint, show that
            else
                gainstr = sprintf('\t %s if a single victory pile or three action piles have less than %d cards left',...
                    cards(Igain).name, chosen_gene.gain_cutoffs(3,Igain));
                disp(gainstr);
                
            end
        end
    end
    
    
    disp('Trash these cards in this order:');
    for i = 1:17
        Itrash = chosen_gene.trash_priority(1,:) == i;
        if chosen_gene.trash_priority(2,Itrash) == 1
            preferred_trash = cards(Itrash);
            trashstr = sprintf('\t %s',preferred_trash.name);
            disp(trashstr);
        end
    end
    


end