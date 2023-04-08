function [M] =Relavantmatrix(traingnd, testgnd)
%compute the relavant matrix of the train data and the test data.



ntr=numel(double(traingnd));
nts=numel(double(testgnd));
M=-1*ones(ntr,nts);
for i=1:nts
    ind=traingnd==testgnd(i);
    M(ind,i)=1;
end


%cateTrainTest=logical(M);
end

