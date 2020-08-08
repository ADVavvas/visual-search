function F = getCandidateKeypoints(octave)
    candidates = [];

    % Get the size of the image in the octave
    % Horizontal size.
    x = size(octave{1}, 2);
    % Vertical size.
    y = size(octave{1}, 1);
    % Depth (how many images in the octave).
    z = length(octave);
    
    % Scan the image with a 3x3 window
    % on y axis
    for i=2:y-1
        % on x axis
        for j=2:x-1
            % for each (x, y) check all images in the octave.
            for s=2:z-1
                % Constuct a copy of the inspection window.
                image_window = [];
                % Take the previous image in the octave.
                b1 = octave{s-1};
                % Take the current image in the octave.
                b2 = octave{s};
                % Take the next image in the octave.
                b3 = octave{s+1};
                % Concatenate the 3x3 windows of each image into a 3x3x3 window.
                image_window = cat(4, b1(i-1:i+1, j-1:j+1, :), b2(i-1:i+1, j-1:j+1, :), b3(i-1:i+1, j-1:j+1, :));
                % Check the window for keypoints.
                if isKeypoint(image_window)
                    % Add it to the list of candidates if it is a keypoint.
                    candidates = [candidates; i j s];
                end
            end
        end
    end
    F = candidates;
    return;
end