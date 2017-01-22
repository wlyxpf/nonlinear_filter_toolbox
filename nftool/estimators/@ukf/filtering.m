function [filt]=filtering(p,pred,z)
% UKF/FILTERING - proceeds filtering step
% returns information structure about
% filtering pdf
%

% References:
% S.J. Julier, J. K. Uhlmann and H. F. Durrant-White (2000):
% A new method for the nonlinear transformation of means and covariances in filters and estimators.
% IEEE Trans. On AC 45(3), 477–482.
%
% M. Simandl, and J. Dunik (2005):
% Sigma point gaussian sum filter design using square root unscented filters.
% In: Preprints of 16th IFAC World Congress. Prague, Czech Republic.

% Nonlinear Filtering Toolbox version 2.0-rc4
% Copyright (c) 1995 - 2007 NFT developement Team,
%              Department of Cybernetics,
%              University of West Bohemia in Pilsen

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% variables
system = get(p,'system');       % system

Mp = pred.mean;                % mean of prediction
Vp = pred.var;                 % variance of prediction

pvmean = mean(system.pv);       % mean of measurement noise
R = var(system.pv);             % variance of measurement noise

delta = system.delta;           % the DELTA matrix of system

kappa = p.kappa;                % scaling parameter kappa

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if strcmp(p.at,'standard')
    % Computation of predictive sigma points
    [chip,w] = msp(Mp,Vp,kappa,system.nx);

    % Number of sigma points Jns
    % [Ins,Jns]=size(chip);
    Jns = 2*system.nx + 1;

    % Points for computation prediction of measurement
    for idx=1:1:Jns
        dzetap(:,idx) = nfeval(system.h,[chip(:,idx)' zeros(1, system.nv)]);
    end;

    [Ins,Jns]=size(dzetap);
    %Ins = system.nv;

    %Prediction of measurement
    zp = dzetap*w' + delta*pvmean;

    %Measurement predictive covariance matrix
    dzetap_ = dzetap - zp(:,ones(1,Jns));
    dzetap_w = dzetap_.*w(ones(1,Ins),:);

    Pzzp = dzetap_w*dzetap_' + delta*R*delta';

    %Cross-correlation predictive matrix between x and z
    chip_ = chip - Mp(:,ones(1,Jns));

    Pxzp = chip_*dzetap_w';

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Kalman gain
    K = Pxzp * inv(Pzzp);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % filtering mean and variance
    if (sum(sum(isnan(K))) == 0) & (sum(sum(isinf(K))) == 0)

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % filtering mean
        M = Mp + K * (z - zp);

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % filtering covariance matrix
        V = Vp - K * (Pzzp) * K'; %upraveno

    else

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % filtering statistics
        M = Mp;

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        V = zeros(size(Vp));
    end

    %result
    %filt = gpdf(M,(V + V')/2);
    filt.mean = M;
    filt.var = V;
elseif strcmp(p.at,'squareroot')
    % necessary variables
    Sp = find_cov(pred);    % square-root predictive covariance matrix
    Sr = chol(R');          % decomposition of measurement noise variance

    % Computation of predictive sigma points
    [chip,w] = smsp(Mp,Sp,kappa,system.nx);

    % Number of sigma points Jns
    % [Ins,Jns]=size(chip);
    Jns = 2*system.nx + 1;

    % Points for computation prediction of measurement
    for idx=1:1:Jns
        dzetap(:,idx) = nfeval(system.h,[chip(:,idx)' zeros(1, system.nv)]);
    end;

    [Ins,Jns]=size(dzetap);
    %Ins = system.nv;

    % Prediction of measurement
    zp = dzetap*w' + delta*pvmean;

    % Square-root of measurement predictive covariance matrix
    dzetap_ = dzetap - zp(:,ones(1,Jns));
    dzetap_w = dzetap_.*sqrt(w(ones(1,Ins),:));

    %Szp = triag([dzetap_w delta*Sr]);
    Szp = [dzetap_w delta*Sr];

    % Square-root of cross-correlation predictive matrix between x and z
    chip_ = chip - Mp(:,ones(1,Jns));
    chip_w = chip_.*sqrt(w(ones(1,system.nx),:));

    Pxzp = chip_w*dzetap_w';

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Kalman gain
    K = Pxzp/Szp'/Szp;

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % filtering mean and variance
    if (sum(sum(isnan(K))) == 0) & (sum(sum(isinf(K))) == 0)

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % filtering mean
        M = Mp + K * (z - zp);

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % filtering covariance matrix
        S = triag([chip_w-K*dzetap_w K*Sr]);
    else

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % filtering statistics
        M = Mp;

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        S = zeros(size(Sp));
    end

    %result
    %filt = gpdf(M,(V + V')/2);
    filt.mean = M;
    filt.var = S*S';
    filt.sqrtvar = S;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% CHANGELOG 
