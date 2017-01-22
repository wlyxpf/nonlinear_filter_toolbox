function [filt]=filtering(p,pred,z)
% DD2/FILTERING - proceeds filtering step
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

% Auxilliary matrices
Szx1 = [];
Szx2 = [];
MatSzx1 = zeros(system.nv,1);
zds = nfeval(system.h,[Mp' zeros(1, system.nv)]) ;
for idx=1:1:system.nx
    xpe = Mp + Sp(:,idx)*h;
    xpe_ = Mp - Sp(:,idx)*h;
      
    zd = nfeval(system.h,[xpe' zeros(1, system.nv)]) ;
    zd_ = nfeval(system.h,[xpe_' zeros(1, system.nv)]) ;
             
    Szx1 = [Szx1 (zd - zd_)/(2*h)];
    Szx2 = [Szx2 ((sqrt(h^2-1))/(2*h^2))*(zd + zd_ - 2*zds)];
    MatSzx1 = MatSzx1 + (1/(2*h^2))*(zd + zd_);
 end;

% Prediction of measurement
zp = ((h^2-system.nx)/(h^2))*zds + MatSzx1 + delta*pvmean;

% Covariance of measurement prediction
Szp = triag([Szx1 delta*Sr Szx2]);

% Cross-correlation predictive matrix x and z
Pxzp = Sp*(Szx1)';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Kalman gain
%K = Pxzp*inv(Szp*Szp');
K = Pxzp/Szp'/Szp;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% filtering - mean, variance
if (sum(sum(isnan(K))) == 0) & (sum(sum(isinf(K))) == 0)
    
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % filtering mean 
  M = Mp + K * (z - zp);

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % variance of filtering state estimate
  S = triag([Sp-K*Szx1 K*Sr K*Szx2]);

else
    
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % filtering mean
  M = Mp;

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % variance
  S = zeros(size(Sp));
  
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% result

%display('Filtering')


%filt = gpdf(M,(V + V')/2);
filt.mean = M;
filt.var = S*S';
filt.sqrtvar = S;

% CHANGELOG 
