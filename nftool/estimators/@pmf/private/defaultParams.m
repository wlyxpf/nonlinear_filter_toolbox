function params = defaultParams(params)
% defaultParams assigns default values to point-mass filter parameters.

% Nonlinear Filtering Toolbox version 2.0-rc4
% Copyright (c) 1995 - 2007 NFT developement Team,
%              Department of Cybernetics,
%              University of West Bohemia in Pilsen

% Default parameter values:
params_default = struct('fixedNGPTS', [],      ...
    'epsilon',    1/10000, ...
    'a',          4,       ...
    'b',          4,       ...
    'gamma',      4/5,     ...
    'c',          4,       ...
    'ThriftyConvolution', 'off');

param_names = fieldnames(params);
for i = 1:length(param_names)
    if isempty( params.(param_names{i}) ) % parameter not set explicitly
        params.(param_names{i}) = params_default.(param_names{i});
    end
end
