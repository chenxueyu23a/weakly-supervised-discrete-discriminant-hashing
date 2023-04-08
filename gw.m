function [U] =gw(tr_dat,Sb,Sc)



%projection matrix computing
M=tr_dat*(Sb-Sc)*tr_dat';
[U,V] = eigs(M);
V=diag(V);
ind=V>0;
U=U(:,ind);    




end


