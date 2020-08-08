% Normalize the DoG pyramid to values from [0, 1].
function pyramid = normalizeDoGPyramid(DoG_pyr)
    pyramid = {};
    for i=1:length(DoG_pyr)
        octave = DoG_pyr{i};
        for j = 1:length(octave)
            img = octave{j};
            img = (img - min(img(:)))./(max(img(:)) - min(img(:)));
            octave{j} = img;
        end
        pyramid{end + 1} = octave;
    end
    return;
end