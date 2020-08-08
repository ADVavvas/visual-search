function F = getOctaveKeypoints(D, R_th, t_c, w)
    % Get the potential keypoints in the image.
    candidates = getCandidateKeypoints(D);
    % Create a new vector for the final keypoints.
    keypoints = [];

    % Convert the pyramid from a cell array to a matrix (helps with calculations later).
    DoG = [];
    for j = 1:length(D)
        DoG = cat(3, DoG, D{j});
    end
    D = DoG;

    % For each candidate
    for i = 1:size(candidates, 1)
        candidate = candidates(i, :);
        % Get the coordinates.
        y = candidate(1);
        x = candidate(2);
        s = candidate(3);

        % Localize the keypoint.
        [offset, J, H, x, y, s] = localizeKeypoints(D, x, y, s);

        contrast = D(y, x, s) + 0.5 * dot(J, offset);

        % Filter candidates with low contrast.
        if abs(contrast) < t_c
            continue
        end

        [w v] = eig(H);
        r = w(2) / w(1);
        R = (r+1)^2 / r;
        % Filtering.
        if R > R_th
            continue
        end
        % Apply the offset to the remaining candidates.
        disp(offset);
        y = y + offset(:, 2);
        x = x + offset(:, 1);
        s = s + offset(:, 3);
        kp = [y x s];
        keypoints = [keypoints ; kp];
    end
    F = keypoints;
    return;
end