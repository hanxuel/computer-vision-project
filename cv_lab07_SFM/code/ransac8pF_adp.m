function [in1, in2, out1, out2, m, F] = ransac8pF_adp(x1, x2, threshold)

% TODO: implement
num_pts=size(x1,2);
m=1000;
maxratio=0;
i=0;
while i<m
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
    indexs=find(distances<threshold);
    ratio=length(indexs)/num_pts;
    % Update the number of inliers and fitting model if better model is found
    if ratio>maxratio
        maxratio=ratio
        finalindexs=indexs;
        outlierindexs=find(distances>threshold);     
    end 
    m=log(0.01)/log(1-maxratio^8)
    i=i+1;
end
in1=x1(:,finalindexs); 
in2=x2(:,finalindexs);
out1=x1(:,outlierindexs);
out2=x2(:,outlierindexs);
[Fh,F]=fundamentalMatrix(in1,in2);
end


