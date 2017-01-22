function [sm]=smoothing(p,cur,lastp,lastf,u)
% UKF/SMOOTHING - proceeds smoothing step
% based on the Rauch-Tung-Striebel Smoother
% returns information structure about
% smoothing pdf
% 1st arg.: object - instance of the dd1 class
% 2nd arg.: current smoothing info
% 3rd arg.: last predictive info
% 4th arg.: last filtering info
%

% References:
% S.J. Julier, J. K. Uhlmann and H. F. Durrant-White (2000):
% A new method for the nonlinear transformation of means and covariances in filters and estimators.
% IEEE Trans. On AC 45(3), 477–482.
%
% M. Simandl, and J. Dunik (2005):
% Sigma point gaussian sum filter design using square root unscented filters.
% In: Preprints of 16th IFAC World Congress. Prague, Czech Republic.
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

pwmean = mean(system.pw);       % mean of state noise

gamma = system.gamma;           % the GAMMA matrix of system

kappa = p.kappa;                % scaling parameter kappa

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if strcmp(p.at,'standard')
    %Covariance matrix determiantion
    Vf = lastf.var;
    Vp = lastp.var;
    Vc = cur.var;

    % filtering sigma-points
    [chi_v,w] = msp(lastf.mean,Vf,kappa,system.nx);

    %Number of sigma-points
    % [Ins,Jns]=size(chi_v);
    Jns = 2*system.nx + 1;

    %Computation predictive sigma-points
    if nargin == 3 && system.nu > 0   % input passed as parameted and is defined in system
        for idx=1:1:Jns
            chip_v(:,idx) = nfeval(system.f,[u' chi_v(:,idx)' zeros(1, system.nw)]);
        end;
    else
        for idx=1:1:Jns  % input is not defined in the system
            chip_v(:,idx) = nfeval(system.f,[chi_v(:,idx)' zeros(1, system.nw)]);
        end;
    end;

    %Predictive statistics in smoothing without Q = var(system.pw)
    xpvv = chip_v*w' + gamma*pwmean;

    %State predictive covariance
    chi_v_ = chi_v - lastf.mean(:,ones(1,Jns));
    chip_v_ = chip_v - xpvv(:,ones(1,Jns));
    chip_v_w = chip_v_.*w(ones(1,system.nx),:);

    % Evaluation of the covariance cov(x_prediktive, x_filrering),
    % i.e. E{(x(k+1)-x_pred(k+1))(x(k)-x_filt(k))}
    Pxx = chi_v*chip_v_w';

    % smoothing
    Kv = Pxx * inv(Vp);
    M = lastf.mean + Kv * (cur.mean - lastp.mean);
    V = Vf - Kv * (Vp - Vc) * Kv';

    sm.mean = M;
    sm.var = V;
elseif strcmp(p.at,'squareroot')
    %Factors of covariance matrices
    Sf = lastf.sqrtvar;
    Sp = lastp.sqrtvar;
    Sc = cur.sqrtvar;
    Sq = chol(var(system.pw)');          % decomposition of state noise variance

    % filtering sigma-points
    [chi_v,w] = smsp(lastf.mean,Sf,kappa,system.nx);

    %Number of sigma-points
    % [Ins,Jns]=size(chi_v);
    Jns = 2*system.nx + 1;

    %Computation predictive sigma-points
    if nargin == 3 && system.nu > 0   % input passed as parameted and is defined in system
        for idx=1:1:Jns
            chip_v(:,idx) = nfeval(system.f,[u' chi_v(:,idx)' zeros(1, system.nw)]);
        end;
    else
        for idx=1:1:Jns  % input is not defined in the system
            chip_v(:,idx) = nfeval(system.f,[chi_v(:,idx)' zeros(1, system.nw)]);
        end;
    end;

    %Predictive statistics in smoothing without Q = var(system.pw)
    xpvv = chip_v*w' + gamma*pwmean;

    %State predictive covariance
    chi_v_ = chi_v - lastf.mean(:,ones(1,Jns));
    chip_v_ = chip_v - xpvv(:,ones(1,Jns));
    chi_v_w = chi_v_.*sqrt(w(ones(1,system.nx),:));
    chip_v_w = chip_v_.*sqrt(w(ones(1,system.nx),:));

    % Evaluation of the covariance cov(x_prediktive, x_filrering),
    % i.e. E{(x(k+1)-x_pred(k+1))(x(k)-x_filt(k))}
    Pxx = chi_v_w*chip_v_w';

    % smoothing
    %Kv = Pxx * inv(Sp*Sp');
    Kv = Pxx * inv(lastp.var);
    M = lastf.mean + Kv * (cur.mean - lastp.mean);
    S = triag([chi_v_w-Kv*chip_v_w Kv*Sq Kv*Sc]);

    %results
    sm.mean = M;
    sm.var = S*S';
    sm.sqrtvar = S;
end;

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%sm.sqrtvar = chol(V)';


% CHANGELOG
