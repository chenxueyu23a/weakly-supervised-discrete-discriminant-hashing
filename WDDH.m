function [G, FW, B] =WDDH(X,Sb,Sc,B,gmap,Fmap,tol,maxItr,debug)

% ---------- Argument defaults ----------
if ~exist('debug','var') || isempty(debug)
    debug=1;
end
if ~exist('tol','var') || isempty(tol)
    tol=1e-5;
end
if ~exist('maxItr','var') || isempty(maxItr)
    maxItr=1000;
end
nu = Fmap.nu;  %penalty parm for F term
delta = 1/nu;
% ---------- End ----------

%µü´ú¸üÐÂ

% G-step    update W  
 [Wg] =gw(B,Sb,Sc);
%  [Wg] =large_gw(anchor_dat,tr_dat,S);%large scale data

G.W = Wg;  

% F-step  update p

[WF, ~, ~] = RRC(X, B', Fmap.lambda);

FW= WF;

%FW 1001*32 X 10000*1001
i = 0; 
while i < maxItr    
    i=i+1;  
    
    if debug,fprintf('Iteration  %03d: ',i);end
    
    % B-step
  
        XF = X*WF;        %100000*32
        FW= G.W*G.W'*B*(Sc-Sb);
    %32*10000=32*5 5*32 32*10000  10000*10000   
         B= sign(2*nu*XF' +G.W*G.W'*B*(Sc-Sb));
     
    % G-step
    [Wg] =gw(B, Sc,Sb);
    G.W = Wg;
    
    % F-step 
    WF0 = WF;
    
    [WF, ~, ~] = RRC(X, B', Fmap.lambda);
   
    FW= WF; 
    
    bias = norm(B-XF','fro');
    
    if debug, fprintf('  bias=%g\n',bias); end
    
    if bias < tol*norm(B,'fro')
            break;
    end 
    
    
    if norm(WF-WF0,'fro') < tol * norm(WF0)
        break;
    end
    
    
end