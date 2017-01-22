function [gp] = lfstruct2gpdf(lfs)
%
%   gp = lfstruct2gpdf(lfs)
%
%           lfs - structured variable produced by derivative-free local
%                 filters
%           gp  - estimates in gpdf form
%
% Function transfers resulting estimates in ageneral structure produced by
% derivative-free local filters (e.g. the UKF, the DD1) into the Gaussian
% pdf (gpdf class).

% Nonlinear Filtering Toolbox version 2.0-rc4
% Copyright (c) 1995 - 2007 NFT developement Team,
%              Department of Cybernetics,
%              University of West Bohemia in Pilsen

for i=1:1:length(lfs) 
    gp{i} = gpdf(lfs{i}.mean,(lfs{i}.var + lfs{i}.var')/2);
end;