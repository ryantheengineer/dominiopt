function showcards(player)
    disp('Hand includes:');
    for i = 1:length(player.hand)
        disp(player.hand(i).name);
    end

%     disp(' ');
%     
%     disp('Drawpile includes:');
%     for i = 1:length(player.drawpile)
%         disp(player.drawpile(i).name);
%     end
    

end