% Compute the essential matrix using the eight point algorithm
% Input
% 	x1s, x2s 	Point correspondences 3xn matrices
%
% Output
% 	Eh 			Essential matrix with the det F = 0 constraint and the constraint that the first two singular values are equal
% 	E 			Initial essential matrix obtained from the eight point algorithm
%

function [Eh, E] = essentialMatrix(nx1s, nx2s)
% [nx1s T1]=normalizePoints2d(x1s);
% [nx2s T2]=normalizePoints2d(x2s);
n=size(nx1s,2);
A=[];
nx1ss=nx1s';
for i=1:n
    a=nx2s(:,i)*nx1ss(i,:);
    A=[A;reshape(a',1,9)];
end
[U D V]=svd(A);
E=reshape(V(:,end),3,3)';
[U1 D1 V1]=svd(E)
r=D1(1,1);
s=D1(2,2);
D1(1,1)=(r+s)/2;
D1(2,2)=D1(1,1);
D1(3,3)=0;
Eh=U1*D1*V1';
end
