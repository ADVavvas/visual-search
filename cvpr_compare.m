function dst=cvpr_compare(F1, F2)

% This function compares F1 to F2 - i.e. computes the distance
% between the two descriptors

x = F1-F2;
x = x.^2;
x = sum(x);

dst=sqrt(x);

return;
