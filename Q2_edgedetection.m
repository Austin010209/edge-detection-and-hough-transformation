%%Xueyang Zhang Q2_edgedetection
%Q2a
%generate rectangles in a bigger curtain and crop.
%the curtain is 500*500
A = ones(500,500);
%rng('default');

%draw 80 rectangles, and 5 paramters for one rectangle.
X = rand(5,80);

%the positions of center and sizes of rectangles. 
%To avoid overlapping, rectangles are small
xs = int32(X(1:2,:)*250);
ls = int32(X(3:4,:)*60);


%start indexes and end indexes in x
x1 = xs(1,:)-ls(1,:);
x2 = xs(1,:)+ls(1,:); 

%solve for x1 could be negative
x1 = x1-min(x1)+1;

%same for y
y1 = xs(2,:)-ls(2,:);
y2 = xs(2,:)+ls(2,:);
y1 = y1-min(y1)+1;

%intensity
intensity = X(5,:);

%draw every triangle
for i=1:80
A(x1(i):x2(i),y1(i):y2(i)) = intensity(i);
end;

%decide the best position of 250*250
meanx = int32((mean(x1)+mean(x2))/2);
meany = int32((mean(y1)+mean(y2))/2);

%avoid indexoutofbound
if meanx<=125, meanx=126; end
if meany<=125, meany=126; end

%crop
A = A(meanx-125:meanx+124,meany-125:meany+124);

figure(1);
imshow(A);
title('initial image: rectangles');








%Q2b
%directly use from matlab
fun = fspecial('log',20,3);

%see the function clearly
tempfun = imresize(fun,40);
figure(2);
imagesc(tempfun,[-0.0037 0.000538]);
title('Laplacian of Gaussian');
colorbar;





%Q2c
%call the function
edges1 = edge_detector(A,fun);
figure(3);
imshow(edges1);
title('edge of original image convolved with sigma 3');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%to address some "extra concerns"
%trying using imfilter instead of conv2
edges21 = edge_detector_by_imfilter(A,fun);
figure(4);
hold on;
subplot(1,2,1);
imshow(edges1);
title('edge detection by conv2');
subplot(1,2,2);
imshow(edges21);
title('edge detection by imfilter');
hold off;
%we see insignificant difference.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%This is another way to get laplacian of Gaussian as well, though it is
%an approximation
Gaussian = fspecial('Gaussian', 20, 3);
funx = conv2(Gaussian,[1 -2 1],'same');
funy = conv2(Gaussian,[1 -2 1]','same');
laplacian_of_Gaussian = funx+funy;
%see the function clearly
tempfun1 = imresize(laplacian_of_Gaussian, 40);

%comparing two filters
figure(5);
hold on;
subplot(1,2,1);
imagesc(tempfun,[-0.0037 0.000538]);
title('built-in Laplacian of Gaussian');
subplot(1,2,2);
imagesc(tempfun1,[-0.0037 0.000538]);
title('hand made Laplacian of Gaussian');
colorbar;
hold off;
%there is only minor difference

%comparing the result of edge detection
edges11 = edge_detector(A,laplacian_of_Gaussian);
figure(6);
hold on;
subplot(1,2,1);
imshow(edges11);
title('edge of original image convolved with man made sigma 3 LoG');
subplot(1,2,2);
imshow(edges1);
title('edge of original image convolved with built-in sigma 3 LoG');
%we see that the built-in method LoG is better.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%








%Q2d
%find std of the image and times 0.1; it is the std of the noise;
stdnoise = 0.1*std(A,0,'all');
%generate noise in gaussian(0,1), times std
noise = stdnoise.*randn(250,250);
%noised image:
noisedA = A+noise;
%get rid of out of bound values
noisedA(noisedA>1)=1;
noisedA(noisedA<0)=0;

figure(7);
imshow(noisedA);
title('noised image convolved with sigma 3');

%find edges of noised image
newedges1 = edge_detector(noisedA,fun);
figure(8);
imshow(newedges1);
title('edge of noised image convolved with sigma 3');






%Q2e
%do the same thing again, with a new function
newfun = fspecial('log',40,6);

%edge of image convolved with sigma 6
edges2 = edge_detector(A,newfun);
figure(9);
imshow(edges2);
title('edge of image convolved with sigma 6');

%noised image convolved with sigma 6
stdimage = 0.1*std(A,0,'all');
noise = stdimage.*randn(250,250);
noisedA = A+noise;
noisedA(noisedA>1)=1;
noisedA(noisedA<0)=0;
figure(10);
imshow(noisedA);
title('noised image convolved with sigma 6');
newedges2 = edge_detector(noisedA,fun);

%edges:
figure(11);
imshow(newedges2);
title('edge of noised image convolved with sigma 6');




%below are also for (e); the below lines simply combines two images
%appeared before together for sake of comparison
%comparison for edge detection of noised image by different Gaussian
hold on;
figure(12);
subplot(1,2,1);
im_new1 = uint8(newedges1);
imagesc(im_new1);
title('noised image convolved with sigma 3');

subplot(1,2,2);
im_new2 = uint8(newedges2);
imagesc(im_new2);
title('noised image convolved with sigma 6');
colorbar;


%comparison for edge detection of noiseless image by different Gaussian
hold on;
figure(13);
subplot(1,2,1);
im_new1 = uint8(edges1);
imagesc(im_new1);
title('no noise image convolved with sigma 3');

subplot(1,2,2);
im_new2 = uint8(edges2);
imagesc(im_new2);
title('no noise image convolved with sigma 6');
colorbar;