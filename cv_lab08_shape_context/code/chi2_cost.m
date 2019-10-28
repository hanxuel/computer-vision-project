function C=chi2_cost(s1,s2)
G=size(s1,1);
H=size(s2,1);
for g=1:G
    for h=1:H
        [index]=find(s1(g,:)~=0 | s2(h,:)~=0);
        C(g,h)=0.5*sum((s1(g,index)-s2(h,index)).^2./(s1(g,index)+s2(h,index)));
    end
end
end