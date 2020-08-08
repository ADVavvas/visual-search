function F=extractGlobalRGBHisto(img, nbins)

%% Convert the image back to values [0,255] (not necessary but for sake of clarity)
img = img * 255;
%% Split each color into nbins
r_d = floor(img(:,:,1) * nbins/256);
g_d = floor(img(:,:,2) * nbins/256);
b_d = floor(img(:,:,3) * nbins/256);

%% Calculate the appropriate bin number [0, nbins^3 - 1] for each pixel.
bin = r_d * (nbins^2) + g_d * (nbins) + b_d;

%% Calculate the histogram with nbins^3 bins and normalize it.
y = histcounts(bin, nbins ^ 3, 'Normalization', 'probability');
F = y;
return;