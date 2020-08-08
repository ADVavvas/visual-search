%% For a pixel to be a keypoint it has to has the lowest or highest value
%% from its surrounding pixels (and 1 octave back and forward).

function F = isKeypoint(image_window)
    % Get the max and min value in the window we're currently inspecting.
    [maxval, maxarg] = max(image_window(:));
    [minval, minarg] = min(image_window(:));
    % Get the exact index of the min value inside that 3x3x3 window.
    [m_i, m_j, m_k, m_l] = ind2sub(size(image_window), minarg);
    F = false;
    % If its index is (2, 2, 2) then it's the center pixel (i.e. pixel is a keypoint)
    if m_i == 2 && m_j == 2 && m_l == 2
        F = true;
    % If it's not the minimum it might still be the maximum.
    else
        % Get the exact index of the max value inside the 3x3x3 window.
        [m_i, m_j, m_k, m_l] = ind2sub(size(image_window), maxarg);
        % If its index is (2, 2, 2) then it's the center pixel (i.e. pixel is a keypoint)
        if m_i == 2 && m_j == 2 && m_l == 2
            F = true;
        end
    end
    return;
end