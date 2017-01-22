function [next] = prediction(p,last,u)
% PMF/PREDICTION - POINT MASS METHOD
% proceeds prediction step
% returns information structure about prediction pdf

% Nonlinear Filtering Toolbox version 2.0-rc4
% Copyright (c) 1995 - 2007 NFT developement Team,
%              Department of Cybernetics,
%              University of West Bohemia in Pilsen

system = get(p,'system');
f  = system.f;
pw = system.pw;
vgrid   = last.gridpts;
p_filt  = last.values;
Q  = var(system.pw);  % State noise covariance matrix

% Find nonnegligible grid points
I = find( p_filt > (p.parameters.epsilon/last.grngpts/last.grmass) );
grngpts_eta = length(I); % number of reduced grid points

% Time update - system dynamics applied to the grid
eta = zeros(last.dim,grngpts_eta);
zero_w = zeros(system.nw,1);
for i = 1:grngpts_eta
    if nargin == 3 && system.nu>0
        eta(:,i) = nfeval(f, [u; vgrid(:,I(i)); zero_w]);
    else
        eta(:,i) = nfeval(f, [vgrid(:,I(i)); zero_w]);
    end
end %for i

% Design a new grid
next    = agd( last,system,p.parameters,u,eta,I ); % Grid design by anticipative approach
vgrid   = next.gridpts;

% Compute predictive pdf values
p_pred  = zeros(1,next.grngpts);
for j = 1:length(p_pred)
    innov = repmat(vgrid(:,j), 1, grngpts_eta) - eta;  % prediction innovations for j-th new grid point and all old grid points
    p_pred(j) = p_filt(I) * evaluate(pw,innov)';
end

next = set( next, 'values', p_pred );
