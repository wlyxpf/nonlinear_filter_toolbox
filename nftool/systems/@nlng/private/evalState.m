function stateVector = evalState(fun,hyperstate)
% stateVector = evalState(fun,hyperstate)
%   fun ... nonlinear vector function
%   hyperstate = [u; x; w] ... compsoition of input,
%                              state and noise vectors

% Nonlinear Filtering Toolbox version 2.0-rc4
% Copyright (c) 1995 - 2007 NFT developement Team,
%              Department of Cybernetics,
%              University of West Bohemia in Pilsen


stateVector = nfeval(fun,hyperstate);