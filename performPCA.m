function [vec, val, new]=performPCA(descriptors, num_dimensions)

descriptors = descriptors';
% transpose the matrix to perform PCA (each column is an image descriptor)

% PCA
entries = size(descriptors, 2);
F = descriptors;
org = mean(F')';
fsub = F - repmat(org, 1, entries);

C = (fsub * fsub') ./ entries;

[vec val] = eig(C);

% Reconstruct the new matrix.
dr_val = val(:, end-(num_dimensions - 1): end);
dr_vec = vec(:, end-(num_dimensions - 1): end);
vec = dr_vec;

val = zeros(1, num_dimensions);

for i = 1:size(dr_val, 2)
    val(i) = max(dr_val(:, i));
end

new = dr_vec' * F;
new = new';

return;