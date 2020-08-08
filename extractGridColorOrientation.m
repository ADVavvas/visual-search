function F=extractGridColorOrientation(img)

% sobel filters for the convolution
sobX = [1 0 -1 ; 2 0 -2 ; 1 0 -1];
sobY = [1 2 1 ; 0 0 0 ; -1 -2 -1];

bin_num = 8;
% convert to grayscale (also normalized)
grayscale = rgb2gray(img);

% calculate Gx and Gy by convolving using the sobel filters
Gx = conv2(grayscale, sobX, 'same');
Gy = conv2(grayscale, sobY, 'same');
% or use the built in function : [Gx, Gy] = imgradientxy(grayscale);

% ! normalizing the histogram significantly improves accuracy (it seems)
% ! atan2 (y, x) or atan2 (x , y)

% calculate the angle of the edges from -pi to pi rads
theta = atan2(Gy, Gx);
% normalize to values between 0,1
out = (theta - min(theta(:))) / (max(theta(:)) - min(theta(:)));

theta = theta + pi;
theta = theta * (bin_num - 1) / (2*pi);

% calculate the magnitude of the edges
mag = sqrt(Gy.^2 + Gx.^2);

% figure, imshowpair(img, out, 'montage');

[rows cols depth] = size(out);
numBlocksX = 4;
numBlocksY = 4;
% floor so that we don't have larger blocks than we can fit.
blockSizeR = floor(rows / numBlocksY); % Rows in block.
blockSizeC = floor(cols / numBlocksX); % Columns in block.

y = []
for row = 1 : blockSizeR : rows
    if rows < (row + blockSizeR - 1)
        break
    end
    for col = 1 : blockSizeC : cols

        if cols < (col + blockSizeC - 1)
            break
        end

        % Calculate first and last row.
        row1 = row;
        row2 = row1 + blockSizeR - 1;
        row2 = min(rows, row2); % Avoid overflow.

        % Calculate first and last column.
        col1 = col;
        col2 = col1 + blockSizeC - 1;
        col2 = min(cols, col2); % Avoid overflow.

        % Calculate average red in this grid cell.
        red = img(row1:row2,col1:col2,1);
        red = reshape(red, 1, []);
        average_red = mean(red);

        % Calculate average green in this grid cell.
        green = img(row1:row2,col1:col2,2);
        green = reshape(green, 1, []);
        average_green = mean(green);

        % Calculate average blue in this grid cell.
        blue = img(row1:row2,col1:col2,3);
        blue = reshape(blue, 1, []);
        average_blue = mean(blue);

        % Evenly distribute the values of the angles in order to create the EOH.
        d = discretize(theta(row1:row2, col1:col2), bin_num);
        % Histogram
        h = histcounts(d, bin_num, 'Normalization', 'probability');
        % Concatanate EOH and average RGB into a single descriptor.
        y = [y h average_red average_green average_blue];
    end
end
F = y;
return;