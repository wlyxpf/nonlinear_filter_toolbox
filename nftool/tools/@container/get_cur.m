function o = get_cur(p)
% GETS object from the actual position of the P 
% FUNCTION O = GET_CUR(P)
%

% Nonlinear Filtering Toolbox version 2.0-rc4
% Copyright (c) 1995 - 2007 NFT developement Team,
%              Department of Cybernetics,
%              University of West Bohemia in Pilsen

o = p.cont{p.pos}; %return current object

% CHANGELOG