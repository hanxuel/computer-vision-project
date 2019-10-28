function [xyn, XYZn, T, U] = normalization(xy, XYZ)

%data normalization
%first compute centroid

[M N]=size(xy);
xy_centroid = mean(xy');
XYZ_centroid = mean(XYZ');
%then, compute scale
xy1=xy-repmat(xy_centroid',[1,length(xy(1,:))]);
XYZ1=XYZ-repmat(XYZ_centroid',[1,length(XYZ(1,:))]);
sum1=sum((xy1.^2)');
sum2=sum((XYZ1.^2)');
s1=sqrt(N/sum1(1,1));
s2=sqrt(N/sum1(1,2));
s3=sqrt(N/sum2(1,1));
s4=sqrt(N/sum2(1,2));
s5=sqrt(N/sum2(1,3));
%create T and U transformation matrices
T = [s1 0 -s1*xy_centroid(1,1);0 s2 -s2*xy_centroid(1,2);0 0 1]
U = [s3 0 0 -s3*XYZ_centroid(1,1);0 s4 0 -s4*XYZ_centroid(1,2);0 0 s5 -s5*XYZ_centroid(1,3);0 0 0 1]

%and normalize the points according to the transformations
xyn = T*xy;
XYZn = U*XYZ;
end