function [map cluster] = EM(img)
img = im2double(img);
[m,n,d]=size(img);
A=reshape(img,[],d);
k=5;
% use function generate_mu to initialize mus
mu_init=generate_mu(A,k)
% use function generate_cov to initialize covariances
var_init=generate_cov(A,k)
alpha_init=ones(1,k)/k
P = expectation(mu_init,var_init,alpha_init,A);
threshold=0.0005;
premu=mu_init
distance=10;
% iterate between maximization and expectation
while distance>threshold
    [mu, var, alpha] = maximization(P, A);
    distance=norm(abs(mu-premu))
    P = expectation(mu,var,alpha,A);
    premu=mu;
end
mu
var
alpha
map=visualizeMostLikelySegments(img,alpha,mu,var);
cluster=mu';
end