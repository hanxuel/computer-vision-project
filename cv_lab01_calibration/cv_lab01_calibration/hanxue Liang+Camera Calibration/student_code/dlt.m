function [P,M] = dlt(xy, XYZ)
%computes DLT, xy and XYZ should be normalized before calling this function
M=zeros(18,18);
xy1=xy';
XYZ1=XYZ';
xy1(:,3)=1;
XYZ1(:,4)=1;
for i=1:18
    b=ceil(i/3);
    if (mod(i,3)~=0)
        a=mod(i,3);
        M(i,4*a-3:4*a)=XYZ1(b,:);
    else
        M(i,9:12)=XYZ1(b,:);
    end
end
M1=M';
for i=1:6
    if mod(i,6)~=0
        a=mod(i,6);
        M1(12+i,3*a-2:3*a)=-xy1(i,:);
    else
        M1(18,16:18)=-xy1(i,:);
    end
end
M=M1';
[U S V]=svd(M);
P=zeros(3,4);
for i=1:3
    P(i,:)=V(4*i-3:4*i,18);
end



