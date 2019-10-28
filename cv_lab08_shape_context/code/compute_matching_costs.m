function matchingCostMatrix = compute_matching_costs(objects,nsamp)
N=length(objects);
matchingCostMatrix=zeros(N);
for i=2:1:N
    for j=1:1:i-1
        x=get_samples(objects(i).X,nsamp);
        y=get_samples(objects(j).X,nsamp);
        matchingCostMatrix(i,j)=shape_matching(x,y);
        matchingCostMatrix(j,i)=matchingCostMatrix(i,j);
    end
end