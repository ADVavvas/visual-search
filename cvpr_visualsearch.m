%% 1) Load files that contain the features
%% [...]
%% 2) Pick an image at random to be the query

NIMG=size(ALLFEAT,1);           % number of images in collection

queryimg=floor(rand()*NIMG);    % index of a random image

%% Handpicked query for testing.

queryimg = 548;



%% ! PCA

[vec, val, new] = performPCA(ALLFEAT, 8); 

ALLFEAT = new;

%% ! PCA



%% 3) Calculate the distances.

dst=[];

for i=1:NIMG

    candidate=ALLFEAT(i,:);

    query=ALLFEAT(queryimg,:);

    %% L2 distance.

    thedst=cvpr_compare(query,candidate);

    %% Mahalanobis distance.

    thedst=cvpr_compare_mahal(query, candidate, val);

    dst=[dst ; [thedst i]];

end

dst=sortrows(dst,1);  % sort the results



%% 4) Visualise the results

SHOW=15; % Show top 15 results

dst=dst(1:SHOW,:);

outdisplay=[];

for i=1:size(dst,1)

    img=imread(ALLFILES{dst(i,2)});

    img=img(1:2:end,1:2:end,:); % make image a quarter size

    img=img(1:81,:,:); % crop image to uniform size vertically (some MSVC images are different heights)

    outdisplay=[outdisplay img];

end



figure, imshow(outdisplay);



%% ! PR CALCULATION

%% Set of query images

queries = [14, 41, 94, 111, 139, 157, 183, 214, 245, 282, 303, 339, 366, 390, 425, 456, 482, 511, 548, 590];

%% 20 different classes exist in the dataset.

number_of_classes = 20;

%% Number of images in each class

class_nums = zeros(number_of_classes, 1);

%% Class of each image

image_classes = []; 

%% Name of each image

image_names = [];



%% Calculate total number of imgs in each class

for i = 1:NIMG

    temp_name = allfiles(i).name;

    temp_class = getImgClass(temp_name);

    class_nums(temp_class) = class_nums(temp_class) + 1;

    image_classes = [image_classes temp_class];

    image_names = [image_names convertCharsToStrings(temp_name)];

end



%% The average P & R across all query images (NOT AP from formula).

average_precision = zeros(1, NIMG);

average_recalls = zeros(1, NIMG);

%% Average precision (as given in the lecture slides).

AP = 0;

MAP = 0;



%% Calculate PR curve for each query

for query_num = 1:length(queries)

    precisions = [];

    recalls = [];

    AP = 0;



    %% Compute the distance of image to the query

    dst=[];

    for i=1:NIMG

        candidate=ALLFEAT(i,:);

        query=ALLFEAT(queries(query_num),:);

        %% L2 distance.

        %thedst=cvpr_compare(query,candidate);

        %% Mahalanobis distance.

        thedst=cvpr_compare_mahal(query, candidate, val);

        dst=[dst ; [thedst i]];

    end

    dst=sortrows(dst,1);  % sort the results



    %% Get the class of the current query image.

    %query_class = getImgClass(allfiles(queries(query_num)).name);

    query_class = image_classes(queries(query_num));



    %% Gradually increase the number of elements to include in the PR curve [1, NIMG].

    for i = 1:size(dst, 1)

        same_class = 0;

        for j = 1:i

            %% Get the class of the jth image.

            img_class = image_classes(dst(j, 2));

            %% Compare it to the class of the query image.

            %% If it's in the same class, increment the amount of images with the same class

            %% in the query results.

            if img_class == query_class

                same_class = same_class + 1;

            end

        end



        %% Calculate precision (TP/(TP + FP))

        Precision = same_class / i;

        %% Calculate recall (TP/(TP + FN))

        Recall = same_class / class_nums(query_class);



        %% Calculate AP for ith element.

        AP = AP +  (Precision * (image_classes(dst(i, 2)) == query_class));



        %% Add precision up to ith image in order to calculate PR curve.

        precisions = [precisions Precision];

        %% Add recall up to ith image.

        recalls = [recalls Recall];

    end



    %% Divide by relevant docs to get AP.

    AP = AP/class_nums(query_class);

    %% Sum all APs to get mAP.

    MAP = MAP + AP;

    fprintf('AP: %f\n', AP);



    %% Add precisions and recalls of each image so that we can calculate the average PR curve.

    average_precision = average_precision + precisions; 

    average_recalls = average_recalls + recalls;

end



%% Divide by number of queries to get averages. 

MAP = MAP / length(queries);

average_precision = average_precision ./ length(queries);

average_recalls = average_recalls ./ length(queries);



fprintf('MAP: %f\n', MAP);



%% Plot the PR curve.

figure, plot(average_recalls, average_precision);



%% ! PR CALCULATIONS



%axis off;
