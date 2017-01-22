function l = all_vars(s)
% L = ALL_VARS(S) extracts variables from the list
%

% Nonlinear Filtering Toolbox version 2.0-rc4
% Copyright (c) 1995 - 2007 NFT developement Team,
%              Department of Cybernetics,
%              University of West Bohemia in Pilsen

del = ',';
vars ={};
remainder = s;


while any(remainder)
    [chop,remainder] = strtok(remainder,del);
    vars{end+1} = chop;
end

l = vars;

% CHANGELOG