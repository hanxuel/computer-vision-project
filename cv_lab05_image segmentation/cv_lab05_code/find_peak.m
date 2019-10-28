function peak = find_peak(X,x1,r)
% L of size L*3
% x1 of size 1*3
[L,d]=size(X);
m=true;
threshold=0.0005;
y0=x1;
while m==true
    t=sqrt(sum((X-repmat(y0,L,1)).^2,2))<=r;
    y1=sum(X.*repmat(t,1,d))/sum(t);
    if norm(y1-double(y0))<threshold
        m=false
    else
        y0=y1;
    end
end
peak=y1;
end