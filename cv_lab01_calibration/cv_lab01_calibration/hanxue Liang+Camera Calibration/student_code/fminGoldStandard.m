function f = fminGoldStandard(p, xy, XYZ,w)
%reassemble P
P = [p(1:4);p(5:8);p(9:12)];
[ K, R, t ] = decompose(P);
%compute squared geometric error
projectedxy=P*XYZ;
for i=1:6
    projectedxy(:,i)=projectedxy(:,i)./projectedxy(3,i);
end
pxy=projectedxy(1:2,:);
error=sum(sum((xy(1:2,:)-pxy).^2));
% compute cost function value
f = error+w*K(1,2)^2+w*(K(1,1)-K(2,2))^2
%f=error
end