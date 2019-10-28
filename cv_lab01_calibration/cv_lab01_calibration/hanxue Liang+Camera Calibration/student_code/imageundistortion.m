function [pxy] = imageundistortion(xy, XYZ, Kn,Rn,tn,rad)
p=[2000 1500];
%normalize data points
[xy_normalized,XYZ_normalized, T, U] = normalization(xy, XYZ);
projectedxyn=[Rn tn]*XYZ_normalized;
for i=1:6
    projectedxyn(:,i)=projectedxyn(:,i)./projectedxyn(3,i);
end
pxyn=projectedxyn(1:2,:)
r=sqrt(sum(pxyn.^2))
%compute cost function value
pxyn_rad=zeros(2,6);
for i=1:6
    for j=1:2
        pxyn_rad(j,i)=(1+rad(1)*r(1,i)^2+r(1,i)^4*rad(2))*pxyn(j,i);
    end
end

pxyn_rad=Kn*[pxyn_rad;ones(1,6)];
for i=1:6
    pxyn_rad(:,i)=pxyn_rad(:,i)./pxyn_rad(3,i);
end
pxy=inv(T)*pxyn_rad;
for i=1:6
    for j=1:2
        pxy(j,i)=p(j)+(1+rad(1)*r(1,i)^2+r(1,i)^4*rad(2))*(pxy(j,i)-p(j));
    end
end
