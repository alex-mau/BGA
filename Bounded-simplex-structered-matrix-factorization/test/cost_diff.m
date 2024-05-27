clear all; 
close all; 
clc; 

load('../datasets/mnist.mat')
[m,n]=size(X);
rng(986)
Rs = 10:2:20;
rec_err = NaN*ones(2,length(Rs));
perm = randperm(n);
X = X(:,perm);
% Normalizing between 0 and 1
for i = 1 : size(X,2)
    X(:,i) = (X(:,i) - min(X(:,i)))/(max(X(:,i))-min(X(:,i)));
end
N = 500;
X = X(:,1:N);



[m,n] = size(X);
nX = norm(X,'fro');
opt_snpa.display = 0;
options.maxiter = 500; 
options.maxtime = Inf;
options.inneriter = 20;
options.inertial = true ;
options.accuracy = 0;

for rk = 1:length(Rs)
    r = Rs(rk);
    [Ki,Hi] = SNPA(X,r,opt_snpa);
    options.W = X(:,Ki); 
    options.H = SimplexColProj( Hi );
    % *********************************************************************

    disp('*** Running BSSMF ***'); 
    options.lb = 0;
    options.ub = 1;
    [Wb,Hb,errb] = boundedSSMF(X,r,options);
    rec_err(1,rk) = norm(X-Wb*Hb,'fro')/nX*100;
    fprintf('Relative error in percent for BSSMF: %d\n',rec_err(1,rk));
    % *********************************************************************

    disp('***  Running NMF  ***');
    options.lb = 0;
    options.ub = Inf;
    % options.inertial = false;
    [Wf,Hf,e] = boundedSSMF(X,r,options);
    rec_err(2,rk) = norm(X-Wf*Hf,'fro')/nX*100;
    fprintf('Relative error in percent for NMF  : %d\n',rec_err(2,rk));
    % *********************************************************************
end

fileID = fopen(pwd+"/test/res/"+'rec_err_table.tex','w');

fprintf(fileID,'\\begin{table}\n');
fprintf(fileID,'\\centering\n');
fprintf(fileID,"\t\\begin{tabular}{"+char(kron('c',ones(1,length(Rs)+1)))+"}\n");

fprintf(fileID,'\t\t\\diagbox{r}{Alg.}');
for j = 1:length(Rs)
    fprintf(fileID,' & %d',Rs(j));
end
fprintf(fileID,'\n');

fprintf(fileID,'\t\t NMF');
for j = 1:length(Rs)
    fprintf(fileID,' & %2.2f',rec_err(1,j));
end
fprintf(fileID,'\n');

fprintf(fileID,'\t\t BSSMF');
for j = 1:length(Rs)
    fprintf(fileID,' & %2.2f',rec_err(2,j));
end
fprintf(fileID,'\n');

fprintf(fileID,'\t\\end{tabular}\n');
fprintf(fileID,'\\end{table}\n');