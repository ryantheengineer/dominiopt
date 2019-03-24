% Victory point cards
curse = Card('Curse',0,0,-1,0,0,0,0,[],false,true,false,false,false,false);
estate = Card('Estate',2,0,1,0,0,0,0,[],true,false,false,false,false,false);
duchy = Card('Duchy',5,0,3,0,0,0,0,[],true,false,false,false,false,false);
province = Card('Province',8,0,6,0,0,0,0,[],true,false,false,false,false,false);

% Treasure cards
copper =        Card('Copper',  0,1,0,0,0,0,0,[],false,false,true,false,false,false);
silver =        Card('Silver',  3,2,0,0,0,0,0,[],false,false,true,false,false,false);
gold =          Card('Gold',    6,3,0,0,0,0,0,[],false,false,true,false,false,false);

% Action cards (simple)
village =       Card('Village',     3,0,0,1,2,0,0,[],false,false,false,true,false,false);
woodcutter =    Card('Woodcutter',  3,0,0,2,0,0,1,[],false,false,false,true,false,false);
smithy =        Card('Smithy',      4,0,0,2,0,0,0,[],false,false,false,true,false,false);
festival =      Card('Festival',    5,0,0,2,0,2,1,[],false,false,false,true,false,false);
market =        Card('Market',      5,0,0,1,1,1,1,[],false,false,false,true,false,false);
laboratory =    Card('Laboratory',  5,0,0,0,2,1,0,[],false,false,false,true,false,false);

% Action cards with effects
chapel =        Card('Chapel',    2,0,0,0,0,0,0,[],false,false,false,true,false,false);
cellar =        Card('Cellar',    2,0,0,0,0,1,0,[],false,false,false,true,false,false);
moat =          Card('Moat',      2,0,0,0,2,0,0,[],false,false,false,true,false,true);
harbinger =     Card('Harbinger', 3,0,0,0,1,1,0,[],false,false,false,true,false,false);
workshop =      Card('Workshop',  3,0,0,0,0,0,0,[],false,false,false,true,false,false);
bureaucrat =    Card('Bureaucrat',4,0,0,0,0,0,0,[],false,false,false,true,true, false);
militia =       Card('Militia',   4,0,0,2,0,0,0,[],false,false,false,true,true, false);
moneylender =  Card('Moneylender',4,0,0,0,0,0,0,[],false,false,false,true,false,false);
poacher =       Card('Poacher',   4,0,0,1,1,1,0,[],false,false,false,true,false,false);
remodel =       Card('Remodel',   4,0,0,0,0,0,0,[],false,false,false,true,false,false);
throneroom =   Card('Throne Room',4,0,0,0,0,0,0,[],false,false,false,true,false,false);
bandit =        Card('Bandit',    5,0,0,0,0,0,0,[],false,false,false,true,true, false);
councilroom = Card('Council Room',5,0,0,0,4,0,1,[],false,false,false,true,false,false);
library =       Card('Library',   5,0,0,0,0,0,0,[],false,false,false,true,false,false);
mine =          Card('Mine',      5,0,0,0,0,0,0,[],false,false,false,true,false,false);
sentry =        Card('Sentry',    5,0,0,0,1,1,0,[],false,false,false,true,false,false);
witch =         Card('Witch',     5,0,0,0,2,0,0,[],false,false,false,true,true, false);
% artisan =       Card('Artisan',   6,0,0,0,0,0,0,[],false,false,false,true,false,false);
chancellor =    Card('Chancellor',3,0,0,2,0,0,0,[],false,false,false,true,false,false);
% feast =         Card('Feast',     4,0,0,0,0,0,0,[],false,false,false,true,false,false);
adventurer =    Card('Adventurer',6,0,0,0,0,0,0,[],false,false,false,true,false,false);
vassal =        Card('Vassal',    3,0,0,2,0,0,0,[],false,false,false,true,false,false);



% name = [];
%         cost = 0;
%         treasure = 0;
%         vp = 0;
%         coins = 0;
%         cards = 0;
%         actions = 0;
%         buys = 0;
%         effect = [];
%         isVictory = false;
%         isCurse = false;
%         isTreasure = false;
%         isAction = false;
%         isAttack = false;
%         isDefense = false;



% Create firstcards array for access by PlayerState initialization
% functions
firstcards = [copper estate];

