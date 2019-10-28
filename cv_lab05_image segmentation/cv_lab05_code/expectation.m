function P = expectation(mu,var,alpha,X)
[L,f]=size(X);
K = length(alpha);
y=zeros(L,K);
ysum=zeros(L,1);

for i=1:1:K
    y(:,i)=alpha(i)*mvnpdf(X,mu(:,i)',var(:,:,i));
    ysum=ysum+y(:,i);
end
P=bsxfun(@rdivide,y,ysum);
end