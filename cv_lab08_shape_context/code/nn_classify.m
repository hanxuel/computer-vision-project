function testClass = nn_classify(matchingCostVector,trainClasses,k)
[value,index]=sort(matchingCostVector);
traincand=trainClasses(index(1:k));
table = tabulate(traincand)
[maxCount,idx] = max(cell2mat(table(:,2)));
testClass=table(idx);
end