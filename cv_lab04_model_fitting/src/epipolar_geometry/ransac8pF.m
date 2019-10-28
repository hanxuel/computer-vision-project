function [in1, in2, out1, out2,F] = ransac8pF(x1, x2, threshold)

% TODO: implement
iter=1000
maxinlnum=0;
num_pts=size(x1,2);
for i=1:iter
    modelindex=randperm(num_pts,8);
    x1s=x1(:,modelindex);
    x2s=x2(:,modelindex);
    %computer fundamental matrix
    [Fh,F]=fundamentalMatrix(x1s, x2s);
    % Compute the distances between all points with the fitting model
    l1=Fh*x1;
    l2=Fh'*x2;
    distances=abs(sum(x2.*l1))./sqrt(l1(1,:).^2+l1(2,:).^2)+abs(sum(x1.*l2))./sqrt(l2(1,:).^2+l2(2,:).^2);
    % Compute the inliers with distances smaller than the threshold
    indexs=find(abs(distances)<threshold);
    % Update the number of inliers and fitting model if better model is found
    if length(indexs)>maxinlnum
        finalindexs=indexs;
        outlierindexs=find(distances>threshold);
        maxinlnum=length(finalindexs);        
    end   
end
in1=x1(:,finalindexs); 
in2=x2(:,finalindexs);
out1=x1(:,outlierindexs);
out2=x2(:,outlierindexs);
[Fh,F]=fundamentalMatrix(in1,in2);
end


