function [score] = getScore(gen,cards,firstcards)

%replace this with funciton name of the model
[score] = Dominiopt(gen.gain_priority,gen.gain_cutoffs,gen.play_priority,gen.trash_priority,cards,firstcards);
