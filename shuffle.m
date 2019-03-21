function [shuffled_list] = shuffle(items)
    n = numel(items);
    ii = randperm(n);
    shuffled_list = items(ii);

end