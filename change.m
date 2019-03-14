function y = change(x,delta_actions,delta_buys,delta_coins)
% Change property values of PlayerState class based on cards from this hand
% To work as intended, the instance of the PlayerState class must be
% overwritten using this function in the main script, as follows:

% player1 = PlayerState(1);    % Initializes with only an integer defining
% the player number
% % change the number of actions, buys, and coins the player has right now
% player1 = change(player1,delta_actions,delta_buys,delta_coins);
% 
    x.actions = x.actions + delta_actions;
    x.buys = x.buys + delta_buys;
    x.coins = x.coins + delta_coins;
    y = x;
end