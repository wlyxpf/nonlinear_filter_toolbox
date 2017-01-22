function [functionValue] = nfeval(p,point)
% NFEVAL - evaluating the function of the nffunction object p
%
% p         ... object of the class nfLinFunction
% point     ... vector value at whitch is the derivative evaluated
%

% Nonlinear Filtering Toolbox version 2.0-rc4
% Copyright (c) 1995 - 2007 NFT developement Team,
%              Department of Cybernetics,
%              University of West Bohemia in Pilsen

if length(point) ~= p.nvar
    error('Wrong number of input arguments');
else
    [ dim_row, dim_column ] = size(point);
    if dim_column > dim_row
        point = point';
    end
    valueTmp = 0;                        % initialization of function value

    if p.nu ~= 0                         % compute "B * u" if there exist u
        valueTmp = p.parametersValue(:,1:p.nu) * point(1:p.nu);
    end
    valueTmp = valueTmp + p.parametersValue(:,p.nu+1:p.nu+p.nx) ...
        * point(p.nu+1:p.nu+p.nx);       % add "A * x"

    functionValue = valueTmp + ...       % add "Gamma * xi"
        p.parametersValue(:,(p.nu+p.nx+1):(p.nu+p.nx)+p.nxi) ...
        * point((p.nu+p.nx+1):(p.nu+p.nx)+p.nxi); % return function value
end
