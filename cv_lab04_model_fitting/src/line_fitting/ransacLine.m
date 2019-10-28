function [k, b] = ransacLine(data, iter, threshold)
% data: a 2xn dataset with #n data points
% iter: the number of iterations
% threshold: the threshold of the distances between points and the fitting line

num_pts = size(data,2); % Total number of points
best_inliers = 0;       % Best fitting line with largest number of inliers
k=0; b=0;                % parameters for best fitting line
maxinlnum=0
for i=1:iter
    % Randomly select 2 points and fit line to these
    % Tip: Matlab command randperm is useful here
    modelindex=randperm(num_pts,2);
    points=[data(1,modelindex);data(2,modelindex)];
    % Model is y = k*x + b
    k1=(points(2,2)-points(2,1))/(points(1,2)-points(1,1));
    b1=(points(2,1)-points(1,1))*k1;
    % Compute the distances between all points with the fitting line 
    n = [k1 -1]; 
    n = n/norm(n);
    pt1 = [0;b1];
    distances=abs(n*(data-pt1*ones(1,num_pts)));
    % Compute the inliers with distances smaller than the threshold
    indexs=find(distances<threshold);
    % Update the number of inliers and fitting model if better model is found
    if length(indexs)>maxinlnum
        finalindexs=indexs;
        maxinlnum=length(finalindexs);        
    end   
end
coef1=polyfit(data(1,finalindexs),data(2,finalindexs),1);
k=coef1(1) 
b=coef1(2)

end
