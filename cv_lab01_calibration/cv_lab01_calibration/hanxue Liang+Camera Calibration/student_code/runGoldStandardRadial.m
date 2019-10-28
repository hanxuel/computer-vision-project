function [Kn, Rn, tn,error,rad] = runGoldStandardRadial(xy, XYZ, rad)

%normalize data points
[xy_normalized,XYZ_normalized, T, U] = normalization(xy, XYZ);

%compute DLT
[P_normalized] = dlt(xy_normalized, XYZ_normalized);
Pn=P_normalized;
%minimize geometric error
pn = [Pn(1,:) Pn(2,:) Pn(3,:) rad(1) rad(2)];
for i=1:30
    [pn] = fminsearch(@fminGoldStandardRadial, pn, [], xy_normalized, XYZ_normalized, i/5);
end
rad=[pn(13) pn(14)]
%denormalize camera matrix
Pn_opt=[pn(1:4);pn(5:8);pn(9:12)]
% P=inv(T)*Pn_opt*U;
%factorize camera matrix in to K, R and t
[ Kn, Rn, tn ] = decompose(Pn_opt);
%compute reprojection error
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
pxy_rad=inv(T)*pxyn_rad
error=sum(sum((xy(1:2,:)-pxy_rad(1:2,:)).^2))/6
end