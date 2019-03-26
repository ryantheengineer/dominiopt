function [avg_score_margin] = Dominion(ngames,players,strategies,cards,firstcards)
    %DOMINION: Create a game and simulate it ngames times, and output the
    %average score margin between the target player (index called out by
    %target_player) and the highest-scoring other player
    numplayers = length(players);
    Scores = zeros(ngames,numplayers);
    Margins = zeros(ngames,(numplayers-1));
    maxMargins = zeros(ngames,1);
    
    % Load a Game object with the players, strategies, and cards
    game = Game(players,strategies,cards);
    
    
    for i = 1:ngames
        game.play_game(firstcards);
        game.get_scores;
        Scores(i,:) = game.scores;
        Margins(i,:) = game.margins;
        if numplayers == 2
            maxMargins(i) = Margins(i);
        else
            maxMargins(i) = max(Margins(i,2:end));
        end
    end
    
    % Calculate the average score margin for the number of simulations
    % performed
    
    avg_score_margin = mean(maxMargins);
    
end

