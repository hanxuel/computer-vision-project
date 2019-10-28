function ShapeDescriptors =  sc_compute(X,nbBins_theta,nbBins_r,smallest_r,biggest_r)
num=size(X,1);
ShapeDescriptors=zeros(num,nbBins_theta*nbBins_r);
for i=1:num
    ndis=zeros(nbBins_r,nbBins_theta);
    [theta,rho] = cart2pol(X(:,1)-X(i,1),X(:,2)-X(i,2));
    nrho=log(rho./mean(rho));
    range_R=linspace(log(smallest_r),log(biggest_r),nbBins_r+1);
    range_Theta=linspace(-pi,pi,nbBins_theta+1);
    for m=1:nbBins_r
        for n=1:nbBins_theta
            ndis(m,n)=length(find(theta>range_Theta(n) & theta<range_Theta(n+1) & nrho>range_R(m) & nrho<range_R(m+1)));
        end
    end
    ShapeDescriptors(i,:)=ndis(:)';
end