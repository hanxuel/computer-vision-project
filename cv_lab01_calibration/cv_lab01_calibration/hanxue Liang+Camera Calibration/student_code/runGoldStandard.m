function [K, R, t, error] = runGoldStandard(xy, XYZ)

%normalize data points
[xy_normalized,XYZ_normalized, T, U] = normalization(xy, XYZ);

%compute DLT
[P_normalized] = dlt(xy_normalized, XYZ_normalized);
Pn=P_normalized;
%minimize geometric error
pn = [Pn(1,:) Pn(2,:) Pn(3,:)];
for i=1:20
    [pn] = fminsearch(@fminGoldStandard, pn, [], xy_normalized, XYZ_normalized, i/5);
end
% [pn] = fminsearch(@fminGoldStandard, pn, [], xy_normalized, XYZ_normalized)
%denormalize camera matrix
Pn_opt=[pn(1:4);pn(5:8);pn(9:12)]
P=inv(T)*Pn_opt*U;
%factorize camera matrix in to K, R and t
[ K, R, t ] = decompose(P);
K=K./K(3,3)
R=inv(K)*P(1:3,1:3)
%compute reprojection error
projectedxy_sel=P*XYZ;
pxy=bsxfun(@ldivide, projectedxy_sel(3,:), projectedxy_sel)
figure(6)
imshow('image/image4.jpg')
hold on
scatter(pxy(1,:),pxy(2,:),'+','g')
error=sum(sum((xy(1:2,:)-pxy(1:2,:)).^2))/6


XYZ1=[];
XYZ2=[];
n=1;
for i=0:1:7
    for j=0:1:8
        XYZ1(1:4,n)=[i*27,0,j*27,1];
        XYZ2(1:4,n)=[0,i*27,j*27,1];
        n=n+1;
    end
end

XYZt=[XYZ1 XYZ2];
projectedxy=P*XYZt;
xypt=bsxfun(@ldivide, projectedxy(3,:), projectedxy);
figure(8)
imshow('image/image4.jpg')
hold on
scatter(xypt(1,:),xypt(2,:),'+','g');

end