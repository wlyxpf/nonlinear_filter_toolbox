function [filt_weights,w_index] = nweights(p,pred,z)
% NWEIGHTS - calculate new weights of filtering pdf
%

% Nonlinear Filtering Toolbox version 2.0-rc4
% Copyright (c) 1995 - 2007 NFT developement Team,
%              Department of Cybernetics,
%              University of West Bohemia in Pilsen

%***************************** Initialization ***********************
%------------------- Get parameters of predictive pdf ---------------
Mp             = pred.means;          % get mixture terms mean values
Vp             = pred.vars;           % get mixture terms variances
alpha_pred     = pred.weights;        % get mixture terms weights
pred_terms_num = pred.n_members;      % get No. of mixture terms

%---------- Calculate new number of filtering mixtue members --------
filt_terms_num = pred_terms_num*p.r;
alpha_filt = zeros(filt_terms_num,1); % create new weights vector

%************************  Weight evaluation ************************
system = p.system;                    % get estimated system
zeta   = zeros(filt_terms_num,1);     % prepare auxilinary variable

for j = 1:filt_terms_num,
    i=j-fix((j-1)/pred_terms_num)*pred_terms_num;
    m=1+fix((j-1)/pred_terms_num);

    H = nfdiff(system.h,[Mp{i}' zeros(1, system.nv)],system.x);
    h_zeta = nfeval(system.h,[Mp{i}' zeros(1, system.nv)])+p.delta*p.v_means{m};

    zeta_var = H*Vp{i}*H'+p.v_vars{m};
    exponent = -((z-h_zeta)'*inv(zeta_var)*(z-h_zeta))/2;
    zeta(j)  = 1/(exp(system.nv*log(2*pi)/2)*sqrt(det(zeta_var)))*exp(exponent);
    alpha_filt(j) = alpha_pred(i)*p.v_weights(m)*zeta(j);
end

%**************************** Weights sorting *****************************
%pindex=zeros(filt_terms_num,1);
%max_weights=zeros(filt_terms_num,1);

[max_weights,pindex] = sort(-alpha_filt);
correction           = length(find(abs(max_weights)<=eps));


%-- return only non-zero normalized sorted weights and their index ---
if p.reduction ~= -1
    filt_terms_num=min(filt_terms_num-correction,p.reduction);
else
    filt_terms_num=filt_terms_num-correction;
end;

norm         = sum(max_weights(1:filt_terms_num));
filt_weights = max_weights(1:filt_terms_num)/norm;
w_index      = pindex(1:filt_terms_num);

