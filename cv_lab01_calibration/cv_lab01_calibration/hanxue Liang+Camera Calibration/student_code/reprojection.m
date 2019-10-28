XYZ1=[];
XYZ2=[];
n=1;
for i=0:1:7
    for j=0:1:8
        XYZ1(1:4,n)=[i*27,0,j*27,1];
        n=n+1;
    end
end
n=1;
for i=1:1:7
    for j=0:1:8
        XYZ2(1:4,n)=[0,i*27,j*27,1];
        n=n+1;
    end
end
XYZt=[XYZ1 XYZ2];
xypt=P*XYZt
xypt=bsxfun(@ldivide, xypt(3,:), xypt);
imshow('image/image4.jpg')
hold on
scatter(xypt(1,:),xypt(2,:),'y')