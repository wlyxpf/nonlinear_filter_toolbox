function Sp = find_cov(pred)
%

% Nonlinear Filtering Toolbox version 2.0-rc4
% Copyright (c) 1995 - 2007 NFT developement Team,
%              Department of Cybernetics,
%              University of West Bohemia in Pilsen

% checking whether pred is of class gpdf or 'only' a structure

if isa(pred,'gpdf')
    Sp = chol(pred.var');            % decomposition of predictive covariance
else
    Sp = pred.sqrtvar;               % predictive covariance from previous prediction step
end;