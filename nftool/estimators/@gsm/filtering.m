function filt = filtering(p,pred,z)
% GSM/FILTERING - proceeds filtering step
%  return filtering probability dendity function
%

% Nonlinear Filtering Toolbox version 2.0-rc4
% Copyright (c) 1995 - 2007 NFT developement Team,
%              Department of Cybernetics,
%              University of West Bohemia in Pilsen

%****************************************************************
%**********   Preparation of filtering process   ****************
%****************************************************************
%----------------- Get parameters of predictive pdf -------------
Mp             = pred.means;      % get mixture terms mean values
Vp             = pred.vars;       % get mixture terms variances
alpha_pred     = pred.weights;    % get mixture terms weights
pred_terms_num = pred.n_members;  % get No. of mixture terms

%--- calculation of new filtering weights and their reduction ---
[filt_weights,w_index] = nweights(p,pred,z);
filt_terms_num         = length(filt_weights);

%------ Alocation of filtering pdf terms means and variances ----
Mf = cell(filt_terms_num,1);% initialization of cell of means
Vf = cell(filt_terms_num,1);% initialization of cell of variances

%**************** Bank of Extended Kalman Filters ****************
system = p.system;                % get estimated system

for l=1:filt_terms_num,
    j=w_index(l);
    i=j-fix((j-1)/pred_terms_num)*pred_terms_num;
    m=1+fix((j-1)/pred_terms_num);

    %----------------- Evaluate derivative of h(x) -----------------
    H = nfdiff(system.h,[Mp{i}' zeros(1, system.nv)],system.x);
    %------------------ Evaluate function of h(x) ------------------
    h = nfeval(system.h,[Mp{i}' zeros(1, system.nv)]);
    %--------------------- Evaluate Kalman gain --------------------
    K = kalman_gain(p,Vp{i},H,p.v_vars{m},p.delta);
    %------------------ Evaluate Ricatti equation ------------------
    Vf{l} = riccati(p,Vp{i},K,H,p.v_vars{m},p.delta);
    %------------------ Evaluate mean of j-th term -----------------
    Mf{l} = Mp{i} + K*(z - h - p.delta*p.v_means{m});
    Vf{l} = (Vf{l}+Vf{l}')/2;       % ensure symetric variances
end

%******************** Return the filtering pdf *******************
filt = gspdf(filt_weights,Mf,Vf);


% CHANGELOG

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%****************************************************************

