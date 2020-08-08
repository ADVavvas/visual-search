% Get the class of the image from the filename.
function F=getImgClass(fname)

% Split the string at '_'
query_class = strsplit(fname, "_");
query_class = cell2mat(query_class(1));
% Convert the string to a number.
query_class = str2num(query_class);

F = query_class;

return;