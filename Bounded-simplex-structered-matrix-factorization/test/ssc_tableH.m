clear all
close all
clc

load('../mnist.mat')
[m,n]=size(X);
% Normalizing between 0 and 1
for i = 1 : size(X,2)
    X(:,i) = (X(:,i) - min(X(:,i)))/(max(X(:,i))-min(X(:,i)));
end

options.maxiter = 100; 
options.maxtime = Inf;
options.inneriter = 20;
options.inertial = true ;
options.accuracy = 0;
options.lb = 0;
options.ub = 1;
options_snpa.display = false;

N_list = 100:25:300;
r_list = 10:5:50;
seed = 111;
nb_seeds = 10;
SSC_table_H = zeros(nb_seeds,length(N_list),length(r_list));
% Seed loop
for s = 0:(nb_seeds-1)
    % Number of samples loop
    rand_list = randperm(n);
    for Nk = 1:length(N_list)
        N = N_list(Nk);
        % Resetting rng seed
        rng(seed+s)
        XN = X(:,rand_list(1:N));
        for rk = 1:length(r_list)
            r = r_list(rk);
            [Ki,Hi] = SNPA(XN,r,options_snpa);
            options.W = XN(:,Ki);
            if options.ub < Inf
                options.H = SimplexColProj( Hi );
            else
                options.H = Hi;
            end
            [W,H] = boundedSSMF(XN,r,options);
            fprintf('Loop : %d | n : %d | r : %d | ',s,N,r)
            SSC_table_H(s+1,Nk,rk) = SSC1_nec_cond(H);
            fprintf('SSC1 nec cond H : %d \n',SSC_table_H(s+1,Nk,rk))
        end
    end
end

mean_SSC_table_H = squeeze(mean(SSC_table_H,1));
med_SSC_table_H = squeeze(median(SSC_table_H,1));

set(0, 'DefaultAxesFontSize', 12);

figure
imagesc(med_SSC_table_H)
colormap(gray); 
colorbar; 
title(sprintf('med H'),'Interpreter','latex'); 
set(gca,'xtick',1:length(r_list)); 
set(gca,'xticklabel',r_list);
xlabel('rank ($r$)','Interpreter','latex');
set(gca,'ytick',1:length(N_list)); 
set(gca,'yticklabel',N_list);
ylabel('number of samples ($n$)','Interpreter','latex')

figure
load('mnist.mat');
title(sprintf('mean H'),'Interpreter','latex'); 
set(gca,'xtick',1:length(r_list)); 
set(gca,'xticklabel',r_list);
xlabel('rank ($r$)','Interpreter','latex');
set(gca,'ytick',1:length(N_list)); 
set(gca,'yticklabel',N_list);
ylabel('number of samples ($n$)','Interpreter','latex')

% LaTeX Tables
if options.ub < Inf
    fileID = fopen(pwd+"/test/res/"+'sscTableH.tex','w');
else
    fileID = fopen(pwd+"/test/res/"+'sscTableHf.tex','w');
end
for i = 1:length(N_list)
    for j = 1:length(r_list)
        if j == length(r_list)
            fprintf(fileID,'%d},\n',int64(100*mean_SSC_table_H(i,j)));
        else
            if j == 1
                fprintf(fileID,'{%d,',int64(100*mean_SSC_table_H(i,j)));
            else
                fprintf(fileID,'%d,',int64(100*mean_SSC_table_H(i,j)));
            end
        end
    end
end
fclose(fileID);
