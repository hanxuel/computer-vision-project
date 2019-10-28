function [Idx Dist] = findnn( D1, D2 )
  % input:
  %   D1  : NxD matrix containing N feature vectors of dim. D
  %   D2  : MxD matrix containing M feature vectors of dim. D
  % output:
  %   Idx : N-dim. vector containing for each feature vector in D1
  %         the index of the closest feature vector in D2.
  %   Dist: N-dim. vector containing for each feature vector in D1
  %         the distance to the closest feature vector in D2.

  N = size(D1,1);
  M = size(D2,1);
  Idx  = zeros(N,1);
  Dist = zeros(N,1);
  
  % Find for each feature vector in D1 the nearest neighbor in D2
for i=1:N
    dist=Distance(D1(i,:),D2);
    [distance,index] = min(dist);
    Idx(i) = index;
    Dist(i) = distance;
end
end
function dist=Distance(d1,D2)
dist=sum(abs(d1-D2).^2,2).^(1/2);
end