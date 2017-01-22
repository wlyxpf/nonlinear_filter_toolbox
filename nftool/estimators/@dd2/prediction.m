function [next]=prediction(p,last,u)
% DD2/PREDICTION - proceeds prediction step
% returns information structure about
% predictive pdf
% 1st arg.: object
% 2nd arg.: necessary arguments (filtering)
%
% the stress is laid on algorithm transparency rather than numerical effectiveness
% the more numerical effective algorithm is the UKF
%

% References:
% M. Norgaard, N. K. Poulsen and O. Ravn (2000): 
% New developments in state estimation for nonlinear systems. 
% Automatica 36(11), 1627-1638.
%
% M. Simandl and J. Dunik (2006):
% Design of derivative-free smoothers and predictors. 
% In: Preprints of the 14th IFAC Symposium on System Identification. Newcastle, Australia.

% Nonlinear Filtering Toolbox version 2.0-rc4
% Copyright (c) 1995 - 2007 NFT developement Team,
%              Department of Cybernetics,
%              University of West Bohemia in Pilsen

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% variables
system = get(p,'system');       % system

M = last.mean;                 % mean of filtering
V = last.var;                  % filtering variance
S = last.sqrtvar;                   % decomposition of variance of filtering

pwmean = mean(system.pw);       % mean of w noise
Q = var(system.pw);             % variance of w noise
Sq = chol(Q');                   %decomposition of noise variance

gamma = system.gamma;           % the GAMMA matrix of system

h = p.h;

%Auxilliary matrix Szx1
Sxx1 = [];
Sxx2 = []; 
MatSxx1 = zeros(system.nx,1);
if nargin == 3 & system.nu>0
   % input passed as parameted and is defined in system
   xds = nfeval(system.f,[u' M' zeros(1, system.nw)]) ;
else
   % input is not defined in the system
   xds = nfeval(system.f,[M' zeros(1, system.nw)]) ;
end
for idx=1:1:system.nx
    xfe = M + S(:,idx)*h;
    xfe_ = M - S(:,idx)*h;
    
    if nargin == 3 & system.nu>0
        % input passed as parameted and is defined in system
        xd = nfeval(system.f,[u' xfe' zeros(1, system.nw)]) ;
        xd_ = nfeval(system.f,[u' xfe_' zeros(1, system.nw)]) ;
    else
        % input is not defined in the system
        xd = nfeval(system.f,[xfe' zeros(1, system.nw)]) ;
        xd_ = nfeval(system.f,[xfe_' zeros(1, system.nw)]) ;
    end
      
      Sxx1 = [Sxx1 (xd - xd_)/(2*h)];
      Sxx2 = [Sxx2 ((sqrt(h^2-1))/(2*h^2))*(xd + xd_ - 2*xds)];
      MatSxx1 = MatSxx1 + (1/(2*h^2))*(xd + xd_);
end;

% predictive mean
Mp = ((h^2-system.nx)/(h^2))*xds + MatSxx1 + gamma*pwmean;

% predictive covariance matrix of state
Sp = triag([Sxx1 gamma*Sq Sxx2]);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% prediction

%display('Prediction')
%next = gpdf(Mp,(Vp + Vp')/2);
next.mean = Mp;
next.var = Sp*Sp';
next.sqrtvar = Sp;



% CHANGELOG
