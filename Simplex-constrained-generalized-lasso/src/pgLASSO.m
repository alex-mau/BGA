function [x,err,err_time] = pgLASSO(A,C,b,options)
%PGLASSO Summary of this function goes here
%   Detailed explanation goes here

if nargin <= 3
    options = [];
end

if ~isfield(options,'maxiter')
    maxiter = 100;
else
    maxiter = options.maxiter;
end

if ~isfield(options,'maxtime')
    maxtime = 5;
else
    maxtime = options.maxtime;
end

if ~isfield(options,'t')
    t = 0.01;
else
    t = options.t;
end

if ~isfield(options,'lambda')
    lambda = 0.1;
else
    lambda = options.lambda;
end

if ~isfield(options,'beta')
    beta = 2;
else
    beta = options.beta;
end

if ~isfield(options,'threshold')
    threshold = 0.05;
else
    threshold = options.threshold;
end

if isfield(options,'x') 
    x = options.x;
else
    [~,n] = size(A);
    x = rand(n,1);
end

% Initializations
k = 1;
err = nan(1,maxiter);
err_time = nan(1,maxiter);
y = C*x;
err(1) = 0.5*norm(A*x-b)^2 + lambda*norm(y,1);
err_time(1) = 0;

% Main loop
while err_time(k) < maxtime && k<maxiter
    tic
    k = k + 1;
    
    dy = lambda/beta*sign(y)+(y-C*x);
    y = y - t*dy;
    dx = A'*(A*x-b) + beta*(C*x-y);
    x = SimplexProj(x - t*dx);
    
    % Saving computing time and error
    elapsed_time = toc;
    err(k) = 0.5*norm(A*x-b)^2 + lambda*norm(y,1);
    err_time(k) = err_time(k-1) + elapsed_time; 
end

x(x<threshold) = 0;
x = x/sum(x);

end

