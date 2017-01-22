function p = set_cur(p,o)
% SETS the actual position of the P to O
% FUNCTION P = SET_CUR(P,O)
%

% Nonlinear Filtering Toolbox version 2.0-rc4
% Copyright (c) 1995 - 2007 NFT developement Team,
%              Department of Cybernetics,
%              University of West Bohemia in Pilsen

p.cont{p.pos} = o; %set element in current pos


% CHANGELOG