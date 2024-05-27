clear
clc
addpath(genpath('src/.'));
max_dim = 10;
max_exp = 1;

E1 = zeros(max_dim,max_exp);
E2 = zeros(max_dim,max_exp);
T1 = zeros(max_dim,max_exp);
T2 = zeros(max_dim,max_exp);

for i=1:max_dim
    n = 10*i;
    for j=1:max_exp
        X = full(sprand(n,n,0.1));
        r = i;
        ub = max(max(X));
        lb = min(min(X));
        W = rand(n,r)*(ub-lb)+lb;
        H = SimplexColProj(randn(r,n));
        [Wb1,Hb1,err1,err_time1] = mdSSMF(X,r);
        [Wb2,Hb2,err2,err_time2] = boundedSSMF(X,r);
        E1(i,j) = err1(end);  E2(i,j) = err2(end);
        T1(i,j) = err_time1(end);  T2(i,j) = err_time2(end);
    end
end

figure(1)
errorbar(1:max_dim,sum(T1,2)/max_exp,std(T1,0,2),'-bo','LineWidth',1.5)
hold on
errorbar(1:max_dim,sum(T2,2)/max_exp,std(T2,0,2),'-rs','LineWidth',1.5)
title('Running time')
legend('MD','PG')

figure(2)
errorbar(1:max_dim,sum(E1,2)/max_exp,std(E1,0,2),'-bo','LineWidth',1.5)
hold on
errorbar(1:max_dim,sum(E2,2)/max_exp,std(E2,0,2),'-rs','LineWidth',1.5)
title('Error')
legend('MD','PG')





