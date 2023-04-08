function W = ConstructAdjacencyGraphinclassgai(X,classnum,traingnd, Kneighbor,form,delta)
%Construct Adjacency Graph with k neighbor
X=X';          %change to each row vector of X is a data point,there is only training samples in X 
NData = size(X,1);%sample number
distance = zeros(NData, NData);
W = ones(NData, NData);

for i = 1 : NData
    for j = i : NData
        distance(i, j) = norm(X(i, :) - X(j, :)); %
        distance(j, i) = distance(i, j);
    end
end    
[dumb idx] = sort(distance, 2);
if Kneighbor+1>NData
    Kneighbor=NData-1;%Kneighbor can't more than NData
end

form==0;  %euclidean distance
for i = 1 : NData
    for j = i : NData
        if(traingnd(i)~=traingnd(j))
%             W(i,j)=0;
            W(i,j)=exp( -norm(X(i, :) - X(j, :))/delta);
            W(j,i)=W(i,j);   
        end
    end
end



