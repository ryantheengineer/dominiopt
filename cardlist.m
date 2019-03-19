% Victory point cards
curse = Card('Curse',0,0,-1,0,0,0,0,[],false,true,false,false,false,false);
estate = Card('Estate',2,0,1,0,0,0,0,[],true,false,false,false,false,false);
duchy = Card('Duchy',5,0,3,0,0,0,0,[],true,false,false,false,false,false);
province = Card('Province',8,0,6,0,0,0,0,[],true,false,false,false,false,false);

% Treasure cards
copper = Card('Copper',0,1,0,0,0,0,0,[],false,false,true,false,false,false);
silver = Card('Silver',3,2,0,0,0,0,0,[],false,false,true,false,false,false);
gold = Card('Gold',6,3,0,0,0,0,0,[],false,false,true,false,false,false);

% Action cards
village = Card('Village',3,0,0,1,2,0,0,[],false,false,false,true,false,false);
woodcutter = Card('Woodcutter',3,0,0,2,0,0,1,[],false,false,false,true,false,false);
smithy = Card('Smithy',4,0,0,2,0,0,0,[],false,false,false,true,false,false);
festival = Card('Festival',5,0,0,2,0,2,1,[],false,false,false,true,false,false);
market = Card('Market',5,0,0,1,1,1,1,[],false,false,false,true,false,false);
laboratory = Card('Laboratory',5,0,0,0,2,1,0,[],false,false,false,true,false,false);

% Action cards with effects
chapel = Card('Chapel',2,0,0,0,0,0,0,[],false,false,false,true,false,false);



% Create firstcards array for access by PlayerState initialization
% functions
firstcards = [copper estate];

