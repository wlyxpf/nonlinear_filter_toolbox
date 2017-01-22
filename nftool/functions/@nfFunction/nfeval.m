function [functionValue] = nfeval(p,point)
% NFEVAL - evaluating the function of the nffunction object p
%
% p         ... object of the class nffunction
% point     ... vector value at whitch is the multivariate function evaluated
%

% Nonlinear Filtering Toolbox version 2.0-rc4
% Copyright (c) 1995 - 2007 NFT developement Team,
%              Department of Cybernetics,
%              University of West Bohemia in Pilsen

if length(point) ~= p.nvar
    error('Not enough input arguments');
else
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % here should be defined the value of function
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    functionValue=[];
end
