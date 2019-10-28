function f = fminGoldStandardRadial(p,xy, XYZ, w)

%reassemble P
P = [p(1:4);p(5:8);p(9:12)];
rad=[p(13) p(14)]
%compute squared geometric error with radial distortion
[ K, R, t ] = decompose(P);
projectedxy=[R t]*XYZ;
for i=1:6
    projectedxy(:,i)=projectedxy(:,i)./projectedxy(3,i);
end
pxy=projectedxy(1:2,:);
r=sqrt(sum(pxy.^2)) 
%compute cost function value
pxy_rad=zeros(2,6);
for i=1:6
    for j=1:2
        pxy_rad(j,i)=(1+r(1,i)^2*rad(1)+r(1,i)^4*rad(2))*pxy(j,i);
    end
end
pxy_rad
pxy_rad=K*[pxy_rad;ones(1,6)]
for i=1:6
    pxy_rad(:,i)=pxy_rad(:,i)./pxy_rad(3,i);
end
error=sum(sum((xy(1:2,:)-pxy_rad(1:2,:)).^2));
% f = error+w*K(1,2)^2+w*(K(1,1)-K(2,2))^2;
f = error;
end