function [x,err,err_time] = pgIPM(A,b,c,options)
%PGIPM Summary of this function goes here
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
    beta = 0.5;
else
    beta = options.beta;
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
y = A*x-b;
err(1) = c'*x - lambda*sum(log(A*x-b)) + beta/2*norm(A*x-y)^2;
err_time(1) = 0;

% Main loop
while err_time(k) < maxtime && k<maxiter
    tic
    k = k + 1;
    
    dx = c + beta*A'*(A*x-y);
    x = x - t*dx;
    dy = - lambda./y + beta*(y-A*x);
    y = max(0,y - t*dy);
    
    % Saving computing time and error
    elapsed_time = toc;
    err(k) = c'*x - lambda*sum(log(A*x-b)) + beta/2*norm(A*x-y)^2;
    err_time(k) = err_time(k-1) + elapsed_time; 
end

end

