function [U] =large_gw(anchor_dat,tr_dat,S)

%projection matrix computing
M=anchor_dat*S*tr_dat';
[U,V] = eigs(M);   
V=diag(V);
ind=V>0;
U=U(:,ind); 

end


