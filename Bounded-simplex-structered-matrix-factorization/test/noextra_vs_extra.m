clear all; 
close all; 
clc; 

load('../datasets/mnist.mat')
X = test.images;
[m,n]=size(X);
for i = 1 : size(X,2)
    X(:,i) = (X(:,i) - min(X(:,i)))/(max(X(:,i))-min(X(:,i)));
end
rng(986)
r = 50;
N = 1000;
repeat = 20;

opt_snpa.display = 0;
options.maxiter = 500; 
options.maxtime = Inf;
options.inneriter = 20;
options.accuracy = 0;
options.lb = 0;
options.ub = 1;
err_extra = zeros(1,options.maxiter);
err_noextra = zeros(1,options.maxiter);

for k = 1:repeat
    perm = randperm(n);
    XN = X(:,perm(1:N));
    nX = norm(XN,'fro');
    [Ki,Hi] = SNPA(XN,r,opt_snpa);
    options.W = XN(:,Ki); 
    options.H = SimplexColProj( Hi ); 

    % *********************************************************************

    disp('*** Running no extra BSSMF ***'); 
    options.inertial = false ;
    [Wn,Hn,errn] = boundedSSMF(XN,r,options);
    err_noextra = err_noextra + sqrt(2*errn)/nX;
    % *********************************************************************

    disp('***  Running extra BSSMF  ***');
    options.inertial = true ;
    [We,He,erre] = boundedSSMF(XN,r,options);
    err_extra = err_extra + sqrt(2*erre)/nX;
    % *********************************************************************
end

err_noextra = err_noextra/repeat;
todat = cat(2,[1:options.maxiter]',err_noextra');
save("test/res/err_noextra.dat", 'todat', '-ascii')

err_extra = err_extra/repeat;
todat(:,2)=err_extra;
save("test/res/err_extra.dat", 'todat', '-ascii')


