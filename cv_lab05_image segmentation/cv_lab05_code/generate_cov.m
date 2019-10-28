% Generate initial values for the K
% covariance matrices

function cov_init = generate_cov(A, K)
d=size(A,2);
for i=1:d
    acov(i)=var(A(:,i));
end
for i=1:K
    cov_init(:,:,i)=[acov(1) 0 0;
    0 acov(2) 0;
    0 0 acov(3)];
end
end