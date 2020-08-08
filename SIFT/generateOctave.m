function G = generateOctave(img, s, sig)
   octave = {};
   % Add the original image to the octave.
   octave{end + 1} = img;
   k = 2^(1/s);
   % Generate s + 2 images
   for i = 1:(s+2) 
      % Calculate the sigma of the next image
      t = k * sig;
      % Apply the gaussian filter to the image.
      next_level = imgaussfilt(octave{end}, t); 
      % Concatenate the blurred image to the octave.
      octave{end + 1} = next_level;
   end
   G = octave;
return;