clear all
close all
clc

load('../mnist.mat')
[m,n]=size(X);
% Normalizing between 0 and 1
for i = 1 : size(X,2)
    X(:,i) = (X(:,i) - min(X(:,i)))/(max(X(:,i))-min(X(:,i)));
end
X = reshape(X,28,28,size(X,2));
options.maxiter = 100; 
options.maxtime = Inf;
options.inneriter = 20;
options.inertial = true ;
options.accuracy = 0;
options.lb = 0;
options.ub = 1;
options_snpa.display = false;

M_list = 12:2:28;
r_list = 14:2:30;
N = 300;
seed = 111;
nb_seeds = 10;
SSC_table_W = zeros(nb_seeds,length(M_list),length(r_list));
% Seed loop
for s = 0:(nb_seeds-1)
    % Number of samples loop
    rand_list = randperm(n);
    for Mk = 1:length(M_list)
        % Resetting rng seed
        rng(seed+s)
        M = M_list(Mk);
        XN = X(:,:,rand_list(1:N));
        XN_flat = reshape(imresize3(XN,[M, M, N],'linear'),M*M,N);
        for rk = 1:length(r_list)
            r = r_list(rk);
            [Ki,Hi] = SNPA(XN_flat,r,options_snpa);
            options.W = XN_flat(:,Ki); 
            options.H = SimplexColProj( Hi );
            [W,H] = boundedSSMF(XN_flat,r,options);
            fprintf('Loop : %d | m : %d | r : %d | ',s,M,r)
            if options.ub<Inf
                SSC_table_W(s+1,Mk,rk) = SSC1_nec_cond([W;1-W]');
            else
                SSC_table_W(s+1,Mk,rk) = SSC1_nec_cond(W');
            end
            fprintf('SSC1 nec cond W : %d \n',SSC_table_W(s+1,Mk,rk))
        end
    end
end

mean_SSC_table_W = squeeze(mean(SSC_table_W,1));
med_SSC_table_W = squeeze(median(SSC_table_W,1));

set(0, 'DefaultAxesFontSize', 12);

figure
imagesc(med_SSC_table_W)
colormap(gray); 
colorbar; 
title(sprintf('med W'),'Interpreter','latex'); 
set(gca,'xtick',1:length(r_list)); 
set(gca,'xticklabel',r_list);
xlabel('rank ($r$)','Interpreter','latex');
set(gca,'ytick',1:length(M_list)); 
set(gca,'yticklabel',M_list);
ylabel('resolution ($\sqrt{m}$)','Interpreter','latex')

figure
imagesc(mean_SSC_table_W)
colormap(gray); 
colorbar; 
title(sprintf('mean W'),'Interpreter','latex'); 
set(gca,'xtick',1:length(r_list)); 
set(gca,'xticklabel',r_list);
xlabel('rank ($r$)','Interpreter','latex');
set(gca,'ytick',1:length(M_list)); 
set(gca,'yticklabel',M_list);
ylabel('resolution ($\sqrt{m}$)','Interpreter','latex')

% LaTeX Tables
if options.ub < Inf
    fileID = fopen(pwd+"/test/res/"+'sscTableW.tex','w');
else
    fileID = fopen(pwd+"/test/res/"+'sscTableWf.tex','w');
end
for i = 1:length(M_list)
    for j = 1:length(r_list)
        if j == length(r_list)
            fprintf(fileID,'%d},\n',int64(100*mean_SSC_table_W(i,j)));
        else
            if j == 1
                fprintf(fileID,'{%d,',int64(100*mean_SSC_table_W(i,j)));
            else
                fprintf(fileID,'%d,',int64(100*mean_SSC_table_W(i,j)));
            end
        end
    end
end
fclose(fileID);
