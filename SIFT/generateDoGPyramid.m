function F = generateDoGPyramid(gaussian_pyramid)
    pyr = {};
    for i=1:length(gaussian_pyramid)
        % Calculate the DoG octave for each gaussian octave in the pyramid
        % and add it to the DoG pyramid.
        pyr{end + 1} = generateDoGOctave(gaussian_pyramid{i});
    end
    F = pyr;
    return;
end