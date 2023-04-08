function W = ConstructAGinterclassLDEgai(X,traingnd,classnum, Kneighbor,form,delta)

X=X' ;         %change to each row vector of X is a data point
NData = size(X,1);%sample number
distance = zeros(NData, NData);
W = ones(NData, NData);

    for i = 1 : NData
        for j = i : NData
            distance(i, j) = norm(X(i, :) - X(j, :)); %
            distance(j, i) = distance(i, j);
        end
    end    
    [dumb idx] = sort(distance, 2); % sort each row
    if Kneighbor+1>NData
        Kneighbor=NData-1;%Kneighbor can't more than NData
    end
for i=1:NData       
    for j=i+1:NData    
        if(traingnd(i)==traingnd(j))
%             W(i,j)=0;
             W(i,j)=exp( -norm(X(i, :) - X(j, :))/delta);
            W(j,i)=W(i,j);   
        end
    W(i,i)=0;
    end
end    




