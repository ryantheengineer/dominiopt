function [avg_score_margin] = Dominiopt(gain_priority,gain_cutoffs,play_priority,trash_priority,cards,firstcards)
% Translator function for going from genetic algorithm inputs (arrays of
% numbers) to running the Dominion function and returning the
% avg_score_margin. Also asks for the strategies to be used by the opposing
% players, and infers the total number of players from the number of
% strategies fed in.
    ngames = 50;
    numplayers = 3;
    
    player1 = Player(1);
    player2 = Player(2);
    player3 = Player(3);
%     player4 = Player(4);
    
    players = [player1,player2,player3]; % Change this to alter the number of players
%     assert(length(players) == numplayers);
    
    % Create strategies
    strategy1 = Strategy(gain_priority,gain_cutoffs,play_priority,trash_priority);
    strategy2 = chooseOpponent('BigMoney');
    strategy3 = chooseOpponent('BigSmithy');
%     strategy4 = chooseOpponent('DoubleWitch');
    
    strategies = [strategy1,strategy2,strategy3];
    assert(length(strategies) == numplayers);
    
    avg_score_margin = Dominion(ngames,players,strategies,cards,firstcards);
end