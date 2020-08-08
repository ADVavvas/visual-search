% Subtract consecutive images in the gaussian octave to create the DoG octave.
function F = generateDoGOctave(gaussian_octave)
    octave = {};
    % Skip first image as it has no image before it.
    for i=2:length(gaussian_octave)
        % Subtract the previous image from the current image.
        octave{end + 1} = gaussian_octave{i} - gaussian_octave{i-1};
    end
    F = octave;
    return;
end