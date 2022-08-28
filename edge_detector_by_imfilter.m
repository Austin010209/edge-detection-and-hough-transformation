%%
%THE ONLY DIFFERENCE FROM THIS TO 'edge_detector' is at the beginning:
%this uses method imfilter, and that one uses conv2
function [temp1] = edge_detector_by_imfilter(A,fun)
%It is the implementation of Q2c
%   It detects zero crossings in different directions 

%The convoluted image is
I1 = imfilter(A,fun,'same');
%image being shifted right by one unit(we mainly need this)
I2 = circshift(I1,[0 1]);
%this is for the case that there is a zero showing but the two values in
%two sides of 0 is the same size. In this case, there is no zero crossing
I3 = circshift(I1,[0 -1]);
%initialize the binary image for edges
temp1 = zeros(size(I1));
%seeing the possible change in sign
I12 = I1.*I2;
I23 = I2.*I3;
%{
This is initially for avoiding significantly small numbers, but I see in
discussion that we do not need this. So I comment it out. In fact this
process will make the edge detection a lot better.
I12(I12>-1.0e-18 & I12<1.0e-18)=0;
I23(I23>-1.0e-18 & I23<1.0e-18)=0;
%}
%either there is a zero crossing, or there is a zero present but the values
%on two sides have different sign, we need to make a mark there, to 1.
temp1((I12<0) | (I12==0)&(I23<0))=1;
%However, it may detect some non-exist zero-crossing as well, namely in the
%boundary of the image(in that the one that is shifted out is put in the 
%first column). We do not need them. They are misleading
temp1(:,1) = 0; 




%And then we do the same idea, same thing, only for different directions.
%This time is for shift of rows.
I2 = circshift(I1,[1 0]);
I3 = circshift(I1,[-1 0]);
temp2 = zeros(size(I1));
I12 = I1.*I2;
I23 = I2.*I3;
%{

I12(I12>-1.0e-18 & I12<1.0e-18)=0;
I23(I23>-1.0e-18 & I23<1.0e-18)=0;
%}
temp2((I12<0) | (I12==0)&(I23<0))=1;
temp2(1,:) = 0;
%If a point is marked as an edge, it should merge with the initial findings
%of edges, so we do or, and keep the first one going.
temp1 = temp2|temp1;




%This time shift in bottom right direction
I2 = circshift(I1,[1 1]);
I3 = circshift(I1,[-1 -1]);
temp3 = zeros(size(I1));
I12 = I1.*I2;
I23 = I2.*I3;
%{
I12(I12>-1.0e-18 & I12<1.0e-18)=0;
I23(I23>-1.0e-18 & I23<1.0e-18)=0;
%}
temp3((I12<0) | (I12==0)&(I23<0))=1;
temp3(1,:) = 0;
temp3(:,1) = 0;
%similarly, we merge results by or
temp1 = temp1|temp3;



%This time for top right direction
I2 = circshift(I1,[1 -1]);
I3 = circshift(I1,[-1 1]);
temp5 = zeros(size(I1));
I12 = I1.*I2;
I23 = I2.*I3;
%{
I12(I12>-1.0e-18 & I12<1.0e-18)=0;
I23(I23>-1.0e-18 & I23<1.0e-18)=0;
%}
temp5((I12<0) | (I12==0)&(I23<0))=1;
temp5(1,:) = 0;%
temp5(:,end) = 0;%
temp1 = temp1|temp5;


%all four specified directions are found. We have found the zero crossings.
end

