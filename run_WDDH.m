Nbits=[16,32,64,128,256];
for i=1:length(Nbits)
    nbits=Nbits(i);
    load('testbed/cifar_10_gist');
    data=10000; %the
    number of traindata
    traindata = traindata(1:data,:);
    traindata = double(traindata);
    testdata = double(testdata);
      
    Ntrain = size(traindata,1); %59000
    % Use all the training data
    X = traindata;
    Xall=[traindata',testdata'];
    traingnd= traingnd(1:data,:);
    label = double(traingnd);
    
    % get anchors
    n_anchors = 3000;
    anchorsind=randsample(Ntrain, n_anchors);
    % rand('seed',1);
    anchor = X(anchorsind,:);
    
    sigma = 0.4; % for normalized data
    PhiX = exp(-sqdist(X,anchor)/(2*sigma*sigma));%sqdist is used to calculate the Euclidean distance between sample point X and the anchor point
    PhiX = [PhiX, ones(Ntrain,1)];
    
    Phi_testdata = exp(-sqdist(testdata,anchor)/(2*sigma*sigma)); clear testdata
    Phi_testdata = [Phi_testdata, ones(size(Phi_testdata,1),1)];
    Phi_traindata = exp(-sqdist(traindata,anchor)/(2*sigma*sigma)); clear traindata;
    Phi_traindata = [Phi_traindata, ones(size(Phi_traindata,1),1)];
    
    
    % learn G and F
    maxItr = 5;
    gmap.lambda = 1; gmap.loss = 'L2';
    Fmap.type = 'RBF';
    Fmap.nu = 1e-5; %  penalty parm for F term
    Fmap.lambda = 1e-2;
    
    
    %  run algo
    % nbits =32;
    deltab=1;
    deltaw=10;
    % Init Z
    randn('seed',3);
    Zinit=sign(randn(Ntrain,nbits));
    
    X=X';
    classnum=10;
    Kneighbor=30;
    form=0;
    [Sb]= ConstructAGinterclassLDEgai(X,traingnd,classnum, Kneighbor,form,deltab);
    [Sc] = ConstructAdjacencyGraphinclassgai(X,classnum,traingnd, Kneighbor,form,deltaw);
    S=(Sc)-(Sb);
    % Àà¼ä
    debug=0;
    [~, FW, H] = WDDH(PhiX,Sb,Sc,Zinit',gmap,Fmap,[],maxItr,debug);% WDDH
    
    %  evaluation
    display('Evaluation...');
    
    AsymDist = 0; % Use asymmetric hashing or not
    
    if AsymDist
        H = H > 0; % directly use the learned bits for training data
    else
        H = Phi_traindata*FW > 0;
    end
    
    tH = Phi_testdata*FW > 0;
    
    hammRadius = 2;
    
    B = compactbit(H);
    tB = compactbit(tH);
    
    
    hammTrainTest = hammingDist(tB, B)';
    % hash lookup: precision and reall
    Ret = (hammTrainTest <= hammRadius+0.00001);
    cateTrainTest = cateTrainTest(1:data,:);
    [Pre, Rec] = evaluate_macro(cateTrainTest, Ret);
    
    % hamming ranking: MAP
    [~, HammingRank]=sort(hammTrainTest,1);
    MAP = cat_apcal(traingnd,testgnd,HammingRank);
    % fprintf('n is %d,anchor is %d,Kneighbor is %d ,precision for %d bits is %f.  ,Rec is %f. ,MAP is %f.  ',data,n_anchors,Kneighbor,nbits,Pre,Rec,MAP);
    fprintf('n is %d,anchor is %d  precision for %d bits is %f.  ,Rec is %f. ,MAP is %f.  ',data,n_anchors,nbits,Pre,Rec,MAP);
end














