function [map clusters] = meanshiftSeg(img)
img = im2double(img);
[m,n,d]=size(img);
A=reshape(img,[],d);
L=size(A,1);
map=zeros(L,1);
peak=zeros(L,d);
r=0.03;
k=0;
% find the peak of all the pixels
for i=1:L
    x1=A(i,:);
    peak(i,:)=find_peak(A,x1,r);
end
% distribute each pixel a class; 
% k is the number of class;
for i=1:L
    if map(i)==0
        k=k+1;
        map(i)=k;
        clusters(k,:)=peak(i,:);
    end
    for j=i+1:L
        if map(j) == 0
            if norm(peak(i,:)-peak(j,:))<=(r/2)
                map(j)=k;
            end
        end
    end
map=reshape(map,[m n]);
end


