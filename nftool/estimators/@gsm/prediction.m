function pred = prediction(p,filt,u)
% GSM/PREDICTION - proceeds prediction step
% returns information structure about
% predictive pdf
%

% Nonlinear Filtering Toolbox version 2.0-rc4
% Copyright (c) 1995 - 2007 NFT developement Team,
%              Department of Cybernetics,
%              University of West Bohemia in Pilsen

%****************************************************************
%**********   Preparation of prediction process  ****************
%****************************************************************
%---------------- Get parameters of filtering pdf ---------------
Mf             = filt.means;          % get mixture terms mean values
Vf             = filt.vars;           % get mixture terms variances
alpha_filt     = filt.weights;        % get mixture terms weights
filt_terms_num = filt.n_members;      % get No. of mixture terms

%----------- Setting the number of predictive pdf terms ---------
pred_terms_num = filt_terms_num*p.q;
alpha_pred = zeros(pred_terms_num,1); % create new weights vector

%---- Alocation of predictive pdf terms means and variances -----
Mp = cell(pred_terms_num,1);% initialization of cell of means
Vp = cell(pred_terms_num,1);% initialization of cell of variances

%************** Bank of Extended Kalman Predictors **************
system = p.system;                % get estimated system

for i=1:pred_terms_num,
    j=i-fix((i-1)/filt_terms_num)*filt_terms_num;
    n=1+fix((i-1)/filt_terms_num);

    %------------------ Evaluate i-th term weight ------------------
    alpha_pred(i) = alpha_filt(j)*p.w_weights(n);

    if nargin == 3 && system.nu>0
        %----------------- Evaluate derivative of f(x) -----------------
        F = nfdiff(system.f,[u' Mf{j}' zeros(1, system.nw)],system.x);
        %------------------ Evaluate function of f(x) ------------------
        f = nfeval(system.f,[u' Mf{j}' zeros(1, system.nw)]);
    else
        %----------------- Evaluate derivativ of f(x) -----------------
        F = nfdiff(system.f,[Mf{j}' zeros(1, system.nw)],system.x);
        %------------------ Evaluate function of f(x) ------------------
        f = nfeval(system.f,[Mf{j}' zeros(1, system.nw)]);
    end

    %------------------ Evaluate mean of i-th term -----------------
    Mp{i} = f + p.gamma*p.w_means{n};
    %---------------- Evaluate variance of i-th term ---------------
    Vp{i} = F*Vf{j}*F' + p.gamma*p.w_vars{n}*p.gamma';
    Vp{i} = (Vp{i}+Vp{i}')/2;       % ensure symetric variances
end

%******************** Return the filtering pdf *******************
pred = gspdf(alpha_pred,Mp,Vp);

% CHANGELOG

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%****************************************************************

