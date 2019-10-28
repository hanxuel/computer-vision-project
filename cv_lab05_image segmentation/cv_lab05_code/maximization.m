function [mu, var, alpha] = maximization(P, X)
[L,K] = size(P);
f=size(X,2);
alpha=mean(P);
mu=bsxfun(@rdivide,X'*P,sum(P));
var=zeros(f,f,K);
for i=1:K
    y=zeros(f,f);
    for j=1:L
        d=X(j,:)'-mu(:,i);
        y=y+P(j,i)*(d*d');
    end
    var(:,:,i)=y/sum(P(:,i));
end
% A=sum(P);
% for i=1:1:K
%     deta=bsxfun(@minus,X,mu(:,i)')';
%     var(:,:,i)=bsxfun(@times,deta',P(:,i))'*deta'/A(i);
% end
end