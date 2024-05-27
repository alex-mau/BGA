
function [W,H,err,err_time] = boundedSSMF(X,r,options)

if nargin <= 2
    options = [];
end
if ~isfield(options,'ub')
    ub = max(X(:));
else
    ub = options.ub;
end
if ~isfield(options,'lb')
    lb = min(X(:));
else
    lb = options.lb;
end
if ~isfield(options,'maxtime')
    maxtime = 5;
else
    maxtime = options.maxtime;
end
if ~isfield(options,'maxiter')
    maxiter = 100;
else
    maxiter = options.maxiter;
end
if ~isfield(options,'inertial')
    inertial = false;
else
    inertial = options.inertial;
end
if isfield(options,'W') && isfield(options,'H') 
    W = options.W;
    H = options.H;
else
    [m,n] = size(X);
    W = rand(m,r)*(ub-lb)+lb;
    H = SimplexColProj(randn(r,n));
%     opt_snpa.display = 0;
%     [K,H] = SNPA(X,r,opt_snpa);
%     W = X(:,K);
%     if length(K) < r
%         warning('SNPA recovered less than r basis vectors.');
%         warning('The data poins have less than r vertices.');
%         r = length(K);
%         fprintf('The new value of r is %2.0d.\n',r);
%     end
end
if isfield(options,'delta_iter')
    delta_iter = options.delta_iter;
else
    delta_iter = 1e-6;
end
if isfield(options,'inneriter') % number of updates of W and H, before the other is updated
    inneriter = options.inneriter;
else
    inneriter = 20;
end

% Initializations
normX2 = norm(X,'fro')^2;
WtW = W'*W;
WtX = W'*X;
HHt=H*H';
XHt=X*H';
err = nan(1,maxiter);
err_time = nan(1,maxiter);
err(1) = 0.5*(normX2-2*sum(sum(WtX.*H))+sum(sum( WtW.*HHt)));
err_time(1) = 0;
LpW = norm(HHt);
LW = LpW;
LpH = norm(WtW);

% Main loop 
k=1;
Wold = W;
Hold = H;

% extrapolation sequence
alpha1=1;
alpha2=1;
while err_time(k) < maxtime && k<maxiter
    tic
    k = k+1;
    % *** Update W ***  
    iter = 1; % inner iter counter
    % Stop if ||W^{k}-W^{k+1}||_F <= delta * ||W^{0}-W^{1}||_F
    eps0 = 0; eps = 1;
	Woldold = W;
    while iter <= inneriter && eps >= delta_iter*eps0
        alpha0 = alpha1;
        alpha1 = 0.5*(1+sqrt(1+4*alpha0^2));
        if inertial
			beta = min((alpha0-1)/alpha1 , 0.9999*sqrt(LpW/LW));
            Wextra = W + beta*(W-Wold);
            Wold=W;
            W = Wextra + 1/LW*(XHt - Wextra*HHt);
        else
            W = W + 1/LW*(XHt - W*HHt);
        end
        if lb>-Inf
            W = max(W,lb);
        end
        if ub <Inf
            W = min(W,ub);
        end
        if iter == 1
            eps0 = norm(W-Woldold,'fro'); 
        end
        WtW = W'*W; % Pre-computing to save computation time
        LpW=LW;
        eps = norm(W-Woldold,'fro');
        iter = iter + 1;
    end
    LH = norm(WtW); % New Lipschitz constant for H
    WtX = W'*X; % Pre-computing to save computation time
   
    
    % *** Update H ***
    iter = 1; % inner iter counter
    % Stop if ||H^{k}-H^{k+1}||_F <= delta * ||H^{0}-H^{1}||_F
    eps0 = 0; eps = 1;
	Holdold = H;
    while iter <= inneriter && eps >= delta_iter*eps0
        alpha0 = alpha2;
        alpha2 = 0.5*(1+sqrt(1+4*alpha0^2));   
        if inertial
			beta = min((alpha0-1)/alpha2 , 0.9999*sqrt(LpH/LH));
            Hextra = H + beta*(H-Hold);
            Hold=H;
            H = Hextra + 1/LH*(WtX - WtW*Hextra);
        else
            H = H + 1/LH*(WtX - WtW*H);
        end
        if ub <Inf
            H = SimplexColProj(H);
        else
            H = max(H,0);
        end
        
        if iter == 1
            eps0 = norm(H-Holdold,'fro'); 
        end
        eps = norm(H-Holdold,'fro');
        LpH=LH; 
        iter = iter + 1;
    end
    HHt = H*H'; % Pre-computing to save computation time
    XHt = X*H'; % Pre-computing to save computation time
    LW = norm(HHt); % New Lipschitz constant for W
    
    % *** Saving the error without taking into account the error
    % computation time *** %
    elapsed_time = toc;
    err(k) = 0.5*(normX2 - 2*sum(sum( WtX.*H ) )  + sum(sum( WtW.*HHt ) ) );
    err_time(k) = err_time(k-1) + elapsed_time; 
end