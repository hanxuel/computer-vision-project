% Normalization of 2d-pts
% Inputs: 
%           xs = 2d points
% Outputs:
%           nxs = normalized points
%           T = 3x3 normalization matrix
%               (s.t. nx=T*x when x is in homogenous coords)
function [nxs, T] = normalizePoints2d(xs)
n=size(xs,2);
centroid=(mean(xs(1:2,:)'))';
nxs=xs;
nxs(1:2,:)=xs(1:2,:)-repmat(centroid,1,n);

scale=sqrt(2)/mean(sqrt(sum(nxs(1:2,:).^2)));
nxs(1:2,:)=scale*nxs(1:2,:);
T=diag([scale scale 1]);
T(1:2,3)=-scale*centroid;
end
