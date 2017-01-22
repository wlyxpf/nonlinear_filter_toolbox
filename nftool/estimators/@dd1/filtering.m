function [filt]=filtering(p,pred,z)
% DD1/FILTERING - proceeds filtering step
% returns information structure about
% filtering pdf
%
% the stress is laid on algorithm transparency rather than numerical effectiveness
% the more numerical effective algorithm is the UKF
%

% References:
% M. Norgaard, N. K. Poulsen and O. Ravn (2000): 
% New developments in state estimation for nonlinear systems. 
% Automatica 36(11), 1627-1638.

% Nonlinear Filtering Toolbox version 2.0-rc4
% Copyright (c) 1995 - 2007 NFT developement Team,
%              Department of Cybernetics,
%              University of West Bohemia in Pilsen


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% variables
system = get(p,'system');       % system

Mp = pred.mean;                % mean of prediction 
Vp = pred.var;                 % predictive covariance
Sp = find_cov(pred);           % square-root predictive covariance matrix          

pvmean = mean(system.pv);       % mean of measurement noise
R = var(system.pv);             % variance of measurement noise  
Sr = chol(R');                  % decomposition of measurement noise variance

delta = system.delta;           % the DELTA matrix of system

h = p.h;                    

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Auxilliary matrix Szx1
Szx1 = [];
for idx=1:1:system.nx
    sxj = Sp(:,idx);
    
    zd = nfeval(system.h,[(Mp + sxj*h)' zeros(1, system.nv)]) ;
    zd_ = nfeval(system.h,[(Mp - sxj*h)' zeros(1, system.nv)]) ;
       
    Szx1 = [Szx1 (zd - zd_)/(2*h)];
end;

% Prediction of measurement
zp = nfeval(system.h,[Mp' zeros(1, system.nv)]) + delta*pvmean;

% Covariance of measurement prediction
Szp = triag([Szx1 delta*Sr]);

% Cross-correlation predictive matrix of x and z
Pxzp = Sp*(Szx1)';


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Kalman gain
%K = Pxzp*inv(Szp*Szp');
K = Pxzp/Szp'/Szp;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% filtering - state, variance
if (sum(sum(isnan(K))) == 0) & (sum(sum(isinf(K))) == 0)
    
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % filtering mean
  M = Mp + K * (z - zp);

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % filtering covariance matrix
  S = triag([Sp-K*Szx1 K*Sr]);


% CHANGELOG % Nonlinear Filtering Toolbox version 2.0-rc4
% Copyright (c) 1995 - 2007 NFT developement Team,
%              Department of Cybernetics,
%              University of West Bohemia in Pilsen

else
    
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % filtering mean
  M = Mp;

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % filtering covariance matrix
  S = zeros(size(Sp));
  
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% result

%display('Filtering')


%filt = gpdf(M,(V + V')/2);
filt.mean = M;
filt.var = S*S';
filt.sqrtvar = S;
