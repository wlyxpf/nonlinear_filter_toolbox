function [next]=prediction(p,last,u)
% UKF/PREDICTION - proceeds prediction step
% returns information structure about
% predictive pdf
% 1st arg.: object
% 2nd arg.: necessary arguments (filtering)
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
system = get(p,'system');       % system

M = last.mean;                 % mean of filtering
V = last.var;                  % variance of filtering

pwmean = mean(system.pw);       % mean of state noise
Q = var(system.pw);             % variance of state noise

gamma = system.gamma;           % the GAMMA matrix of system

kappa = p.kappa;                % scaling parameter kappa

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if strcmp(p.at,'standard')
    % Filtering sigma-points
    [chi,w] = msp(M,V,kappa,system.nx);

    % Number of sigma-points
    % [Ins,Jns]=size(chi);
    Jns = 2*system.nx + 1;

    % Computation predictive sigma-points
    if nargin == 3 & system.nu>0   % input passed as parameted and is defined in system
        for idx=1:1:Jns
            chip(:,idx) = nfeval(system.f,[u' chi(:,idx)' zeros(1, system.nw)]);
        end;
    else
        for idx=1:1:Jns  % input is not defined in the system
            chip(:,idx) = nfeval(system.f,[chi(:,idx)' zeros(1, system.nw)]);
        end;
    end;


    % Predictive mean of state
    Mp = chip*w' + gamma*pwmean;

    % State predictive covariance matrix
    chip_ = chip - Mp(:,ones(1,Jns));
    chip_w = chip_.*w(ones(1,system.nx),:);

    Vp = chip_w*chip_'+ gamma*Q*gamma';

    %display('Prediction')
    %next = gpdf(Mp,(Vp + Vp')/2);
    next.mean = Mp;
    next.var = Vp;
elseif strcmp(p.at,'squareroot')
    S = last.sqrtvar;       % square-root filtering covariance matrix
    Sq = chol(Q');          % decomposition of state noise variance

    % Filtering sigma-points
    [chi,w] = smsp(M,S,kappa,system.nx);

    % Number of sigma-points
    % [Ins,Jns]=size(chi);
    Jns = 2*system.nx + 1;

    % Computation predictive sigma-points
    if nargin == 3 & system.nu > 0   % input passed as parameted and is defined in system
        for idx=1:1:Jns
            chip(:,idx) = nfeval(system.f,[u' chi(:,idx)' zeros(1, system.nw)]);
        end;
    else
        for idx=1:1:Jns  % input is not defined in the system
            chip(:,idx) = nfeval(system.f,[chi(:,idx)' zeros(1, system.nw)]);
        end;
    end;

    % Predictive mean of state
    Mp = chip*w' + gamma*pwmean;

    % Square-root of state predictive covariance matrix
    chip_ = chip - Mp(:,ones(1,Jns));
    chip_w = chip_.*sqrt(w(ones(1,system.nx),:));

    Sp = triag([chip_w gamma*Sq]);

    %display('Prediction')
    next.mean = Mp;
    next.var = Sp*Sp';
    next.sqrtvar = Sp;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% prediction


% CHANGELOG
