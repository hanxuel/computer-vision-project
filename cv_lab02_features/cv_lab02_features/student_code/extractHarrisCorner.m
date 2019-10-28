% extract harris corner
%
% Input:
%   img           - n x m gray scale image
%   thresh        - scalar value to threshold corner strength
%   
% Output:
%   corners       - 2 x k matrix storing the keypoint coordinates
%   H             - n x m gray scale image storing the corner strength
function [corners, H] = extractHarrisCorner(img, thresh)
[Ix,Iy]=gradient(img);
Ix2=Ix.^2;
Iy2=Iy.^2;
Ixy=Ix.*Iy;

w=fspecial('gaussian',[3 3],0.5);
X=filter2(w,Ix2);
Y=filter2(w,Iy2);
XY=filter2(w,Ixy);
H(:,:,1,1)=X;
H(:,:,2,2)=Y;
H(:,:,1,2)=XY;
H(:,:,2,1)=XY;
[h w]=size(img);
% K=zeros(h,w);
% I=ones(3,3);
% for i=2:h-1
%     for j=2:w-1
%         H=[X(i,j) XY(i,j);XY(i,j) Y(i,j)];
%         K(i,j)=det(H)/trace(H);
%         if K(i,j)<thresh
%             K(i,j)=0;
%         end
%     end
% end
K=(X.*Y-XY.*XY)./(X+Y);
K=max(K-thresh,0);
%imply Non-Maximum-Suppression in a 3 pixel radius

pecks=imregionalmax(K);

[height,width]=size(K);
mask=zeros(height,width);
mask(3:height-3,3:width-3)=1;
pecks=pecks.*mask;
[posh posw]=find(pecks==1);
corners=[posh';posw'];
end