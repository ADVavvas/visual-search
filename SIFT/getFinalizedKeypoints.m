% Get all the localized keypoints for all octaves in the pyramid.
function keypoints = getFinalizedKeypoints(pyr, R_th, t_c)
keypoints = [];
  for i = 1:length(pyr)
    D = pyr{i};
    new_point = getOctaveKeypoints(D, R_th, t_c);
    fprintf("Octave keypoints:\n");
    disp(size(new_point));
    keypoints = [keypoints; new_point]; 
  end
  return;
end