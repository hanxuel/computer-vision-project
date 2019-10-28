function X_nsamp=get_samples(X,nsamp)
N=size(X,1);
X_nsamp=X(randperm(N,nsamp),:);
end