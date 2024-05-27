clear
clc

addpath(genpath('src/.'))

m = 100;
n = 50;

sigma = 0.1;
sparsity = 0.1;

A = randn(m,n);
x0 = SimplexProj(full(sprand(n,1,sparsity)));
b = A*x0 + sigma*randn(m,1);
C = randn(n,n);
x = rand(n,1);

options.maxiter = 200;
options.x = x;
options.threshold = 0.06;

[x1,err1,err_time1] = pgLASSO(A,C,b,options);
[x2,err2,err_time2] = mdLASSO(A,C,b,options);

figure(1)
plot(1:options.maxiter,err_time1,'r','LineWidth',2)
hold on
plot(1:options.maxiter,err_time2,'b','LineWidth',2)
legend('PG','BG')
xlabel('Iteration')
ylabel('Running time')
title('\sigma = 0.1')

figure(3)
subplot(2,1,1)
stem(find(x0>0),x0(x0>0),'k','filled','LineWidth',2)
hold on
stem(find(x1>0)-0.4,x1(x1>0),'r','filled','LineWidth',2)
legend('Real','PG')
subplot(2,1,2)
stem(find(x0>0),x0(x0>0),'k','filled','LineWidth',2)
hold on
stem(find(x2>0)-0.4,x2(x2>0),'b','filled','LineWidth',2)
legend('Real','BG')








