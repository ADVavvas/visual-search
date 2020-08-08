function P = generateGaussianPyramid(img, num_octave, s, sig)
    pyr = {};
    % Create num_octave octaves in the pyramid.
    for i = 1:num_octave
        % Generate an octave with 'img' as the basis.
        octave = generateOctave(img, s, sig);
        % Append it to the pyramid.
        pyr{end + 1} = octave;
        % Take the 3rd last image from the previous octave as the basis for the next octave.
        img = octave{end-2};
        % Subsample it by a factor of two.
        img = img(2:2:end, 2:2:end);
    end
    P = pyr;
return