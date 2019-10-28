% Compute the fundamental matrix using the eight point algorithm
% Input
% 	x1s, x2s 	Point correspondences
%
% Output
% 	Fh 			Fundamental matrix with the det F = 0 constraint
% 	F 			Initial fundamental matrix obtained from the eight point algorithm
%
function [Fh, F] = fundamentalMatrix(x1s, x2s)
[nx1s T1]=normalizePoints2d(x1s);
[nx2s T2]=normalizePoints2d(x2s);
n=size(x1s,2);
A=[];
nx1ss=nx1s';
for i=1:n
    a=nx2s(:,i)*nx1ss(i,:);
    A=[A;reshape(a',1,9)];
end
[U D V]=svd(A);
Ff=reshape(V(:,end),3,3)';
F=T2'*Ff*T1;
[U1 D1 V1]=svd(Ff);
D1(3,3)=0;
Fhh=U1*D1*V1';
Fh=T2'*Fhh*T1;
end