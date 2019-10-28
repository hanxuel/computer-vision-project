% Decompose the essential matrix
% Return P = [R|t] which relates the two views
% You will need the point correspondences to find the correct solution for P
function P = decomposeE(E, x1, x2, K)
[U S V]=svd(E);
W=[0 -1 0;1 0 0;0 0 1];
R1=U*W*V';
R2=U*W'*V';
t1=U(:,3);
% t1=t1/sqrt(sum(t1.^2))
t2=-U(:,3);
% t2=t2/sqrt(sum(t2.^2))

P4(:,:,1) = [R1, t1];
P4(:,:,2) = [R1, t2];
P4(:,:,3) = [R2, t1];
P4(:,:,4) = [R2, t2];

P1 = [eye(3) [0;0;0]];
for i=1:4
     [XS(:,:,i), err(:,i)] = linearTriangulation(P1, x1, P4(:,:,i), x2)
end
for i=1:4
    if XS(3,:,i)>0 & P4(3,:,i)*XS(:,:,i)>0
        P4(3,:,i)*XS(:,:,i)
        P=P4(:,:,i)
    end
end
P4(3,:,4)*XS(:,:,4)