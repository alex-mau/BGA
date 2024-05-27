clear all; 
close all; 
clc; 

load('../datasets/mnist.mat')
load('../datasets/mnist_labels.mat')
[m,n]=size(X);
rng(986)
r = 10;
perm = randperm(n);
X = X(:,perm);
labels = labels(perm);
N = 500;
X = X(:,1:N);
labels = labels(1:N);
target_idx = find(labels==9);
% Normalizing between 0 and 1
for i = 1 : size(X,2)
    X(:,i) = (X(:,i) - min(X(:,i)))/(max(X(:,i))-min(X(:,i)));
end
[Ki,Hi] = SNPA(X,r);

[m,n] = size(X);
nX = norm(X,'fro');
options.W = X(:,Ki); 
options.H = SimplexColProj( Hi ); 
% options.W = rand(m,r);
% options.H = rand(r,n);
% options.H = Hi;
options.maxiter = 500; 
options.maxtime = Inf;
options.inneriter = 20;
options.inertial = true ;
options.accuracy = 0;

% *************************************************************************

L_div = divisors(r);
Col = max(L_div(1:end-1));
Lin = int64(r/Col);
% [~,Qa]=min(abs(divisors(r)-sqrt(r)));
% Qa = L_div(Qa);
% Qb = r/Qa;
% Lin = int64(min(Qa,Qb));
% Col = int64(max(Qa,Qb));

% *************************************************************************

disp('*** Running BSSMF ***'); 
options.lb = 0;
options.ub = 1;
[Wb,Hb,errb] = boundedSSMF(X,r,options);
% sum(Wb==0,[1 2])
% sum(Wb==1,[1 2])
% histogram(Wb,0:0.01:1)
disp('Relative error in percent for BSSMF:');
norm(X-Wb*Hb,'fro')/nX*100
affichage(Wb,Col,28,28); title('BSSMF');
figWb = gca;
% affichage(Wb*Hb,ceil(sqrt(r)),28,28); title('BSSMF');
affichageT( Hb(:,target_idx) , ceil(sqrt(length(target_idx))) , Lin , Col); title('bssmf weights')
figHb = gca;
temp = Wb*Hb;
affichage( temp(:,target_idx) , ceil(sqrt(length(target_idx))) , 28 , 28); title('bssmf reconstruction')
figWbHb = gca;
Wb_im=get(get(figWb,'Children'),'CData');
% imwrite(imresize(Wb_im,4,'nearest'),'test/res/Wb.png')
% *************************************************************************

disp('***  Running NMF  ***');
options.lb = 0;
options.ub = Inf;
% options.inertial = false;
[Wf,Hf,e] = boundedSSMF(X,r,options);
disp('Relative error in percent for NMF:'); 
norm(X-Wf*Hf,'fro')/nX*100
affichage(Wf,Col,28,28); title('NMF');
figWf = gca;
Wf_im=get(get(figWf,'Children'),'CData');
% imwrite(imresize(Wf_im,4,'nearest'),'test/res/Wf.png')
% *************************************************************************

% figure; 
% semilogy(sqrt(2*e)/nX,'b'); hold on; y
% semilogy(sqrt(2*errb)/nX,'r--'); 
% legend('FroNMF', 'BSSMF','Interpreter','latex'); 
% xlabel('Iterations','Interpreter','latex'); 
% ylabel('Relative error $\|X-WH\|_F/\|X\|_F$','Interpreter','latex'); 
% % close all
% fprintf('NMF   -->  SSC for Hf : %1.0f, SSC for Wf          :  %1.0f \n', ... 
%     SSC1_nec_cond(Hf), SSC1_nec_cond(Wf'))
% 
% % fprintf('      -->  SSC for [Wf; max(Wf)-Wf]            :  %1.0f \n', ... 
% %     SSC1_nec_cond([Wf; max(Wf(:))-Wf]'))
% 
% fprintf('BSSMF -->  SSC for Hb : %1.0f, SSC for [Wb; 1-Wb]  :  %1.0f \n', ... 
%     SSC1_nec_cond(Hb), SSC1_nec_cond([Wb; 1-Wb]'))