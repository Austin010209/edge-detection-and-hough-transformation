%% 
% Read in the image, convert to grayscale, and detect edges.
% Creates an array edges where each row is    (x, y, cos theta, sin theta)   

clc;
clear;
close all;
im = imread("pic8.jpg");
im = imresize(rgb2gray(im), 0.5);

Iedges = edge(im,'canny');
%  imgradient computes the gradient magnitude and gradient direction
%  using the Sobel filter.  
[~,grad_dir]=imgradient(im);
%  imgradient defines the gradient direction as an angle in degrees
%  with a positive angle going (CCW) from positive x axis toward
%  negative y axis.   However, the (cos theta, sin theta) formulas from the lectures define theta
%  positive to mean from positive x axis to positive y axis.  For this
%  reason,  I will flip the grad_dir variable:
grad_dir = - grad_dir;

%imshow(Iedges)

%Now find all the edge locations, and add their orientations (cos theta,sin theta). 
%  row, col is  y,x
[row, col] = find(Iedges);
% Each edge is a 4-tuple:   (x, y, cos theta, sin theta)   
edges = [col, row, zeros(length(row),1), zeros(length(row),1) ];
for k = 1:length(row)
     edges(k,3) = cos(grad_dir(row(k),col(k))/180.0*pi);
     edges(k,4) = sin(grad_dir(row(k),col(k))/180.0*pi);
end




%below are my parts
%initialize HoughSpace. We do not consider vanishing point outside the
%image, so HoughSpace on a point can be the same size of image
HoughSpace = zeros(size(im));
%differentiate hotizontal or vertical edges by absolute value of cos. If it
%is more than sqrt(2)/2, then it is vertical; rest are horizontal.
hedges = edges(abs(edges(:,3))<sqrt(2)/2,:);
vedges = edges(abs(edges(:,3))>=sqrt(2)/2,:);


%for every edge
for i=1:length(hedges)
    r = hedges(i,1) * hedges(i,3) + hedges(i,2) * hedges(i,4);
    for j=1:size(HoughSpace,2)
        %y value(row value) for each edge
        y = round((r-(hedges(i,3)*j)) / hedges(i,4));
        %some values will be outside; we ignore it
        if y >= 1 && y <= size(HoughSpace,1)
            %cast one vote (note that the x and y are reversed)
            HoughSpace(y,j) = HoughSpace(y,j) + 1;
        end
    end
end

%same thing for vertical edges
for i=1:length(vedges)
    r = vedges(i,1) * vedges(i,3) + vedges(i,2) * vedges(i,4);
    for j=1:size(HoughSpace,1)   %y
        x = round((r-(vedges(i,4)*j)) / vedges(i,3));
        if x >= 1 && x <= size(HoughSpace,2)
            HoughSpace(j,x) = HoughSpace(j,x) + 1;
        end
    end
end
%we can find the position(maybe more than 1) where the max intensity (the 
%point that is intersect of most points) is. (By a and b)
[a,b] = find(HoughSpace == max(HoughSpace(:)));


%show the Hough Space
im_new = uint8(HoughSpace);
figure(1);
imagesc(im_new);
title('the hough transform');
colorbar;


%Below part is from a perhaps misunderstanding of a TA's reply: "you must show hough
%transform only with intensities matching the vote", so I create an image
%only for the vanishing point. I do not if the question asks for this or not.
picture = zeros(size(im));
[columnsInImage, rowsInImage] = meshgrid(1:size(picture,2), 1:size(picture,1));
% Next create the circle in the image.
centerY = a;
centerX = b;
%the radius is not 1 because one pixel in about 700*700 image is undetectable for human
radius = 5;
%in case we have more than 1 max intensities, they get summed up.
for i=1:size(centerX,1)
    temp1 = (rowsInImage - centerY(i)).^2 ...
    + (columnsInImage - centerX(i)).^2 <= radius.^2;
    picture = temp1+picture;
end
figure(3);
imagesc(picture);
title('only the vanishing point');
colorbar;