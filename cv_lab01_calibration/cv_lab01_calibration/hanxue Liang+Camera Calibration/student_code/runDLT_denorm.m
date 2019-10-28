function [P, K, R, t, error_dlt] = runDLT_denorm(xy, XYZ)


%compute DLT
[P] = dlt(xy, XYZ);
%factorize camera matrix in to K, R and t
[ K, R, t ] = decompose(P);
C=-inv(P(1:3,1:3))*P(:,4)
K=K./K(3,3)
R=inv(K)*P(1:3,1:3)
%compute reprojection error
projectedxy_sel=P*XYZ;
pxy=bsxfun(@ldivide, projectedxy_sel(3,:), projectedxy_sel)
figure(4)
imshow('image/image4.jpg')
hold on
scatter(pxy(1,:),pxy(2,:),'+','r')

error_dlt=sum(sum((xy(1:2,:)-pxy(1:2,:)).^2))/6

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
xypt=bsxfun(@ldivide, projectedxy(3,:), projectedxy)
figure(5)
imshow('image/image4.jpg')
hold on
scatter(xypt(1,:),xypt(2,:),'+','b')
end