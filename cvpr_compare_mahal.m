function dst=cvpr_compare_mahal(F1, F2, val)

% This function should compare F1 to F2 - i.e. compute the distance
% between the two descriptors

% For now it just returns a random number

x = F1-F2;
x = x.^2;
x = x ./ val;
x = sum(x);

dst=sqrt(x);

return;