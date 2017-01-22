function [filt]=filtering(p,pred,z)
% PMF/FILTERING - POINT MASS METHOD
% proceeds filtering step
% returns information structure about filtering pdf

% Nonlinear Filtering Toolbox version 2.0-rc4
% Copyright (c) 1995 - 2007 NFT developement Team,
%              Department of Cybernetics,
%              University of West Bohemia in Pilsen

system = get(p,'system');
h  = system.h;
nv = system.nv;
vgrid  = pred.gridpts;
grmass = pred.grmass;

% Filtering
innov = zeros(nv,size(vgrid,2));  % filtering innovations for all grid points

zero_v = zeros(nv,1);
for i = 1:length(innov)
    innov(:,i) = z - nfeval(h,[vgrid(:,i);zero_v]);
end

filt = set( pred, 'values', pred.values .* evaluate(system.pv,innov) );
