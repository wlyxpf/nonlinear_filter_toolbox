function [sm]=smoothing(p,cur,lastp,lastf,u)
% DD1/SMOOTHING - proceeds smoothing step
% based on the Rauch-Tung-Striebel Smoother
% returns information structure about
% smoothing pdf
% 1st arg.: object - instance of the dd1 class
% 2nd arg.: current smoothing info
% 3rd arg.: last predictive info
% 4th arg.: last filtering info
%
% note: nonsquare-root version

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
% In: Preprints of the 14th IFAC Symposium on System Identification.
% Newcastle, Australia.

% Nonlinear Filtering Toolbox version 2.0-rc4
% Copyright (c) 1995 - 2007 NFT developement Team,
%              Department of Cybernetics,
%              University of West Bohemia in Pilsen

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% variables
system = get(p,'system');      % system

h = p.h;

% polynomial interpolation

% Covariance matrix computation
Vf = lastf.var;
Vp = lastp.var;
Vc = cur.var;

% Auxiliary matrix Sxx1
Sxx1 = [];
for idx=1:1:system.nx
    sxj = lastf.sqrtvar(:,idx);

    if nargin == 5 & system.nu>0
        % input passed as parameted and is defined in system
        xd = nfeval(system.f,[u' (lastf.mean + sxj*h)' zeros(1, system.nw)]) ;
        xd_ = nfeval(system.f,[u' (lastf.mean - sxj*h)' zeros(1, system.nw)]) ;
    else
        % input is not defined in the system
        xd = nfeval(system.f,[(lastf.mean + sxj*h)' zeros(1, system.nw)]) ;
        xd_ = nfeval(system.f,[(lastf.mean - sxj*h)' zeros(1, system.nw)]) ;
    end
    Sxx1 = [Sxx1 (xd - xd_)/(2*h)];
end;


% Evaluation of the covariance cov(x_prediktive, x_filrering),
% i.e. E{(x(k+1)-x_pred(k+1))(x(k)-x_filt(k))}
Pxx = lastf.sqrtvar*Sxx1';

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% smoothing
Kv = Pxx * inv(Vp);
M = lastf.mean + Kv * (cur.mean - lastp.mean);
V = Vf - Kv * (Vp - Vc) * Kv';
%sm = gpdf(double(M),(double(V)+double(V)')/2);

%sm.mean = double(M);
%sm.var = chol(V);

sm.mean = M;
sm.var = V;
%sm.sqrtvar = chol(V)';


% CHANGELOG

