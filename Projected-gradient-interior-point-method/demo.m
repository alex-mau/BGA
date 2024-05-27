clear
clc

addpath('./src')

rng(10)

m = 50;
n = 20;

% A = [1 1
%     1 1/4
%     1 -1
%     -1/4 -1
%     -1 -1
%     -1 1];
% 
% b = [2 1 2 1 -1 2]';
% c = [-1 -1/3]';

%x0 = linprog(c,A,b);

A = rand(m,n);
b = rand(m,1);
c = rand(n,1);

lambda = 0.1;
beta = 0.5;
t = 0.01;

x = rand(n,1);

options.maxiter = 100;
options.x = x;

[x1,err1,err_time1] = pgIPM(A,b,c,options);
[x2,err2,err_time2] = mdIPM(A,b,c,options);

figure(1)
plot(1:options.maxiter,err_time1,'r','LineWidth',2)
hold on
plot(1:options.maxiter,err_time2,'b','LineWidth',2)
legend('PG','BG')
xlabel('Iteration')
ylabel('Running time')
title('Linear programming')







