function [M] =mulclassRelavantmatrix(traingnd, testgnd)
%compute the relavant matrix of the train data and the test data.

ntr=size(double(traingnd),1);
nts=size(double(testgnd),1);
M=-ones(ntr,nts);
for i=1:ntr
    i
    for j=1:nts
        j
        if double(traingnd(i,:))*double(testgnd(j,:))'~=0      
            M(i,j)=1;
        end
    end
end





%cateTrainTest=logical(M);
end