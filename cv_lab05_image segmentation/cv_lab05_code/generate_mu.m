% Generate initial values for mu
% K is the number of segments

function mu = generate_mu(A, K)
d=size(A,2);
mu=zeros(d,K);
amax=max(A);
amin=min(A);
range = repmat((amax-amin)',1,K);
mu = range.*rand([d,K])+repmat(amin',1,K);
end