clc;
clear;

%Q1a
%read the image
I = imread('pic1.jpg');
J = imresize(I,1);
%for example, we can make a small neighborhood for J, like
J = I(516:522,516:522,:);

%size of the image:
numrow = size(J,1);
numcol = size(J,2);

%initialiating R,G and B channels
R = zeros(numrow, numcol);
G = zeros(numrow, numcol);
B = zeros(numrow, numcol);
black = zeros(numrow, numcol);
%specify the row to be filled for R, and fill
i = 2:2:numrow;
j = 1:2:numcol;
R(i,j) = J(i,j,1);

%specify the row to be filled for G, and fill
i = 1:2:numrow;
j = 1:2:numcol;
G(i,j) = J(i,j,2);
i = 2:2:numrow;
j = 2:2:numcol;
G(i,j) = J(i,j,2);

%specify the row to be filled for B, and fill
i = 1:2:numrow;
j = 2:2:numcol;
B(i,j) = J(i,j,3);

%for "example part", we can see R,G,B value to make sure we did correctly:
%R
%G
%B
%or we can show the image
figure(1);
Rchannel = uint8(cat(3,R,black,black));
subplot(1,3,1);
imshow(Rchannel);
title("R channel");

Gchannel = uint8(cat(3,black,G,black));
subplot(1,3,2);
imshow(Gchannel);
title("G channel");

Bchannel = uint8(cat(3,black,black,B));
subplot(1,3,3);
imshow(Bchannel);
title("B channel");


figure(2);
%showing the synthesizing result
synimage = uint8(cat(3,R,G,B));
subplot(1,2,1);
image(synimage);
title("bayer image");
subplot(1,2,2);
image(J);
title("original image");






%Q1b

%neighbor averaging
%neighbor = [0 0.5 0; 0.5 0 0.5; 0 0.5 0];
%corner averaging
%corner = [0.25 0 0.25; 0 0 0; 0.25 0 0.25];

%FilterRB is the sum of neighbor averaging and corner averaging and itself(central 1)
FilterRB = [0.25 0.5 0.25; 0.5 1 0.5; 0.25 0.5 0.25];
FinalR = conv2(R,FilterRB,'same');
FinalB = conv2(B,FilterRB,'same');

%for G, it only has neighbor averaging (and itself)
FilterG = [0 0.25 0; 0.25 1 0.25; 0 0.25 0];
FinalG = conv2(G,FilterG,'same');





%Q1c
%we concatnate the R,G,B we get, and they combined are the final image
tempimage = cat(3, FinalR, FinalG, FinalB);
%make sure the values are all valid
synthetic_image=uint8(tempimage);
%draw original image and synthetized image to compare
figure(3);
subplot(1,2,1);
image(synthetic_image, 'CDataMapping','scaled');
title("synthetic image");
subplot(1,2,2);
image(J);
title("original image");


