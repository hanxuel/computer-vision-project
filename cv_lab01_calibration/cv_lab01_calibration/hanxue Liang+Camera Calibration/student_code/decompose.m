function [ K, R, t ] = decompose(P)
%decompose P into K, R and t
M=P(1:3,1:3);
[R1,K1]=qr(inv(M));
K=inv(K1);
% K=K./K(3,3)
% R=inv(K)*M
R=inv(R1);
t=inv(K)*P(:,4);            
end