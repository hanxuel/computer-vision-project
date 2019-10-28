% match descriptors
%
% Input:
%   descr1        - k x n descriptor of first image
%   descr2        - k x m descriptor of second image
%   thresh        - scalar value to threshold the matches
%   
% Output:
%   matches       - 2 x w matrix storing the indices of the matching
%                   descriptors
function matches = matchDescriptors(descr1, descr2,thresh)
Max=max(size(descr2,1),size(descr1,1))
Min=min(size(descr2,1),size(descr1,1))
if size(descr2,1)>=size(descr1,1)
    Bigdes=descr2;
    Smalldes=descr1;
else
    Bigdes=descr1;
    Smalldes=descr2;
end
matche=[];
for i=1:Max
    [a,b]=min(sum((Smalldes-Bigdes(i,:)).^2,2));
    if a<thresh
        matche=[matche;[i b]]; %#ok<AGROW>
    end
end
matches=matche';
if size(descr2,1)>=size(descr1,1)
    matches([1 2],:)=matches([2 1],:);
end
end